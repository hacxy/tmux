#!/bin/bash
# 状态栏样式切换: 自定义(透明+改色) ⇄ catppuccin 插件原始样式
# 绑定: prefix+T (见 tmux.conf)
# 原理: 以 status-bg 是否为 default 判断当前状态
#   - default → 处于自定义样式, 重新运行 catppuccin 插件恢复原始样式
#   - 其他值   → 处于插件原始样式, source 自定义覆盖文件

CUSTOM_CONF="$HOME/.config/tmux/tmux.status-custom.conf"
CATPPUCCIN="$HOME/.config/tmux/plugins/catppuccin-tmux/catppuccin.tmux"

if tmux show -g status-bg | grep -q "default"; then
    # 当前是自定义 → 恢复插件原始样式 (静默运行, 同 TPM 加载插件的方式)
    "$CATPPUCCIN" >/dev/null 2>&1
    tmux display-message "状态栏: catppuccin 原始样式"
else
    # 当前是插件原始 → 应用自定义样式
    tmux source-file "$CUSTOM_CONF"
    tmux display-message "状态栏: 自定义样式 (透明)"
fi
