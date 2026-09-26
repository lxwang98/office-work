#!/usr/bin/env bash
# ===========================================================================
#  职场办公模式 —— DeepSeek Harness Agent 预设安装脚本（macOS / Linux）
#
#  用法（在本文件所在目录执行）：
#      bash install-macos.sh
# ===========================================================================

set -u

echo "=========================================================="
echo "  安装 DeepSeek Harness 预设：职场办公模式"
echo "=========================================================="
echo

# ---- 1. 本脚本所在目录 ----
SOURCE="$(cd "$(dirname "$0")" && pwd)"
if [ ! -f "$SOURCE/agent.cordis.yml" ]; then
    echo "[错误] 当前目录里找不到 agent.cordis.yml"
    echo "       请把完整的预设文件夹解压后再运行本脚本。"
    echo "       当前目录：$SOURCE"
    exit 1
fi
echo "  预设来源：$SOURCE"

# ---- 2. 找 DSH 主目录 ----
# 优先用 DSH_HOME 环境变量；没有就用默认的 ~/.dsh
if [ -n "${DSH_HOME:-}" ]; then
    DSH_DIR="$DSH_HOME"
    echo "  检测到 DSH_HOME：$DSH_DIR"
else
    DSH_DIR="$HOME/.dsh"
    echo "  未设置 DSH_HOME，使用默认位置。"
fi

if [ ! -d "$DSH_DIR" ]; then
    echo "[错误] 找不到 DSH 主目录：$DSH_DIR"
    echo "       请确认已安装 DeepSeek Harness；"
    echo "       如果装在别处，请先执行 export DSH_HOME=/你的路径 再运行本脚本。"
    exit 1
fi

# ---- 3. 目标位置 ----
PRESET_DIR="$DSH_DIR/.agent-presets"
TARGET="$PRESET_DIR/office-work"
echo "  安装目标：$TARGET"
echo

# 已装过就先备份
if [ -d "$TARGET" ]; then
    BACKUP="$TARGET.bak-$(date +%Y%m%d-%H%M%S)"
    echo "  检测到已安装的旧版本，先备份到："
    echo "    $BACKUP"
    mv "$TARGET" "$BACKUP"
fi

# ---- 4. 复制（只复制预设需要的三样，不带 .git / README）----
mkdir -p "$PRESET_DIR" "$TARGET"
for item in agent.cordis.yml preset.yml skills; do
    if [ -e "$SOURCE/$item" ]; then
        cp -R "$SOURCE/$item" "$TARGET/"
        echo "  + $item"
    else
        echo "  ! 缺少 $item（可能影响预设加载）"
    fi
done

# ---- 5. 校验 ----
echo
OK=1
for must in "agent.cordis.yml" "preset.yml" "skills/office-writing/SKILL.md"; do
    if [ -f "$TARGET/$must" ]; then
        echo "  [OK] $must"
    else
        echo "  [缺失] $must"
        OK=0
    fi
done

echo
echo "=========================================================="
if [ "$OK" = "1" ]; then
    echo "  安装完成！"
    echo "=========================================================="
    echo
    echo "  接下来："
    echo "    1. 重启 DeepSeek Harness（预设是启动时读取的）"
    echo "    2. 新建会话时，在预设列表里选择「职场办公模式」"
    echo
else
    echo "  安装不完整，请检查上面的 [缺失] 项。"
    echo "=========================================================="
    exit 1
fi
