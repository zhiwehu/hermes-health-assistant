# 🌿 Hermes Health Assistant

把你的 Hermes Agent 配置成专业的**个人健康养生助手**。

通过自然对话记录饮食、运动、睡眠、体重等健康数据，每日自动提醒与总结，帮你养成健康生活习惯。

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## ✨ 功能

### 🤖 对话式记录
支持文字、语音、图片、视频多种方式记录：
- 饮食（正餐、零食、水果、饮品）
- 运动（跑步、健身、游泳等）
- 喝水
- 午睡
- 用药

### ⏰ 每日自动提醒

| 时间 | 内容 |
|------|------|
| **早上 6:00** | 天气 + 今日饮食建议 + 运动建议 + 睡眠回顾 |
| **晚上 10:00** | 今日总结提醒 → 生成健康日记 |

### 📊 每周日周报
- 数据趋势图表
- 饮食/运动/睡眠分析
- 与上周对比
- 下周建议

### 🍽️ 168 间歇性禁食支持（可选）
- 进食窗口提醒（默认 12:00-20:00）
- 禁食窗口只允许喝水/茶/黑咖啡
- 执行情况追踪

### 🔍 智能健康咨询
随时咨询健康问题，助手会根据你的数据 + 网络搜索给出建议，有用的信息可一键记录。

## 🚀 快速开始

### 前置要求

- [Hermes Agent](https://github.com/nousresearch/hermes-agent) 已安装
- API 密钥已配置

### 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/zhiwehu/hermes-health-assistant/main/install.sh | bash
```

### 手动安装

```bash
# 1. 创建 profile
hermes profile create health-assistant

# 2. 进入 profile 目录
cd ~/.hermes/profiles/health-assistant

# 3. 克隆本仓库
git clone https://github.com/zhiwehu/hermes-health-assistant.git temp
cp temp/profile/* ./
rm -rf temp

# 4. 设置为默认
hermes profile use health-assistant
```

### 首次使用

```bash
hermes
```

首次对话会引导你完成个人健康档案设置。

## 📁 数据存储

所有数据以 Markdown 格式存储在本地：

```
~/.hermes/health/
├── daily/              # 每日健康日记
├── body/              # 身体数据
├── exercise/          # 运动记录
├── recipes/           # 食谱收藏
├── medications/       # 用药记录
└── reports/           # 周报存档
```

**你的数据完全存储在本地，不上传任何第三方。**

## ⚙️ 自定义

### 修改提醒时间

告诉你的助手：
```
"把早安提醒改到 7:00"
"把晚安提醒改到 21:30"
```

### 修改 168 进食窗口

```
"我的进食窗口改成 11:00-19:00"
```

### 查看/管理定时任务

```bash
hermes cron list      # 查看所有定时任务
hermes cron remove <id>  # 删除某个任务
```

## 📖 使用示例

```
你: 今天中午吃了牛肉面和两个鸡蛋
助手: 已记录 🍜
    - 牛肉面 1份
    - 鸡蛋 2个
    要我帮你估算营养成分吗？

你: 昨晚跑步 30 分钟
助手: 已记录 🏃
    - 跑步 30 分钟
    - 消耗约 300 kcal
    周末跑步目标达成！

你: 最近睡眠不太好
助手: 了解... 根据你的记录，最近3天睡眠质量有所下降(6→5→4分)
    可能原因：
    - 昨晚咖啡因摄入较多
    - 运动量较前几天减少
    建议：睡前1小时减少屏幕使用...
```

## ⚠️ 免责声明

本助手提供的健康建议仅供参考，不构成医疗诊断或治疗。如有健康问题，请咨询专业医生。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

本项目采用 [MIT 许可证](LICENSE)。

---

*Built with ❤️ using Hermes Agent*
