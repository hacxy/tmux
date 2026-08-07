# 状态栏（catppuccin macchiato）配置说明

> 来源：[catppuccin/tmux discussion #317](https://github.com/catppuccin/tmux/discussions/317#discussioncomment-10890888)
> 风格启发自 hyprland / polybar，状态栏位于**顶部**。

## 依赖插件

| 插件 | 用途 | 说明 |
|---|---|---|
| `catppuccin/tmux` | 主题配色 | 提供 `#{@thm_*}` 颜色变量（macchiato 风味） |
| `tmux-plugins/tmux-online-status` | 网络状态 | 默认 `ping www.google.com`，提供 `#{online_status}` |

## 布局

**status-left**（左→右）：

```
[会话指示器 前缀激活时红底] │ [当前命令] │ [当前目录(截断32字符, $USER→~)] │ [zoom 指示]
```

**status-right**（右→左）：

```
[网络 on/off] │ [日期 时间]
```

**窗口标签**：默认只显示编号（` #I `），手动重命名窗口后才显示 `编号: 名字`。
最后一个窗口用 peach 色，活动窗口 peach 底，活动/铃响窗口红底。

## 关键踩坑点（集成时已处理）

1. **插件变量插值顺序**：tmux-online-status 通过把 `#{online_status}`
   **文本替换**为 `#(脚本)` 的方式提供值，替换只发生在插件加载（`run tpm`）时。
   手动设置 `status-left/right` 会覆盖掉已替换的内容，因此 `tmux.conf` 末尾需要**再次执行**：
   ```tmux
   run-shell ~/.config/tmux/plugins/tmux-online-status/online_status.tmux
   ```
   若省略，状态栏中 `#{online_status}` 将显示为空。

2. **Nerd Font 图标**：状态栏图标用 `\uXXXX` 转义书写（如 `\ue8c8`），tmux 3.x 直接解析为字形，
   比粘贴原始字符更不易乱码。需终端安装并选用 Nerd Font。

## 常用调整

| 想改什么 | 配置 |
|---|---|
| 主题风味（latte/frappe/macchiato/mocha） | `set -g @catppuccin_flavor "mocha"` |
| 网络检测目标 | `set -g @route_to_ping "baidu.com"` |
| 联网/断网文案 | `set -g @online_icon "ok"` / `set -g @offline_icon "nok"` |
| 状态栏刷新间隔（online 检测延迟） | `set -g status-interval 5`（默认 15 秒） |
| 状态栏回底部 | `set -g status-position bottom` |

改完执行 `tmux source-file ~/.config/tmux/tmux.conf` 生效。
