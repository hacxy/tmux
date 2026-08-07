# tmux-fzf-url 插件用法

> `prefix + u` 弹出 fzf 弹窗，列出当前窗格中所有 URL，可模糊搜索过滤，回车直接打开。
> 已通过 [TPM](https://github.com/tmux-plugins/tpm) 安装（**legacy 分支**，见下方说明）。

## 为什么用 legacy 版本

主版本依赖 Rust 工具 [`xre`](https://github.com/wfxr/xre) 提取 URL（首次使用自动下载安装），
但 **xre 0.1.1 没有 macOS ARM（Apple Silicon）预编译二进制**，安装必然 404 失败。

因此本项目固定在官方提供的 **legacy 分支**（`wfxr/tmux-fzf-url#legacy`）：
用 `grep` 提取 URL，无任何额外依赖，功能一致，只是不支持自定义提取正则（`@fzf-url-custom-pat`）。

## 使用流程

1. 在任意窗格按 `prefix + u`（本项目前缀键为 `<C-a>`，即 `C-a u`）
2. 屏幕中央弹出 fzf 弹窗，列出当前窗格**屏幕内**可见的所有 URL（`https://`、`http://`、`www.`、IP、git@ 等）
3. 输入关键字模糊过滤（fzf 特性），或 `Tab` 多选
4. `Enter` 打开选中项（macOS 用 `open`，Linux 用 `xdg-open`，可用 `@fzf-url-open` 覆盖）
5. `ctrl-y` 复制选中 URL 到剪贴板而不打开（弹窗不关闭，可继续操作）
6. `Esc` 退出

> 默认只提取**当前屏幕**内容；如需包含回滚历史，设置 `@fzf-url-history-limit`（见配置表）。

## 支持的 URL 类型（legacy 提取规则）

| 类型 | 示例 | 打开时处理 |
|---|---|---|
| 标准 URL | `https://example.com/a?b=1`、`ftp://…`、`file://…` | 原样打开 |
| WWW 地址 | `www.example.com` | 自动补 `http://` |
| IP 地址 | `192.168.1.1:8080/path` | 自动补 `http://` |
| Git SSH | `git@github.com:user/repo` | 转换为 `https://github.com/user/repo` |
| GitHub 简写 | `'user/repo'`（引号内） | 转换为 `https://github.com/user/repo` |

## 配置项

在 `tmux.conf` 中设置（改完 `tmux source-file ~/.config/tmux/tmux.conf` 或 `<prefix> I` 重载）：

| 配置项 | 默认值 | 作用 |
|---|---|---|
| `@fzf-url-bind` | `u` | 修改触发按键（如 `set -g @fzf-url-bind 'x'`） |
| `@fzf-url-history-limit` | `screen` | 捕获回滚历史行数，如 `set -g @fzf-url-history-limit '2000'` |
| `@fzf-url-open` | 自动 | 自定义打开命令，如 `set -g @fzf-url-open 'firefox'` |
| `@fzf-url-copy-cmd` | 自动 | 复制命令（macOS 自动用 `pbcopy`），如 `set -g @fzf-url-copy-cmd 'pbcopy'` |
| `@fzf-url-extra-filter` | 空 | 额外的 URL 过滤规则 |
| `@fzf-url-fzf-options` | 空 | 自定义 fzf 弹窗参数，如 `set -g @fzf-url-fzf-options '-w 60% -h 40% --no-border'` |

## 与 tmux-open 的分工

| 场景 | 用哪个 |
|---|---|
| 想一眼看到窗格里**所有**链接、过滤选择 | `prefix + u`（tmux-fzf-url） |
| 复制模式下**光标处**的链接/文件，选中即开 | 复制模式内 `o` / `C-o`（tmux-open） |

两个插件互补，互不冲突（`u` 绑定在 prefix 表，`o` 绑定在 copy-mode-vi 表）。

## 故障排查

- **按 `prefix + u` 弹窗空白**：当前屏幕确实没有可识别的 URL；或用 `@fzf-url-history-limit` 扩大提取范围。
- **`Enter` 没打开**：检查是否有自定义 `@fzf-url-open` 覆盖；macOS 默认走 `open`。
- **想改按键**：`set -g @fzf-url-bind 'x'`，重载后按 `prefix + x`。
- **升级提示**：若未来 xre 提供 macOS ARM 二进制，可改回 `set -g @plugin 'wfxr/tmux-fzf-url'`（去掉 `#legacy`）。

## 参考

- 插件仓库：https://github.com/wfxr/tmux-fzf-url
- legacy 分支说明：README 中 "Legacy version (no `xre` dependency)"
- TPM：https://github.com/tmux-plugins/tpm
