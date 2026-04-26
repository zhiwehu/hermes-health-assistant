#!/bin/bash

# Hermes Health Assistant - 一键安装脚本
# 把 Hermes 配置成个人健康养生助手

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🌿 Hermes Health Assistant 安装向导"
echo "===================================="
echo ""

# 检查 Hermes 是否已安装
check_hermes() {
    if command -v hermes &> /dev/null; then
        echo -e "${GREEN}✓${NC} Hermes 已安装"
        hermes --version
    else
        echo -e "${RED}✗${NC} Hermes 未安装"
        echo "请先安装 Hermes Agent: https://github.com/nousresearch/hermes-agent"
        exit 1
    fi
}

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 创建 Profile
create_profile() {
    echo ""
    echo "📁 步骤 1/4：创建 Profile"
    echo "-----------------------------------"

    PROFILE_NAME="health-assistant"

    # 检查是否已存在
    if [ -d "$HOME/.hermes/profiles/$PROFILE_NAME" ]; then
        echo -e "${YELLOW}!${NC} Profile '$PROFILE_NAME' 已存在"
        read -p "是否覆盖？(y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "安装取消"
            exit 0
        fi
    fi

    # 创建 profile
    echo "创建 Hermes profile..."
    hermes profile create "$PROFILE_NAME" || true

    PROFILE_DIR="$HOME/.hermes/profiles/$PROFILE_NAME"

    # 复制配置文件
    echo "复制配置文件..."
    cp "$SCRIPT_DIR/profile/SOUL.md" "$PROFILE_DIR/"
    cp "$SCRIPT_DIR/profile/config.yaml" "$PROFILE_DIR/"
    cp "$SCRIPT_DIR/profile/.env.example" "$PROFILE_DIR/.env"
    cp "$SCRIPT_DIR/profile/memories/"* "$PROFILE_DIR/memories/"

    echo -e "${GREEN}✓${NC} Profile 创建完成"
}

# 创建健康数据目录
create_health_dir() {
    echo ""
    echo "📂 步骤 2/4：创建健康数据目录"
    echo "-----------------------------------"

    HEALTH_DIR="$HOME/.hermes/health"

    mkdir -p "$HEALTH_DIR"/{daily,body,exercise,recipes,medications,reports/weekly}

    echo -e "${GREEN}✓${NC} 数据目录：$HEALTH_DIR"
}

# 配置 Cron Jobs
setup_cron_jobs() {
    echo ""
    echo "⏰ 步骤 3/4：设置定时提醒"
    echo "-----------------------------------"

    read -p "是否设置每日提醒？(Y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        # 早上 6:00 提醒
        echo "创建早安提醒 (每天 6:00)..."
        hermes cron create \
            --name "健康早安提醒" \
            --prompt "你是用户的个人健康养生助手。请生成今日健康提醒，包括：
1. 今日天气（使用搜索获取）
2. 今日饮食建议（考虑168间歇性禁食）
3. 喝水提醒
4. 运动建议
5. 回顾昨日睡眠情况

语气：亲切、专业、简洁。" \
            --schedule "0 6 * * *" \
            --repeat -1

        # 晚上 10:00 提醒
        echo "创建晚安提醒 (每天 22:00)..."
        hermes cron create \
            --name "健康晚安总结" \
            --prompt "你是用户的个人健康养生助手。请：
1. 展示用户今日记录的健康数据（饮食、运动、睡眠、用药等）
2. 询问用户是否有补充
3. 根据今日数据生成简洁的今日总结
4. 提醒用户 22:30 睡觉（蓝光影响睡眠）

语气：温柔、关怀、简洁。" \
            --schedule "0 22 * * *" \
            --repeat -1

        echo -e "${GREEN}✓${NC} 定时提醒已设置"
    fi

    read -p "是否设置每周日周报？(Y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        echo "创建周报提醒 (每周日 20:00)..."
        hermes cron create \
            --name "健康周报" \
            --prompt "你是用户的个人健康养生助手。请生成本周健康周报：
1. 本周数据总览（体重趋势、饮食规律、运动情况、睡眠质量）
2. 与上周对比
3. 本周亮点
4. 需要关注的问题
5. 下周建议

使用 markdown 格式，可包含 ASCII 图表。
语气：专业、鼓励、客观。" \
            --schedule "0 20 * * 0" \
            --repeat -1

        echo -e "${GREEN}✓${NC} 周报提醒已设置"
    fi
}

# 完成安装
finish() {
    echo ""
    echo "===================================="
    echo -e "${GREEN}🌿 安装完成！${NC}"
    echo "===================================="
    echo ""
    echo "下一步："
    echo "1. 运行: hermes profile use health-assistant"
    echo "2. 启动: hermes"
    echo "3. 首次对话会引导你完成个人健康档案设置"
    echo ""
    echo "常用命令："
    echo "  hermes profile use health-assistant  # 使用健康助手"
    echo "  hermes cron list                     # 查看定时任务"
    echo "  hermes profile show                  # 查看当前配置"
    echo ""
    echo "数据目录：~/.hermes/health/"
    echo ""
}

# 主流程
check_hermes
create_profile
create_health_dir
setup_cron_jobs
finish
