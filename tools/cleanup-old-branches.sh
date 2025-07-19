#!/bin/bash

# Git远程分支自动清理脚本
# 删除创建时间超过一个月的远程分支
# 作者: 自动生成
# 日期: $(date +%Y-%m-%d)

set -e

# 配置参数
REMOTE_NAME="origin"  # 远程仓库名称
DAYS_THRESHOLD=30     # 天数阈值（超过此天数的分支将被删除）
DRY_RUN=true         # 是否为试运行模式（true=仅显示，false=实际删除）
PROTECTED_BRANCHES=("main" "master" "develop" "release" "staging" "production")  # 受保护的分支

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# 检查是否在Git仓库中
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "当前目录不是Git仓库！"
        exit 1
    fi
}

# 检查是否有远程仓库
check_remote() {
    if ! git remote get-url "$REMOTE_NAME" > /dev/null 2>&1; then
        log_error "远程仓库 '$REMOTE_NAME' 不存在！"
        exit 1
    fi
}

# 获取当前时间戳（秒）
get_current_timestamp() {
    date +%s
}

# 获取分支的创建时间戳
get_branch_creation_time() {
    local branch="$1"
    # 获取分支的第一个提交时间
    git log --reverse --format="%ct" "$REMOTE_NAME/$branch" | head -1
}

# 检查分支是否受保护
is_protected_branch() {
    local branch="$1"
    for protected in "${PROTECTED_BRANCHES[@]}"; do
        if [[ "$branch" == "$protected" ]]; then
            return 0
        fi
    done
    return 1
}

# 计算天数差
calculate_days_diff() {
    local creation_time="$1"
    local current_time="$2"
    echo $(( (current_time - creation_time) / 86400 ))
}

# 格式化时间显示
format_time() {
    local timestamp="$1"
    date -d "@$timestamp" "+%Y-%m-%d %H:%M:%S"
}

# 删除远程分支
delete_remote_branch() {
    local branch="$1"
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warn "[试运行] 将删除远程分支: $REMOTE_NAME/$branch"
    else
        log_info "正在删除远程分支: $REMOTE_NAME/$branch"
        if git push "$REMOTE_NAME" --delete "$branch"; then
            log_success "成功删除远程分支: $REMOTE_NAME/$branch"
        else
            log_error "删除远程分支失败: $REMOTE_NAME/$branch"
        fi
    fi
}

# 主函数
main() {
    log_info "开始执行Git远程分支清理脚本..."
    log_info "配置参数:"
    log_info "  - 远程仓库: $REMOTE_NAME"
    log_info "  - 天数阈值: $DAYS_THRESHOLD 天"
    log_info "  - 试运行模式: $DRY_RUN"
    log_info "  - 受保护分支: ${PROTECTED_BRANCHES[*]}"
    echo

    # 检查环境
    check_git_repo
    check_remote

    # 更新远程分支信息
    log_info "正在更新远程分支信息..."
    git fetch "$REMOTE_NAME" --prune

    # 获取当前时间
    current_time=$(get_current_timestamp)
    log_info "当前时间: $(format_time $current_time)"
    echo

    # 获取所有远程分支
    log_info "正在分析远程分支..."
    branches_to_delete=()
    total_branches=0
    protected_count=0
    old_branches_count=0

    while IFS= read -r line; do
        # 提取分支名（去掉origin/前缀）
        branch=$(echo "$line" | sed "s|^$REMOTE_NAME/||")
        
        # 跳过HEAD
        if [[ "$branch" == "HEAD" ]]; then
            continue
        fi

        total_branches=$((total_branches + 1))
        
        # 检查是否为受保护分支
        if is_protected_branch "$branch"; then
            protected_count=$((protected_count + 1))
            log_info "跳过受保护分支: $branch"
            continue
        fi

        # 获取分支创建时间
        creation_time=$(get_branch_creation_time "$branch")
        if [[ -z "$creation_time" ]]; then
            log_warn "无法获取分支 '$branch' 的创建时间，跳过"
            continue
        fi

        # 计算天数差
        days_diff=$(calculate_days_diff "$creation_time" "$current_time")
        
        log_info "分支: $branch"
        log_info "  创建时间: $(format_time $creation_time)"
        log_info "  存在天数: $days_diff 天"
        
        # 检查是否超过阈值
        if [[ $days_diff -gt $DAYS_THRESHOLD ]]; then
            old_branches_count=$((old_branches_count + 1))
            branches_to_delete+=("$branch")
            log_warn "  -> 标记为删除（超过 $DAYS_THRESHOLD 天）"
        else
            log_info "  -> 保留（未超过 $DAYS_THRESHOLD 天）"
        fi
        echo
    done < <(git branch -r | grep "^[[:space:]]*$REMOTE_NAME/" | sed 's/^[[:space:]]*//')

    # 显示统计信息
    echo "======================================"
    log_info "分支统计:"
    log_info "  总分支数: $total_branches"
    log_info "  受保护分支: $protected_count"
    log_info "  超期分支: $old_branches_count"
    echo "======================================"
    echo

    # 执行删除操作
    if [[ ${#branches_to_delete[@]} -eq 0 ]]; then
        log_success "没有需要删除的分支！"
    else
        log_warn "准备删除以下 ${#branches_to_delete[@]} 个分支:"
        for branch in "${branches_to_delete[@]}"; do
            echo "  - $REMOTE_NAME/$branch"
        done
        echo

        if [[ "$DRY_RUN" == "false" ]]; then
            read -p "确认删除以上分支？(y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                for branch in "${branches_to_delete[@]}"; do
                    delete_remote_branch "$branch"
                done
                log_success "分支清理完成！"
            else
                log_info "操作已取消"
            fi
        else
            log_info "试运行模式，实际未删除任何分支"
            log_info "要执行实际删除，请设置 DRY_RUN=false"
        fi
    fi
}

# 显示帮助信息
show_help() {
    echo "Git远程分支自动清理脚本"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -r, --remote NAME     指定远程仓库名称 (默认: origin)"
    echo "  -d, --days DAYS       指定天数阈值 (默认: 30)"
    echo "  -f, --force           实际执行删除 (默认为试运行模式)"
    echo "  -h, --help            显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0                    # 试运行，显示将要删除的分支"
    echo "  $0 -f                 # 实际删除超过30天的分支"
    echo "  $0 -d 60 -f           # 实际删除超过60天的分支"
    echo "  $0 -r upstream -d 14  # 检查upstream仓库中超过14天的分支"
}

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -r|--remote)
            REMOTE_NAME="$2"
            shift 2
            ;;
        -d|--days)
            DAYS_THRESHOLD="$2"
            shift 2
            ;;
        -f|--force)
            DRY_RUN=false
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            log_error "未知参数: $1"
            show_help
            exit 1
            ;;
    esac
done

# 执行主函数
main