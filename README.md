# Neovim 现代化配置

本项目是基于 Lua 的 Neovim 现代化 IDE 配置，集成了代码补全、LSP、调试、任务管理、文件树、状态栏、AI 辅助、代码片段、自动保存、自动格式化等功能，适用于日常开发和学习。

## 目录结构

```
.
├── init.lua                # 入口配置文件
├── coc-settings.json       # 兼容 coc.nvim 的部分设置
└── lua/
    ├── core/               # 基础设置、按键映射、通用函数、自动命令
    └── plugins/            # 插件相关配置
```

## 主要特性

- **插件管理**：使用 packer.nvim 管理插件，自动安装与同步。
- **主题美化**：tokyonight 主题，状态栏（lualine），BufferLine 标签栏。
- **文件导航**：NvimTree 文件树，快捷键 `<C-n>` 打开/关闭。
- **代码补全**：nvim-cmp + windsuf（Codeium AI 辅助），支持多种源和 AI 代码建议。
- **LSP 支持**：内置多语言 LSP（Python、TS/JS、Lua、C/C++、Go、HTML、CSS、YAML）。
- **调试功能**：nvim-dap，支持多语言调试，F5/F10/F11/F12 及 `<leader>d*` 快捷键。
- **任务/编译/运行**：overseer.nvim，支持多语言一键运行/编译，F7 运行当前文件，F9/F10/`<leader>o*` 任务面板。
- **代码片段**：LuaSnip + friendly-snippets，支持多语言代码片段与自定义片段。
- **注释/自动括号**：Comment.nvim、nvim-autopairs。
- **符号大纲**：symbols-outline.nvim，结构化浏览代码。
- **测试集成**：vim-test、neotest，支持 Python/Go 等测试。
- **剪贴板增强**：nvim-osc52，支持全选复制、系统剪贴板互通。
- **自动保存/格式化**：离开插入模式或保存时自动保存、自动去除行尾空格、自动格式化。
- **IDE 菜单**：`<F1>` 或 `<leader>i` 一键调出 IDE 常用功能菜单。

## 快捷键示例

- `<C-n>`：切换文件树
- `<leader>w`：保存文件
- `<leader>q`：退出
- `<S-l>/<S-h>`：切换 Buffer
- `<F5>`：调试
- `<F7>`：运行当前文件
- `<F9>/<F10>`：任务管理
- `<F1>` 或 `<leader>i`：IDE 菜单
- `gd/gD/gi/gr`：LSP 跳转
- `<leader>rn`：重命名
- `<leader>f`：格式化
- `<leader>ca`：代码操作
- `<leader>y`：复制到系统剪贴板
- `<leader>aa`：全选并复制

## 安装方法

### 1. 安装依赖

- **Neovim 0.8 及以上**：[官方下载](https://neovim.io/)
- **git**：[官方下载](https://git-scm.com/)
- **nodejs**：[官方下载](https://nodejs.org/)（部分 LSP/插件需要）
- **python3**：[官方下载](https://www.python.org/)（部分 LSP/插件需要）
- **go/rust/java**：按需安装对应语言支持

> 建议提前配置好 Python/Node/Go/Rust 的环境变量。

### 2. 克隆本仓库

```bash
# Linux/macOS
mkdir -p ~/.config
cd ~/.config
# 备份原有 nvim 配置（如有）
[ -d nvim ] && mv nvim nvim_backup_$(date +%Y%m%d)
git clone <your-repo-url> nvim

# Windows (PowerShell)
cd $env:LOCALAPPDATA
# 备份原有 nvim 配置（如有）
if (Test-Path .\nvim) { Rename-Item .\nvim ".\nvim_backup_$(Get-Date -Format yyyyMMdd)" }
git clone <your-repo-url> nvim
```

### 3. 启动 Neovim

首次启动 Neovim，会自动安装 packer.nvim 和所有插件。建议多等待几分钟，期间可通过 `:PackerSync` 手动同步插件。

### 4. 安装 LSP/调试/格式化等工具

进入 Neovim 后，执行：

```
:Mason
```

在 Mason 界面中安装你需要的 LSP、DAP、Formatter 等工具。

### 5. AI 辅助（Codeium/Windsurf）激活

- 需科学上网。
- 执行 `:Codeium Auth` 或 `<leader>wa` 进行授权。
- 授权后即可使用 AI 补全和聊天功能。

### 6. 常见问题排查

- 插件未生效/报错：请确保网络畅通，重启 Neovim，多次执行 `:PackerSync`。
- LSP/调试/测试等功能不可用：请用 Mason 安装对应工具，或手动安装。
- AI 辅助不可用：请检查 codeium/windsurf 配置，并确保网络可用。


## 使用说明

### 启动与基本操作

- 启动 Neovim：`nvim`（或 Windows 下 `nvim-qt`/`nvim.exe`）
- 打开/关闭文件树：`<C-n>`
- 保存文件：`<leader>w`（空格+w）
- 退出：`<leader>q` 或 `:q`/`:wq`
- 切换 Buffer：`<S-l>`/`<S-h>`

### 插件管理

- 同步/安装插件：`:PackerSync`
- 更新插件：`:PackerUpdate`
- 清理无用插件：`:PackerClean`

### LSP 相关

- 跳转到定义：`gd`
- 跳转到声明：`gD`
- 跳转到实现：`gi`
- 查找引用：`gr`
- 重命名：`<leader>rn`
- 代码操作：`<leader>ca`
- 格式化：`<leader>f`

### 调试功能

- 启动/继续调试：`<F5>`
- 单步跳过/进入/跳出：`<F10>/<F11>/<F12>`
- 切换断点：`<leader>db`
- 调试 UI：`<leader>du`

### 任务/编译/运行

- 运行当前文件：`<F7>` 或 `:RunFile`
- 打开任务面板：`<F9>` 或 `<leader>ot`
- 运行任务：`<leader>or`

### 测试

- 运行当前文件测试：IDE 菜单选择或 `:TestFile`
- 查看测试摘要：IDE 菜单选择

### AI 辅助

- AI 补全：插入模式下自动触发，`<C-y>` 接受建议
- AI 聊天：`<leader>wc` 打开聊天
- AI 开关：`<leader>wt`
- 授权：`<leader>wa`

### 其他

- 代码片段：输入片段前缀后 `<Tab>` 展开
- 注释：`gcc`（行注释）、`gc`（块注释）
- 全选并复制：`<leader>aa`
- IDE 菜单：`<F1>` 或 `<leader>i`

---

如需更详细的插件列表和配置说明，请查阅 `lua/plugins/` 目录下的各个文件。 