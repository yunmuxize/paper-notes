#!/usr/bin/env bash
# pdf2zh-next 论文双栏翻译封装（v4 — 验证通过的最佳方案）
# 用法: babeldoc-translate.sh <input.pdf> [输出目录] [页码] [lang-out]
#   input.pdf     输入论文 PDF
#   输出目录       默认 ./babeldoc-output
#   页码           默认全部，例 "1-5" 或 "1,3,5-10"
#   lang-out       默认 zh-CN
#
# 方案: pdf2zh-next (BabelDOC 编排层) + GLM-5.2 + JSON mode
#   - GLM-5.2 响应快、中文质量好；--openai-enable-json-mode 强制 JSON 输出避免解析错误
#   - pdf2zh-next 的错误处理/限速比裸 babeldoc 更成熟，不会卡在失败段落死循环
#   - 产出: *.zh-CN.dual.pdf（中英对照双栏）+ *.zh-CN.mono.pdf（纯中文）
#   - 实测 10 页论文: 29 分钟，0 段漏翻，WARNING 仅 26 条
set -euo pipefail

INPUT="${1:?用法: babeldoc-translate.sh <input.pdf> [输出目录] [页码] [lang-out]}"
OUTDIR="${2:-./babeldoc-output}"
PAGES="${3:-}"
LANG_OUT="${4:-zh-CN}"
LANG_IN="en"

command -v pdf2zh_next >/dev/null || { echo "ERROR: pdf2zh_next 未安装（uv tool install --python 3.12 pdf2zh-next，再 pin bitstring<5）" >&2; exit 1; }
: "${PCL_API_KEY:=$(grep -oP '(?<=^export PCL_API_KEY=")[^"]+' "$HOME/.bashrc" 2>/dev/null || true)}"
[ -n "${PCL_API_KEY:-}" ] || { echo "ERROR: PCL_API_KEY 未设置" >&2; exit 1; }
[ -f "$INPUT" ] || { echo "ERROR: 输入文件不存在: $INPUT" >&2; exit 1; }

mkdir -p "$OUTDIR"
unset ALL_PROXY HTTPS_PROXY HTTP_PROXY all_proxy https_proxy http_proxy

PAGE_ARG=()
[ -n "$PAGES" ] && PAGE_ARG=(--pages "$PAGES")

echo "==> pdf2zh-next 翻译: $INPUT"
echo "    模型: DeepSeek-V4-Flash-0731 + JSON mode @ PCL | 方向: $LANG_IN -> $LANG_OUT"
echo "    输出: $OUTDIR"
echo

pdf2zh_next "$INPUT" \
  --lang-in "$LANG_IN" --lang-out "$LANG_OUT" \
  --openai \
  --openai-model "DeepSeek-V4-Flash-0731" \
  --openai-base-url "https://llmapi.pcl.ac.cn/v1" \
  --openai-api-key "$PCL_API_KEY" \
  --openai-enable-json-mode \
  --qps 4 \
  --output "$OUTDIR" \
  --ignore-cache \
  "${PAGE_ARG[@]}" 2>&1 | tee "$OUTDIR/translate.log"

echo
echo "==> 质量验证..."
VENV="${HOME}/.local/share/uv/tools/babeldoc"
MONO=$(ls "$OUTDIR"/*.mono.pdf 2>/dev/null | head -1)
if [ -z "$MONO" ]; then
  echo "WARNING: 未找到 mono.pdf"
  ls -lh "$OUTDIR"/*.pdf 2>/dev/null
  exit 0
fi

"$VENV/bin/python" - "$MONO" <<'PYEOF'
import pymupdf, re, sys
mono = sys.argv[1]
d = pymupdf.open(mono)
total_cjk = 0; total_en = 0; body_untrans = 0
for i, page in enumerate(d):
    txt = page.get_text()
    total_cjk += len(re.findall(r'[\u4e00-\u9fff]', txt))
    total_en += len(re.findall(r'[A-Za-z]{4,}', txt))
    for run in re.findall(r'(?:[A-Za-z][A-Za-z ,\.\-:/\(\)]{60,})', txt):
        if re.search(r'[\u4e00-\u9fff]', run): continue
        low = run.lower()
        if re.search(r'\bet al\b|\bproc\.|\bvol\.|\bpp\.|\bno\.|"[^"]+"|,\s*\d{4}\b', low): continue
        if re.search(r'\b(the|is|are|we|this|that|with|for)\b', low): body_untrans += 1

print(f"  中文={total_cjk}  英文词={total_en}  正文未翻={body_untrans}")
if body_untrans == 0:
    print("  ✅ 翻译完整，无正文残留")
elif body_untrans <= 5:
    print(f"  ℹ️ 轻微: {body_untrans} 段未翻译")
else:
    print(f"  ⚠️ 警告: {body_untrans} 段未翻译，可能需要补译")
PYEOF

echo
echo "==> 产物："
ls -lh "$OUTDIR"/*.pdf 2>/dev/null
