---
name: hermes-health-assistant
description: Hermes Agent 健康养生助手核心工作流：对话记录 → 晚间总结 → 每日日记 → 周报分析
---

# 🌿 Hermes Health Assistant 核心工作流

将 Hermes Agent 配置为专业的个人健康养生助手。基于 `personal-growth` 实战经验沉淀的最佳实践。

## 🏗️ 架构设计

采用 **Skill + Cron Job** 模式，不替换整个 Profile，灵活叠加在现有 Agent 上。

### 核心模块
1. **实时对话记录**：白天自动抓取健康相关消息，写入草稿
2. **定时任务**：06:00 早安提醒、22:00 晚间总结、周日 20:00 周报
3. **数据归档**：双层记录结构（草稿 → 最终日记）
4. **个性化定制**：基于用户体质（结石/脱发/减脂）的专属建议

## 📁 数据存储结构

```
~/.hermes/profiles/personal-growth/wiki/health/daily/
├── YYYY-MM-DD.md              # 最终健康日记（晚间定稿）
├── assets/                    # 图片资源（按日期或统一存放）
└── conversations/             # 对话草稿（白天实时记录）
    └── YYYY-MM-DD.md
```

> **路径说明**：实际使用时可放在任何目录，推荐 `wiki/health/daily/` 便于长期管理。

## 🔄 每日工作流

### 🌅 白天（实时记录 - 核心机制）
**⚠️ 实时记录铁律**：所有健康数据（文字、图片、睡眠截图等）**必须**在回复用户的同时，通过 `patch` 或 `write_file` 实时追加到 `conversations/YYYY-MM-DD.md`。
- **绝不等待**：不要依赖晚间 Cron Job 去回溯，**聊完即记**。
- **防遗漏**：只要用户发了图或数据，第一优先级是存入文件。

**标准记录模板**：
```markdown
### HH:MM [类别]
- 内容描述
- 评价/建议（简短）
- 图片：![描述](img_xxx.jpg)
```

### 🌆 晚间（22:00 自动总结归档）
Cron Job 自动触发，**全自动执行以下流程，无需用户手动确认：**
1. **读取数据**：读取 `conversations/YYYY-MM-DD.md` 全部内容。
2. **解析计算**：
   - 自动累加喝水量。
   - 自动估算每餐热量。
   - 自动判断 168 窗口执行情况。
   - 计算今日得分（0-100）。
3. **自动保存**：**直接调用 `write_file` 生成并写入 `YYYY-MM-DD.md`（最终日记）**。相当于默认用户已确认，减少用户交互。
4. **发送摘要**：仅发送简明摘要给用户，附带："✅ 已自动归档。如有误请指出，我将修正。"

## 📊 最终日记格式（含打分系统）

```markdown
# 📅 YYYY-MM-DD 健康日记

## 🌅 晨起数据
- **体测**：体重 X kg，体脂 Y%，BMI Z
- **睡眠**：时长、深睡/REM比例、清醒次数
- ![体测图](./assets/img_xxx.jpg)

## 🍽️ 饮食记录 (窗口 HH:MM-HH:MM)
| 时间 | 内容 | 热量估算 | 状态 |
|------|------|----------|------|
| 08:00 | 早餐内容 | ~400 kcal | ✅ 窗口内 |

## 💧 喝水记录
- 总量：X / 2500ml ✅/❌

## 🏃 运动记录
- 项目：时长/组数/消耗

## 📊 晚间复盘
**今日得分：XX / 100**
- 加分项：...
- 扣分项：...

## 💡 明日建议
1. ...
2. ...
```

## ⚠️ 实战避坑指南

### 1. 日期归属规则
- **睡眠截图**：图上显示哪天（晨起日期），就归档到哪天的日记。
  - *教训*：曾将5月1日早上发的"5月1日睡眠图"错误归入4月30日日记。
- **体测数据**：晨起空腹称重 → 归属当日。
- **进食/运动/喝水**：按实际发生时间归属。

### 2. 图片处理规范
- 来源：`~/.hermes/profiles/personal-growth/cache/images/`
- 规则：
  - 保留原始文件名（如 `img_abc123.jpg`），**不要修改**
  - 日记中用 `![描述](./assets/img_xxx.jpg)` 引用
  - 图片文件复制到日记同级 `assets/` 目录

### 3. `patch` 工具陷阱
- 问题：编辑日记时 `patch(old_string)` 常因字符串不唯一报错 `"Found 2 matches"`
- 解法：用 Python 脚本一次性处理
  ```python
  from pathlib import Path
  p = Path("diary.md")
  c = p.read_text().replace("旧内容", "新内容")
  p.write_text(c)
  ```

### 4. Cron Job 消息发送
- 背景：Cron 运行时可能无法直接调用 `send_message`
- 解法：Python 脚本直调 Telegram Bot API
  ```python
  import urllib.request, json
  url = f"https://api.telegram.org/bot{TOKEN}/sendMessage"
  data = json.dumps({"chat_id": CHAT_ID, "text": msg, "parse_mode": "Markdown"}).encode()
  req = urllib.request.Request(url, data=data, headers={'Content-Type': 'application/json'})
  urllib.request.urlopen(req)
  ```
- 注意：Shell 中的 Emoji 可能触发安全扫描拦截，Python 脚本不受影响。

## ⚙️ Cron Job 配置参考

| 任务 | 调度 | 内容 |
|------|------|------|
| 早安提醒 | `0 6 * * *` | 天气 + 昨日睡眠 + 今日建议 |
| 晚间总结 | `0 22 * * *` | 汇总当日记录 + 引导补充 |
| 每周周报 | `0 20 * * 0` | 周趋势分析 + 下周计划 |

## 🍽️ 热量自动估算指南

记录饮食时，自动估算热量并标注：
- **主食**：米饭(115kcal/100g)、面条(110kcal/100g)、包子(~250kcal/个)
- **蛋白质**：鸡蛋(~70kcal/个)、鸡胸(133kcal/100g)、牛奶(~65kcal/100ml)
- **蔬菜**：生菜(15kcal/100g)、番茄(18kcal/100g)
- **水果**：苹果(52kcal/100g)、香蕉(89kcal/100g)

**示例输出**：
> 早餐：包子1个(~250kcal) + 牛奶200ml(~130kcal) + 生菜1碗(~30kcal) → **总计 ~410 kcal** ✅

## 🎯 个性化定制

根据用户特殊体质调整建议：
- **结石体质**：避开高草酸食物（菠菜、酸菜、浓茶），多喝水排盐
- **脱发治疗**：记录用药（如蔓迪米诺地尔），提醒坚持
- **减脂期**：控制碳水比例，优先高蛋白+高纤维

## 📝 初始引导（Onboarding）

新用户首次使用时，收集以下信息：
1. 基础数据：年龄、身高、体重、体脂
2. 健康目标：减重/增肌/维持/168禁食
3. 特殊状况：病史、过敏、用药
4. 生活习惯：运动频率、睡眠时间
5. 提醒偏好：早安/晚安时间、喝水频率
