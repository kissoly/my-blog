# Git远程分支自动清理脚本 (PowerShell版本)
# 删除创建时间超过一个月的远程分支
# 作者: 自动生成
# 日期: $(Get-Date -Format 'yyyy-MM-dd')

param(
    [string]$Remote = "origin",
    [int]$Days = 30,
    [switch]$Force,
    [switch]$Help
)

# 配置参数
$RemoteName = $Remote
$DaysThreshold = $Days
$DryRun = -not $Force
$ProtectedBranches = @("main", "master", "develop", "release", "staging", "production")

# 显示帮助信息
function Show-Help {
    Write-Host "Git远程分支自动清理脚本 (PowerShell版本)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "用法: .\cleanup-old-branches.ps1 [参数]" -ForegroundColor White
    Write-Host ""
    Write-Host "参数:" -ForegroundColor Yellow
    Write-Host "  -Remote <名称>     指定远程仓库名称 (默认: origin)" -ForegroundColor White
    Write-Host "  -Days <天数>       指定天数阈值 (默认: 30)" -ForegroundColor White
    Write-Host "  -Force             实际执行删除 (默认为试运行模式)" -ForegroundColor White
    Write-Host "  -Help              显示此帮助信息" -ForegroundColor White
    Write-Host ""
    Write-Host "示例:" -ForegroundColor Yellow
    Write-Host "  .\cleanup-old-branches.ps1                    # 试运行，显示将要删除的分支" -ForegroundColor Gray
    Write-Host "  .\cleanup-old-branches.ps1 -Force             # 实际删除超过30天的分支" -ForegroundColor Gray
    Write-Host "  .\cleanup-old-branches.ps1 -Days 60 -Force    # 实际删除超过60天的分支" -ForegroundColor Gray
    Write-Host "  .\cleanup-old-branches.ps1 -Remote upstream -Days 14  # 检查upstream仓库中超过14天的分支" -ForegroundColor Gray
}

# 日志函数
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Warn {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

# 检查是否在Git仓库中
function Test-GitRepo {
    try {
        git rev-parse --git-dir | Out-Null
        return $true
    }
    catch {
        Write-Error-Custom "当前目录不是Git仓库！"
        return $false
    }
}

# 检查是否有远程仓库
function Test-Remote {
    param([string]$RemoteName)
    try {
        git remote get-url $RemoteName | Out-Null
        return $true
    }
    catch {
        Write-Error-Custom "远程仓库 '$RemoteName' 不存在！"
        return $false
    }
}

# 获取分支的创建时间戳
function Get-BranchCreationTime {
    param([string]$Branch, [string]$RemoteName)
    try {
        $timestamp = git log --reverse --format="%ct" "$RemoteName/$Branch" | Select-Object -First 1
        return [int64]$timestamp
    }
    catch {
        return $null
    }
}

# 检查分支是否受保护
function Test-ProtectedBranch {
    param([string]$Branch, [array]$ProtectedBranches)
    return $ProtectedBranches -contains $Branch
}

# 计算天数差
function Get-DaysDiff {
    param([int64]$CreationTime, [int64]$CurrentTime)
    return [math]::Floor(($CurrentTime - $CreationTime) / 86400)
}

# 格式化时间显示
function Format-UnixTime {
    param([int64]$Timestamp)
    $dateTime = [DateTimeOffset]::FromUnixTimeSeconds($Timestamp).DateTime
    return $dateTime.ToString("yyyy-MM-dd HH:mm:ss")
}

# 删除远程分支
function Remove-RemoteBranch {
    param([string]$Branch, [string]$RemoteName, [bool]$DryRun)
    
    if ($DryRun) {
        Write-Warn "[试运行] 将删除远程分支: $RemoteName/$Branch"
    }
    else {
        Write-Info "正在删除远程分支: $RemoteName/$Branch"
        try {
            git push $RemoteName --delete $Branch
            Write-Success "成功删除远程分支: $RemoteName/$Branch"
        }
        catch {
            Write-Error-Custom "删除远程分支失败: $RemoteName/$Branch - $($_.Exception.Message)"
        }
    }
}

# 主函数
function Main {
    # 显示帮助信息
    if ($Help) {
        Show-Help
        return
    }

    Write-Info "开始执行Git远程分支清理脚本..."
    Write-Info "配置参数:"
    Write-Info "  - 远程仓库: $RemoteName"
    Write-Info "  - 天数阈值: $DaysThreshold 天"
    Write-Info "  - 试运行模式: $DryRun"
    Write-Info "  - 受保护分支: $($ProtectedBranches -join ', ')"
    Write-Host ""

    # 检查环境
    if (-not (Test-GitRepo)) {
        return
    }

    if (-not (Test-Remote -RemoteName $RemoteName)) {
        return
    }

    # 更新远程分支信息
    Write-Info "正在更新远程分支信息..."
    try {
        git fetch $RemoteName --prune
    }
    catch {
        Write-Error-Custom "更新远程分支信息失败: $($_.Exception.Message)"
        return
    }

    # 获取当前时间戳
    $currentTime = [DateTimeOffset]::Now.ToUnixTimeSeconds()
    Write-Info "当前时间: $(Format-UnixTime $currentTime)"
    Write-Host ""

    # 获取所有远程分支
    Write-Info "正在分析远程分支..."
    $branchesToDelete = @()
    $totalBranches = 0
    $protectedCount = 0
    $oldBranchesCount = 0

    try {
        $remoteBranches = git branch -r | Where-Object { $_ -match "^\s*$RemoteName/" } | ForEach-Object { $_.Trim() }
        
        foreach ($line in $remoteBranches) {
            # 提取分支名（去掉origin/前缀）
            $branch = $line -replace "^$RemoteName/", ""
            
            # 跳过HEAD
            if ($branch -eq "HEAD") {
                continue
            }

            $totalBranches++
            
            # 检查是否为受保护分支
            if (Test-ProtectedBranch -Branch $branch -ProtectedBranches $ProtectedBranches) {
                $protectedCount++
                Write-Info "跳过受保护分支: $branch"
                continue
            }

            # 获取分支创建时间
            $creationTime = Get-BranchCreationTime -Branch $branch -RemoteName $RemoteName
            if ($null -eq $creationTime) {
                Write-Warn "无法获取分支 '$branch' 的创建时间，跳过"
                continue
            }

            # 计算天数差
            $daysDiff = Get-DaysDiff -CreationTime $creationTime -CurrentTime $currentTime
            
            Write-Info "分支: $branch"
            Write-Info "  创建时间: $(Format-UnixTime $creationTime)"
            Write-Info "  存在天数: $daysDiff 天"
            
            # 检查是否超过阈值
            if ($daysDiff -gt $DaysThreshold) {
                $oldBranchesCount++
                $branchesToDelete += $branch
                Write-Warn "  -> 标记为删除（超过 $DaysThreshold 天）"
            }
            else {
                Write-Info "  -> 保留（未超过 $DaysThreshold 天）"
            }
            Write-Host ""
        }
    }
    catch {
        Write-Error-Custom "获取远程分支信息失败: $($_.Exception.Message)"
        return
    }

    # 显示统计信息
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Info "分支统计:"
    Write-Info "  总分支数: $totalBranches"
    Write-Info "  受保护分支: $protectedCount"
    Write-Info "  超期分支: $oldBranchesCount"
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host ""

    # 执行删除操作
    if ($branchesToDelete.Count -eq 0) {
        Write-Success "没有需要删除的分支！"
    }
    else {
        Write-Warn "准备删除以下 $($branchesToDelete.Count) 个分支:"
        foreach ($branch in $branchesToDelete) {
            Write-Host "  - $RemoteName/$branch" -ForegroundColor Gray
        }
        Write-Host ""

        if (-not $DryRun) {
            $confirmation = Read-Host "确认删除以上分支？(y/N)"
            if ($confirmation -eq 'y' -or $confirmation -eq 'Y') {
                foreach ($branch in $branchesToDelete) {
                    Remove-RemoteBranch -Branch $branch -RemoteName $RemoteName -DryRun $false
                }
                Write-Success "分支清理完成！"
            }
            else {
                Write-Info "操作已取消"
            }
        }
        else {
            Write-Info "试运行模式，实际未删除任何分支"
            Write-Info "要执行实际删除，请添加 -Force 参数"
        }
    }
}

# 执行主函数
Main