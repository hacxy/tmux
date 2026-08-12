# 个人 tmux 配置

> 基于 [TPM](https://github.com/tmux-plugins/tpm) 插件管理器的完整 tmux 配置,内置 catppuccin 主题、会话持久化、模糊搜索、浮动窗格等 11 个插件。
> 本 README 面向第一次使用这份配置的用户,读完即可上手全部技巧。

---

## 目录

- [核心概念:prefix](#核心概念prefix)
- [安装与依赖](#安装与依赖)
- [会话管理](#会话管理)
- [窗口管理](#窗口管理)
- [窗格管理(分屏)](#窗格管理分屏)
- [复制粘贴](#复制粘贴)
- [插件功能速查](#插件功能速查)
- [主题与状态栏](#主题与状态栏)
- [自动保存与恢复](#自动保存与恢复)
- [配置文件结构](#配置文件结构)
- [需要按个人情况调整的地方](#需要按个人情况调整的地方)
- [常见问题](#常见问题)

---

## 核心概念:prefix

tmux 的所有快捷键都通过一个 **前缀键(prefixed key)** 触发。本配置将默认的 `Ctrl+B` 改成了 **`Ctrl+A`**。

> 本文中所有 `prefix+?` 均指:先按 `Ctrl+A` 松开,再按 `?`。例如 `prefix+v` = 按 `Ctrl+A`,再按 `v`。

**最常见的三个动作,请先记住:**

| 动作           | 快捷键     | 说明               |
| -------------- | ---------- | ------------------ |
| 分屏(左右)     | `prefix+v` | 当前目录下垂直分屏 |
| 分屏(上下)     | `prefix+s` | 当前目录下水平分屏 |
| 切到上一个窗口 | `prefix+a` | 即 `Ctrl+A Ctrl+A` |

随时可以用 `prefix+?` 查看当前所有键位绑定。

---

## 安装与依赖

### 前置依赖

| 依赖                                                           | 用途                                     | 安装                      |
| -------------------------------------------------------------- | ---------------------------------------- | ------------------------- |
| [tmux](https://github.com/tmux/tmux/wiki) (>= 3.x)             | 本体                                     | `brew install tmux`       |
| [fzf](https://github.com/junegunn/fzf)                         | tmux-fzf / sessionx / fzf-url 的模糊搜索 | `brew install fzf`        |
| [zoxide](https://github.com/ajeetdsouza/zoxide)                | sessionx 的目录跳转模式(配置中已开启)    | `brew install zoxide`     |
| [ical-buddy](https://github.com/ali-rantakari/icalBuddy)(可选) | `scripts/cal.sh` 会议提醒脚本(默认注释)  | `brew install ical-buddy` |
| `pbcopy` / `pbpaste`                                           | macOS 自带,复制粘贴到系统剪贴板          | 无需安装                  |

> `brew` 安装后若 fzf 未加入 PATH,请按 Homebrew 提示执行 `eval "$(/opt/homebrew/bin/brew shellenv)"`。

### 安装步骤

```bash
# 1. 克隆本配置(若尚未克隆)
git clone https://github.com/hacxy/tmux ~/.config/tmux

# 2. 克隆 TPM 插件管理器(路径必须匹配 tmux.conf 中的引用)
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# 3. 启动 tmux,安装所有插件
tmux
#    然后按: prefix + I  (Ctrl+A 后按大写 I)
#    看到 "TMUX environment reloaded" 即安装完成
```

### 日常维护命令

| 快捷键         | 功能                                |
| -------------- | ----------------------------------- |
| `prefix+I`     | 安装 tmux.conf 中声明的新插件       |
| `prefix+U`     | 更新所有插件                        |
| `prefix+Alt+U` | 清理已从配置中移除的插件            |
| `prefix+R`     | 重新加载配置(改完 tmux.conf 后执行) |

---

## 会话管理

会话(Session)是 tmux 的最高层级,一个会话包含多个窗口。这份配置里用 `sessionx` + `zoxide` 做成了"一键搜索并切换"的体验。

| 快捷键                       | 功能                                                               |
| ---------------------------- | ------------------------------------------------------------------ |
| `prefix+o`                   | **打开 sessionx**:模糊搜索已有会话;输入不存在的名字回车 = 新建会话 |
| `prefix+S`                   | 原生选择会话列表(choose-session)                                   |
| `prefix+d` / `prefix+Ctrl+D` | 脱离当前会话(回到终端,会话在后台继续运行)                          |
| `prefix+$`                   | 重命名当前会话                                                     |

**sessionx 弹窗内操作:**

| 键                  | 功能                                            |
| ------------------- | ----------------------------------------------- |
| 输入 + 回车         | 切换到已有会话 / 新建同名会话                   |
| `Alt+Backspace`     | 删除选中的会话                                  |
| `Ctrl+P` / `Ctrl+N` | 上 / 下选择                                     |
| `Ctrl+U` / `Ctrl+D` | 预览区上 / 下滚动                               |
| `Ctrl+Y`            | 新建窗口(已绑定 `@sessionx-bind-zo-new-window`) |

> sessionx 开启了 zoxide 模式(`@sessionx-zoxide-mode on`),输入时会优先匹配常用目录,可快速基于目录新建会话。

---

## 窗口管理

窗口(Window)相当于浏览器标签页。

| 快捷键                         | 功能                           |
| ------------------------------ | ------------------------------ |
| `prefix+Ctrl+C`                | 新建窗口(在 `$HOME` 目录)      |
| `prefix+a`(即 `Ctrl+A Ctrl+A`) | 切换到上一个窗口(来回切换利器) |
| `prefix+H` / `prefix+L`        | 上一个 / 下一个窗口            |
| `prefix+w` / `prefix+Ctrl+W`   | 窗口列表                       |
| `prefix+r`                     | 重命名当前窗口                 |
| `prefix+"`                     | 弹出窗口选择器                 |
| `prefix+&`                     | 关闭当前窗口(需确认)           |
| `prefix+f`                     | 模糊查找窗口(find-window)      |

窗口自动编号(`renumber-windows on`),关闭任意窗口后编号自动补齐,不会出现空洞。

---

## 窗格管理(分屏)

窗格(Pane)是窗口内的分屏区域。

### 分屏

| 快捷键                   | 功能                           |
| ------------------------ | ------------------------------ |
| `prefix+v` / `prefix+\|` | 左右分屏(垂直分割)             |
| `prefix+s`               | 上下分屏(水平分割)             |
| `prefix+%`               | tmux 原生水平分割(等效)        |
| `prefix+p`               | **浮动窗格**(floax,见插件章节) |

> `v` / `s` 会保留当前目录(`pane_current_path`),在你当前的 git 项目里分屏直接就能用。

### 切换与移动

| 快捷键                       | 功能                                          |
| ---------------------------- | --------------------------------------------- |
| `prefix+h` / `j` / `k` / `l` | 按方向切换窗格(与 vim 一致)                   |
| `prefix+;`                   | 切换到上一个窗格                              |
| `prefix+x`                   | 当前窗格向下交换(swap-pane)                   |
| `prefix+{` / `prefix+}`      | 与上一个 / 下一个窗格交换位置                 |
| `prefix+c`                   | **关闭当前窗格**(kill-pane,注意不是新建窗口!) |

### 调整大小(可按住重复)

| 快捷键                  | 功能                |
| ----------------------- | ------------------- |
| `prefix+,` / `prefix+.` | 向左 / 向右调 20 格 |
| `prefix+-` / `prefix+=` | 向下 / 向上调 7 格  |
| `prefix+Alt+方向键`     | 微调 5 格           |

### 布局与缩放

| 快捷键           | 功能                                               |
| ---------------- | -------------------------------------------------- |
| `prefix+z`       | 最大化 / 还原当前窗格(zoomed)                      |
| `prefix+Alt+1~7` | 一键套用布局(even-horizontal / tiled 等)           |
| `prefix+Alt+o`   | 旋转窗口布局                                       |
| `prefix+q`       | 显示每个窗格的编号                                 |
| `prefix+*`       | **同步所有窗格输入**(synchronize-panes,再次按取消) |
| `prefix+P`       | 循环切换窗格边框状态(pane-border-status)           |

---

## 复制粘贴

配置了 `tmux-yank` + macOS 系统剪贴板(`pbcopy`),复制的内容可以直接粘贴到任何应用。

### 复制模式(vi 风格)

| 步骤            | 操作                      |
| --------------- | ------------------------- |
| 1. 进入复制模式 | `prefix+[`                |
| 2. 开始选择     | `v` 或 `Space`            |
| 3. 移动选择     | `h` `j` `k` `l`(vim 键位) |
| 4. 复制并退出   | `y`                       |

### 复制模式内快捷键

| 键            | 功能                     |
| ------------- | ------------------------ |
| `v` / `Space` | 开始选择                 |
| `y`           | 复制到系统剪贴板并退出   |
| `Y`           | 粘贴(put-buffer)         |
| `D`           | 复制光标到行尾           |
| `!`           | 复制(去掉换行符)         |
| `Enter`       | 复制并退出               |
| `/` / `?`     | 向下 / 向上搜索          |
| `n` / `N`     | 下一个 / 上一个搜索结果  |
| `gg` / `G`    | 跳到顶部 / 底部          |
| `prefix+]`    | 在普通模式粘贴剪贴板内容 |

### 快捷复制(不用进复制模式)

| 快捷键         | 功能                                                                                      |
| -------------- | ----------------------------------------------------------------------------------------- |
| `prefix+y`     | 一键复制当前行到剪贴板                                                                    |
| `prefix+Y`     | 一键复制当前窗格的路径(如在 git 项目里,直接拿到目录路径)                                  |
| `prefix+Space` | **tmux-thumbs**:屏幕上每个可复制词块都显示一个字符提示,按对应字符即复制(比手动框选快得多) |
| 鼠标拖拽       | 选中即复制                                                                                |
| 双击 / 三击    | 选中单词 / 整行并复制                                                                     |

---

## 插件功能速查

| 插件                                                             | 触发方式                          | 功能                                  |
| ---------------------------------------------------------------- | --------------------------------- | ------------------------------------- |
| [tpm](https://github.com/tmux-plugins/tpm)                       | `prefix+I/U/Alt+U`                | 插件安装 / 更新 / 清理                |
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible)   | 自动                              | 合理默认值(鼠标、窗口缩放、UTF-8 等)  |
| [tmux-yank](https://github.com/tmux-plugins/tmux-yank)           | 见上节                            | 系统剪贴板复制                        |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | `prefix+Ctrl+S` / `prefix+Ctrl+R` | 手动保存 / 恢复会话                   |
| [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) | 自动                              | 每 15 分钟自动保存,启动 tmux 自动恢复 |
| [tmux-thumbs](https://github.com/fcsonline/tmux-thumbs)          | `prefix+Space`                    | 字符提示快速复制                      |
| [tmux-fzf](https://github.com/sainnhe/tmux-fzf)                  | `prefix+F`                        | 全能模糊搜索菜单(见下)                |
| [tmux-fzf-url](https://github.com/wfxr/tmux-fzf-url)             | `prefix+u`                        | 从窗格历史中模糊搜索并打开 URL        |
| [catppuccin-tmux](https://github.com/omerxx/catppuccin-tmux)     | 自动                              | 状态栏主题(见主题章节)                |
| [tmux-sessionx](https://github.com/omerxx/tmux-sessionx)         | `prefix+o`                        | fzf 会话 / 目录管理                   |
| [tmux-floax](https://github.com/omerxx/tmux-floax)               | `prefix+p` / `prefix+P`           | 浮动窗格                              |

### tmux-fzf(`prefix+F`)— 最值得掌握的一个菜单

按 `prefix+F` 后,输入关键字即可模糊搜索并操作:

| 类别       | 可做的操作                           |
| ---------- | ------------------------------------ |
| Session    | 切换 / 新建 / 重命名 / 脱离 / 关闭   |
| Window     | 切换 / 新建 / 重命名 / 关闭 / 交换   |
| Pane       | 切换 / 拆分 / 合并 / 布局 / 调整大小 |
| Command    | 搜索历史命令并带入命令行             |
| Keybinding | 搜索并直接执行某个 tmux 键绑定       |
| Clipboard  | 搜索剪贴板历史并粘贴                 |
| Process    | 进程管理(top / kill / interrupt 等)  |

> 依次输入关键词(`session`、`window`、`command` 等)进入对应分类,支持多选。

### tmux-floax(`prefix+p`)— 浮动窗格

`prefix+p`:在当前窗口上弹出一个浮动窗格(类似终端内的浮动工具),宽高 80%,`prefix+P` 打开菜单(可切换大小、颜色)。默认继承当前目录(`@floax-change-path true`),非常适合临时跑命令、看 `git log` 等。关闭:在浮动窗格里直接输入 `exit`。

---

## 主题与状态栏

使用 **catppuccin mocha**(深色)风味,状态栏在**顶部**(`status-position top`)。

| 配置项                             | 当前值                   | 说明                                    |
| ---------------------------------- | ------------------------ | --------------------------------------- |
| `@catppuccin_flavour`              | `mocha`(默认,未显式设置) | 可改为 `macchiato` / `frappe` / `latte` |
| `@catppuccin_status_modules_left`  | `session`                | 状态栏左侧显示会话名                    |
| `@catppuccin_status_modules_right` | `directory`              | 状态栏右侧显示当前路径                  |
| `@catppuccin_status_fill`          | `icon`                   | 模块带图标填充                          |

**状态栏透明 / 配色切换(`prefix+T`)**:

本配置默认启用**自定义状态栏样式**(背景透明 + 个性化配色),定义在 `tmux.status-custom.conf`。按 `prefix+T` 可在两种样式间**即时切换**:

| 样式            | 状态栏外观                                        |
| --------------- | ------------------------------------------------- |
| 自定义(默认)    | 背景透明(跟随终端背景),窗口 tab 为 `#404159` 配色 |
| catppuccin 原始 | mocha 深色背景 `#1e1e2e`,插件默认配色             |

> 透明的前提是终端本身开了背景透明(iTerm2 的 Transparency / kitty 的 `background_opacity`)。切换脚本位于 `scripts/toggle-status.sh`,切回原始样式时直接重新执行 catppuccin 插件生成默认值,因此插件更新不会影响此功能。

---

## 自动保存与恢复

本配置通过 `resurrect` + `continuum` 实现了"**关掉终端,下次打开一切还在**":

| 机制      | 说明                                                                    |
| --------- | ----------------------------------------------------------------------- |
| 自动保存  | 每 15 分钟(`continuum` 默认)保存当前会话布局、打开的 vim 文件等         |
| 自动恢复  | 每次启动 tmux 自动恢复上次保存的会话(`@continuum-restore on`)           |
| 手动保存  | `prefix+Ctrl+S`(resurrect save)                                         |
| 手动恢复  | `prefix+Ctrl+R`(resurrect restore)                                      |
| nvim 会话 | `@resurrect-strategy-nvim session` — 恢复时同时恢复 nvim 的 Session.vim |

> 保存数据存放在 `~/.tmux/resurrect/`。若不想自动恢复,删掉 `tmux.conf` 里的 `set -g @continuum-restore 'on'` 即可。

---

## 配置文件结构

```

~/.config/tmux/
├── tmux.conf # 主配置:选项、主题、插件声明(TPM)
├── tmux.reset.conf # 键位自定义:prefix、分屏、调整大小等绑定
├── tmux.status-custom.conf # 状态栏自定义样式(透明+改色),prefix+T 切换
├── plugins/ # TPM 管理的插件(不要手动改)
└── scripts/
    ├── toggle-status.sh # 状态栏样式切换(prefix+T)
    └── cal.sh # 会议提醒脚本(基于 icalBuddy,默认注释未启用)

```

- 想改快捷键 → 编辑 `tmux.reset.conf`,改完 `prefix+R`
- 想改主题 / 状态栏 / 插件选项 → 编辑 `tmux.conf`
- 想改状态栏配色 / 透明效果 → 编辑 `tmux.status-custom.conf`
- 插件本身会覆盖部分设置,若发现改了没生效,检查是否被插件在 `run '~/.config/tmux/plugins/tpm/tpm'` 之后重新覆盖

---

## 需要按个人情况调整的地方

```tmux
set -g @sessionx-custom-paths '/Users/hacxy/dotfiles'   # ← 改为你自己的常用目录(可空格分隔多个)
set -g @sessionx-x-path '~/dotfiles'                     # ← 改为自己的目录
```

---

## 常见问题

**Q: 按 `prefix+I` 没有反应 / 插件没装上?**
A: 确认 TPM 已克隆到 `~/.config/tmux/plugins/tpm`,且 `tmux.conf` 末行有 `run '~/.config/tmux/plugins/tpm/tpm'`。

**Q: 复制到剪贴板后粘贴到别的应用没内容?**
A: 确认在 iTerm2/Terminal 的偏好设置中开启了"应用时使用剪贴板"或类似选项;本配置依赖 macOS 的 `pbcopy`。

**Q: 改了 tmux.conf 但看起来没变化?**
A: 先 `prefix+R` 重载;若仍无变化,可能是插件覆盖(见"配置文件结构"末尾),或状态栏颜色等硬编码项(见"主题与状态栏")。

**Q: 状态栏背景色改了 `status-style` 没生效?**
A: 这是 catppuccin 插件用 `status-bg` 控制的,在 tmux 3.7+ 中 `status-bg` 与 `status-style` 是独立选项且 `status-bg` 优先。换 `@catppuccin_flavour` 是最省事的方式。

---

_配置基于 macOS + tmux 3.7,快捷键以 vi 模式为主。_
