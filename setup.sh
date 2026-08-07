#!/usr/bin/env bash
# setup.sh — 安装 tpm 及 tmux.conf 中声明的所有插件
# 幂等：可重复执行，已安装的会自动跳过
# 用法: ./setup.sh

set -euo pipefail

# 脚本所在目录即 tmux 配置目录
TMUX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGINS_DIR="$TMUX_DIR/plugins"
TPM_DIR="$PLUGINS_DIR/tpm"

# 检查依赖
for cmd in git tmux; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "错误: 未找到 $cmd，请先安装" >&2
        exit 1
    fi
done

# 1. 安装 tpm
if [ -d "$TPM_DIR" ]; then
    echo "tpm 已存在，跳过: $TPM_DIR"
else
    echo "正在克隆 tpm ..."
    mkdir -p "$PLUGINS_DIR"
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# 2. 安装 tmux.conf 中声明的插件（tmux-sensible、tmux-yank 等）
# tpm 通过 tmux 全局环境变量 TMUX_PLUGIN_MANAGER_PATH 定位插件目录，
# 此处手动注册，避免已运行的 tmux 服务器因启动时 tpm 尚不存在而未设置该变量
tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "$PLUGINS_DIR/"
echo "正在通过 tpm 安装插件 ..."
"$TPM_DIR/bin/install_plugins"

echo ""
echo "完成 ✨"
echo "提示: 若 tmux 正在运行，可在会话内按 <prefix> I（即 <C-a> I）重装插件，或重启 tmux。"
