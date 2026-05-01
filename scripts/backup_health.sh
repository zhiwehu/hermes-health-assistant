#!/bin/bash
# Health Data Backup Script
# 仅备份健康数据 (日记、对话草稿、体测数据)，适合每日/每周高频备份

# --- 配置 ---
PROFILE_NAME="health-assistant" # 修改为你的 Profile 名称
# 默认路径：~/.hermes/profiles/health-assistant/wiki/health
SRC_DIR="$HOME/.hermes/profiles/$PROFILE_NAME/wiki/health/"
BACKUP_DIR="$HOME/hermes-health-backups"
DATE=$(date +%Y-%m-%d)
DEST_DIR="$BACKUP_DIR/$DATE"

# --- 检查 ---
if [ ! -d "$SRC_DIR" ]; then
    echo "❌ 错误：健康数据目录不存在 $SRC_DIR"
    exit 1
fi

mkdir -p "$DEST_DIR"

echo "⏳ 正在增量备份健康数据..."
# 使用 rsync 进行增量同步，速度快，支持断点续传
rsync -av --delete "$SRC_DIR" "$DEST_DIR/"

# 更新 latest 软链接
ln -sfn "$DEST_DIR" "$BACKUP_DIR/latest"

echo "✅ 健康数据备份完成！"
echo "📂 路径: $DEST_DIR"
