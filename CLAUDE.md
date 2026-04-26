# Project: HermesHealthTracker

## Overview
Hermes Agent 健康养生 Profile — 创建 `health-assistant` profile，安装后 Hermes 整体成为个人健康养生助手，通过对话记录健康信息，每日主动提醒与总结，智能抓取相关健康数据。

## Project Type
**Hermes Agent 健康养生角色配置** — 不是技能包，而是让 Agent 整体成为健康养生专家

### vs 技能包的区别
| | 技能包 | 角色配置（本项目）|
|---|---|---|
| 范围 | 可切换的功能模块 | Agent 永久角色 |
| 切换 | `hermes skills enable/disable` | 修改系统级配置 |
| 默认行为 | 需要指定使用 | 默认就是健康助手 |
| 其他能力 | 可能被覆盖 | 保留，同时专注健康 |

## Core Value Proposition
> "把 Hermes 配置成专业的个人健康养生助手"

## Goal Link
无特定目标关联 — 独立项目

## Status
- **Phase:** Planning
- **Progress:** 0%
- **Started:** 2026-04-26
- **Target:** TBD

## 用户实际使用场景

### 1. 早上 6:00 提醒
- 天气信息（自动获取）
- 今日饮食建议（正餐食谱 + 零食水果）
- 喝水提醒
- 运动建议
- 睡眠回顾
- 疾病/用药提醒

### 2. 全天信息记录
支持文字/语音/图片/视频多种方式：
- 饮食（正餐、零食、水果、饮品）
- 喝水
- 运动/锻炼
- 午睡
- 吃药/用药
自动记录到当天的健康日记

### 3. 健康咨询
- 随时咨询健康问题
- 根据已记录数据 + 网络查询回答
- 有用信息可一键记录到当天

### 4. 晚上 10:00 总结提醒
- 展示今日记录内容
- 生成今日总结日记
- 用户确认或补充
- （22:30 睡觉，提前半小时提醒，避免蓝光影响睡眠）

### 5. 每周日周报
- 一周数据趋势图表
- 饮食/运动/睡眠分析
- 与上周对比
- 下周建议

### 6. 初始引导
首次使用引导收集：
- 基本信息（年龄/性别/身高/体重）
- 健康目标（减重/增肌/168禁食等）
- 健康状况（病史/过敏/用药）
- 生活方式（运动/睡眠/工作）
- 提醒偏好

### 7. 168 间歇性禁食（可选）
- 进食窗口提醒（默认 12:00-20:00）
- 禁食窗口只允许喝水/茶/黑咖啡
- 执行情况记录
- 突破原因分析

### 数据存储结构
```
~/.hermes/health/
├── daily/              # 每日健康日记
│   ├── 2026-04-26.md
│   └── ...
├── body/              # 身体数据（身高、体重等）
├── exercise/          # 运动模板库
├── recipes/           # 食谱收藏
├── medications/       # 用药记录
└── reports/           # 周报存档
    └── weekly/
```

## Technical Stack
- **Core:** Hermes Agent（核心框架）
- **Profile:** `hermes profile create` 创建专属 profile
- **身份文件:** `SOUL.md`（健康养生专家角色定义）
- **记忆:** `MEMORY.md`（健康数据持久化）
- **用户画像:** `USER.md`（用户健康偏好）
- **工具:** Hermes 内置搜索 + Cron Job

## Open Source Model
**Hermes Agent 角色配置开源** — 纯自托管，用户掌控自己的健康数据

### 核心原则
- 用户下载配置后，替换 Hermes 的角色定义
- 用户数据存储在用户自己的 Hermes 实例中
- 不依赖任何中心化服务

### 分发方式
- [ ] GitHub 仓库 + 一键安装脚本
- [ ] 配置文件形式（替换 Hermes 角色配置）

## Key Decisions
- [x] **项目定位** — Hermes Profile 角色配置（2026-04-26）
- [x] **开源模式** — 纯自托管，用户完全掌控数据（2026-04-26）
- [x] **定时提醒** — Hermes 原生 Cron Job（2026-04-26）
- [x] **网络抓取** — Hermes 内置搜索（2026-04-26）
- [x] **数据存储** — Markdown 文件（用户可直接阅读）（2026-04-26）
- [待确认] 免责声明内容

## Next Actions
- [x] 研究 Hermes Profile 机制（SOUL.md + MEMORY.md）
- [x] 编写 SOUL.md（健康养生专家身份定义）
- [x] 设计 USER.md 模板（用户健康信息）
- [x] 设计健康数据 Markdown 目录结构
- [x] 设计每日日记模板
- [x] 设计周报模板
- [x] 创建一键安装脚本（install.sh）
- [ ] 完善 Cron Job prompt 模板
- [ ] 发布到 GitHub
- [ ] 实际测试 Hermes Profile

## 技术参考：Hermes Profile 结构

### Profile 目录结构
```
~/.hermes/profiles/health-assistant/
├── config.yaml        # 模型、TTS、记忆限制等配置
├── .env              # API密钥
├── SOUL.md           # Agent身份定义（核心）
├── memories/
│   ├── MEMORY.md     # Agent长期记忆
│   └── USER.md       # 用户画像
├── skills/           # 技能目录
├── sessions/         # 会话数据
└── cron/             # Cron Jobs
```

### 创建命令
```bash
hermes profile create health-assistant
hermes profile use health-assistant  # 设为默认
```

### SOUL.md 核心结构
```markdown
# SOUL.md - 健康养生专家

## Core Truths
- 你是专业的个人健康养生助手
- ...

## Boundaries
- 免责声明
- 不构成医疗建议
- ...

## Vibe
- 专业但亲切
- ...
```

### Cron Job
- 存储位置：`~/.hermes/cron/jobs.json`
- 调度格式：`30m` / `every 30m` / `0 9 * * *`
- CLI：`hermes cron create`

## Notes
[Running log of updates, blockers, learnings]
