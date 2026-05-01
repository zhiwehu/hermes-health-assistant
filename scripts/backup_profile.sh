#!/bin/bash
# Hermes Profile 全量备份脚本
# 备份所有数据：包含记忆 (Memory)、对话历史 (Sessions)、收到的图片/文件 (Cache)、Wiki、技能 (Skills)、配置。

# --- 配置 ---
PROFILE_NAME="health-assistant" # ⚠️ 修改为你的 Profile 名称
SOURCE_DIR="$HOME/.hermes/profiles/$PROFILE_NAME"
BACKUP_DIR="$HOME/hermes-backups"
DATE=$(date +%Y-%m-%d_%H-%M)
FILENAME="$PROFILE_NAME-$DATE.tar.gz"
DEST_FILE="$BACKUP_DIR/$FILENAME"

# --- 检查 ---
if [ ! -d "$SOURCE_DIR" ]; then
    echo "❌ 错误：Profile 目录不存在 $SOURCE_DIR"
    exit 1
fi

mkdir -p "$BACKUP_DIR"

echo "⏳ 正在全量备份 Profile: $PROFILE_NAME ..."
echo "📂 源目录: $SOURCE_DIR"

# --- 执行备份 ---
# 只排除构建依赖 (node_modules, venv, __pycache__)
# 保留 cache (图片/文件) 和 sessions (对话记忆)
tar -czf "$DEST_FILE" \
    --exclude="node_modules" \
    --exclude="venv" \
    --exclude="__pycache__" \
    -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

echo "✅ 全量备份完成！"
echo "📦 文件路径: $DEST_FILE"
echo "📦 文件大小: $(du -h "$DEST_FILE" | cut -f1)"
