# Git远程分支自动清理脚本使用指南

## 📋 概述

本工具包含两个脚本，用于自动清理Git仓库中创建时间超过指定天数的远程分支：

- `cleanup-old-branches.sh` - Linux/macOS Bash脚本
- `cleanup-old-branches.ps1` - Windows PowerShell脚本

## 🎯 功能特性

### ✨ 核心功能
- 🕒 **时间检测**：基于分支的第一个提交时间判断分支年龄
- 🛡️ **安全保护**：内置受保护分支列表，防止误删重要分支
- 🔍 **试运行模式**：默认为试运行，仅显示将要删除的分支
- 📊 **详细统计**：显示分支统计信息和删除计划
- 🎨 **彩色输出**：清晰的日志级别和颜色区分
- ⚙️ **灵活配置**：支持自定义远程仓库、天数阈值等参数

### 🛡️ 安全特性
- **受保护分支**：默认保护 `main`、`master`、`develop`、`release`、`staging`、`production`
- **确认机制**：实际删除前需要用户确认
- **错误处理**：完善的异常处理和错误提示
- **环境检查**：自动检查Git仓库和远程仓库有效性

## 🚀 快速开始

### Linux/macOS 使用方法

```bash
# 1. 给脚本添加执行权限
chmod +x cleanup-old-branches.sh

# 2. 试运行（仅显示将要删除的分支）
./cleanup-old-branches.sh

# 3. 实际执行删除
./cleanup-old-branches.sh -f
```

### Windows PowerShell 使用方法

```powershell
# 1. 设置执行策略（如果需要）
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 2. 试运行（仅显示将要删除的分支）
.\cleanup-old-branches.ps1

# 3. 实际执行删除
.\cleanup-old-branches.ps1 -Force
```

## 📖 详细使用说明

### Bash脚本参数

```bash
./cleanup-old-branches.sh [选项]

选项:
  -r, --remote NAME     指定远程仓库名称 (默认: origin)
  -d, --days DAYS       指定天数阈值 (默认: 30)
  -f, --force           实际执行删除 (默认为试运行模式)
  -h, --help            显示帮助信息
```

### PowerShell脚本参数

```powershell
.\cleanup-old-branches.ps1 [参数]

参数:
  -Remote <名称>        指定远程仓库名称 (默认: origin)
  -Days <天数>          指定天数阈值 (默认: 30)
  -Force                实际执行删除 (默认为试运行模式)
  -Help                 显示帮助信息
```

## 💡 使用示例

### 基础使用

```bash
# Bash - 查看超过30天的分支（试运行）
./cleanup-old-branches.sh

# PowerShell - 查看超过30天的分支（试运行）
.\cleanup-old-branches.ps1
```

### 自定义天数阈值

```bash
# Bash - 删除超过60天的分支
./cleanup-old-branches.sh -d 60 -f

# PowerShell - 删除超过60天的分支
.\cleanup-old-branches.ps1 -Days 60 -Force
```

### 指定不同的远程仓库

```bash
# Bash - 清理upstream仓库的分支
./cleanup-old-branches.sh -r upstream -d 14 -f

# PowerShell - 清理upstream仓库的分支
.\cleanup-old-branches.ps1 -Remote upstream -Days 14 -Force
```

### 批量清理不同时间段的分支

```bash
# 清理超过7天的feature分支（需要修改脚本中的受保护分支列表）
./cleanup-old-branches.sh -d 7 -f

# 清理超过90天的所有分支
./cleanup-old-branches.sh -d 90 -f
```

## ⚙️ 配置说明

### 受保护分支配置

默认受保护的分支包括：
- `main`
- `master`
- `develop`
- `release`
- `staging`
- `production`

如需修改，请编辑脚本中的 `PROTECTED_BRANCHES` 数组：

```bash
# Bash脚本中
PROTECTED_BRANCHES=("main" "master" "develop" "release" "staging" "production" "hotfix")
```

```powershell
# PowerShell脚本中
$ProtectedBranches = @("main", "master", "develop", "release", "staging", "production", "hotfix")
```

### 时间阈值配置

可以通过参数或修改脚本中的默认值来调整：

```bash
# Bash脚本中
DAYS_THRESHOLD=30     # 修改默认天数
```

```powershell
# PowerShell脚本中
[int]$Days = 30       # 修改默认天数
```

## 🔍 输出说明

### 日志级别

- **[INFO]** - 一般信息（蓝色）
- **[WARN]** - 警告信息（黄色）
- **[ERROR]** - 错误信息（红色）
- **[SUCCESS]** - 成功信息（绿色）

### 输出示例

```
[INFO] 开始执行Git远程分支清理脚本...
[INFO] 配置参数:
[INFO]   - 远程仓库: origin
[INFO]   - 天数阈值: 30 天
[INFO]   - 试运行模式: true
[INFO]   - 受保护分支: main master develop release staging production

[INFO] 正在更新远程分支信息...
[INFO] 当前时间: 2024-07-18 17:30:00

[INFO] 正在分析远程分支...
[INFO] 跳过受保护分支: main
[INFO] 分支: feature/user-auth
[INFO]   创建时间: 2024-05-15 10:20:30
[INFO]   存在天数: 64 天
[WARN]   -> 标记为删除（超过 30 天）

======================================
[INFO] 分支统计:
[INFO]   总分支数: 15
[INFO]   受保护分支: 3
[INFO]   超期分支: 5
======================================

[WARN] 准备删除以下 5 个分支:
  - origin/feature/user-auth
  - origin/feature/old-api
  - origin/bugfix/legacy-fix
  - origin/feature/deprecated
  - origin/hotfix/temp-patch

[INFO] 试运行模式，实际未删除任何分支
[INFO] 要执行实际删除，请设置 DRY_RUN=false
```

## ⚠️ 注意事项

### 使用前准备

1. **备份重要数据**：在执行删除操作前，确保重要分支已经合并或备份
2. **权限检查**：确保有删除远程分支的权限
3. **网络连接**：确保能够正常访问远程Git仓库
4. **Git版本**：建议使用Git 2.0以上版本

### 安全建议

1. **先试运行**：始终先执行试运行模式查看将要删除的分支
2. **小批量测试**：首次使用时建议设置较大的天数阈值进行测试
3. **团队沟通**：在团队项目中使用前，请与团队成员沟通
4. **定期执行**：建议定期执行以保持仓库整洁

### 常见问题

#### Q: 脚本无法执行怎么办？
A: 
- Linux/macOS: 检查是否有执行权限 `chmod +x cleanup-old-branches.sh`
- Windows: 检查PowerShell执行策略 `Set-ExecutionPolicy RemoteSigned`

#### Q: 如何恢复误删的分支？
A: 
- 如果分支最近被删除，可以通过 `git reflog` 查找提交记录
- 使用 `git checkout -b <branch-name> <commit-hash>` 恢复分支
- 如果有备份，从备份中恢复

#### Q: 脚本显示"无法获取分支创建时间"？
A: 
- 检查分支是否存在提交记录
- 确保有访问远程仓库的权限
- 尝试手动执行 `git log --reverse --format="%ct" origin/<branch-name>`

#### Q: 如何自定义受保护分支？
A: 编辑脚本中的 `PROTECTED_BRANCHES` 数组，添加需要保护的分支名称

## 🔧 高级用法

### 集成到CI/CD

可以将脚本集成到CI/CD流水线中，定期自动清理分支：

```yaml
# GitHub Actions 示例
name: Clean Old Branches
on:
  schedule:
    - cron: '0 2 * * 0'  # 每周日凌晨2点执行

jobs:
  cleanup:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Clean old branches
      run: |
        chmod +x tools/cleanup-old-branches.sh
        ./tools/cleanup-old-branches.sh -d 30 -f
```

### 自定义日志输出

可以修改脚本中的日志函数来自定义输出格式：

```bash
# 添加时间戳到日志
log_info() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') ${BLUE}[INFO]${NC} $1"
}
```

### 批量处理多个仓库

创建一个包装脚本来处理多个仓库：

```bash
#!/bin/bash
REPOS=("repo1" "repo2" "repo3")
for repo in "${REPOS[@]}"; do
    echo "Processing $repo..."
    cd "$repo"
    ../tools/cleanup-old-branches.sh -f
    cd ..
done
```

## 📝 更新日志

### v1.0.0 (2024-07-18)
- ✨ 初始版本发布
- 🛡️ 支持受保护分支配置
- 🔍 试运行模式
- 📊 详细的统计信息
- 🎨 彩色日志输出
- ⚙️ 灵活的参数配置

## 📄 许可证

本脚本采用 MIT 许可证，可自由使用和修改。

## 🤝 贡献

欢迎提交Issue和Pull Request来改进这个工具！

---

**⚠️ 重要提醒：删除操作不可逆，请务必在执行前仔细检查将要删除的分支列表！**