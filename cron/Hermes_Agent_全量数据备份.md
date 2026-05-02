# Hermes Agent 全量数据备份

- **ID**: 0cc0101c17f4
- **Schedule**: `0 23 * * 0`
- **Deliver**: origin

## Prompt

```
请执行以下命令进行全量数据备份，并返回备份结果（备份文件路径和大小）：
bash ~/.hermes/profiles/personal-growth/scripts/backup_full_profile.sh

注意：该脚本会压缩 personal-growth profile 并排除 sessions/cache 等临时文件。
```
