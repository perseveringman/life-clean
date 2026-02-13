# AI 物品管理系统 - 技术设计文档

## 概述

本文档基于 PRD 文档，为 AI 物品管理系统提供完整的技术设计方案。

---

## 1. 技术架构

### 1.1 技术栈

- **前端**: SwiftUI (iOS 17+)
- **架构模式**: MVVM + Repository
- **本地存储**: SQLite.swift
- **云端同步**: CloudKit (可选)
- **AI 能力**:
  - 本地: Vision Framework (图片分类)、Speech Framework (语音转文字)
  - 云端: OpenAI/Claude API (语义理解、物品识别、AI 推荐)

### 1.2 模块划分

```
App/
├── App/                    # 入口、权限管理
├── Features/
│   ├── Onboarding/         # 新手引导流程
│   ├── Home/               # 首页、可视化仪表盘
│   ├── Items/              # 物品管理（录入、查找、编辑）
│   ├── Spaces/             # 空间管理（三层结构）
│   ├── Search/             # 智能查找入口
│   ├── AI/                 # AI 推荐、优化建议
│   └── Settings/           # 设置、家庭共享
├── Core/
│   ├── Models/             # 数据模型
│   ├── Services/           # AI 服务、存储服务
│   └── Utilities/          # 工具类
└── Design/
    └── Theme/              # 主题系统
```

---

## 2. 数据模型

### 2.1 空间三层结构

**Room (房间)**
| 字段 | 类型 | 说明 |
|------|------|------|
| id | UUID | 唯一标识 |
| name | String | 房间名称 (如"客厅") |
| icon | String | SF Symbol 图标 |
| createdAt | Date | 创建时间 |

**Container (容器/家具)**
| 字段 | 类型 | 说明 |
|------|------|------|
| id | UUID | 唯一标识 |
| name | String | 容器名称 (如"电视柜") |
| type | ContainerType | 枚举: 柜子/抽屉/盒子/架子等 |
| parentRoomId | UUID | 所属房间 |
| capacity | Int | 容量 (可选) |
| createdAt | Date | 创建时间 |

**SubSpace (子空间)**
| 字段 | 类型 | 说明 |
|------|------|------|
| id | UUID | 唯一标识 |
| name | String | 子空间名称 (如"左侧第二层") |
| position | String | 详细位置描述 |
| parentContainerId | UUID | 所属容器 |
| createdAt | Date | 创建时间 |

### 2.2 物品模型

**Item**
| 字段 | 类型 | 说明 |
|------|------|------|
| id | UUID | 唯一标识 |
| name | String | 物品名称 |
| category | ItemCategory | 物品类别 |
| attributes | [String: String] | 自定义属性 (颜色、品牌、保质期等) |
| images | [Data] | 物品照片 (压缩后) |
| currentLocation | LocationRef | 当前位置引用 |
| historyLocations | [LocationRecord] | 历史位置记录 |
| usageFrequency | Int | 使用频率 |
| createdAt | Date | 创建时间 |
| updatedAt | Date | 更新时间 |

### 2.3 行为日志

**BehaviorLog**
| 字段 | 类型 | 说明 |
|------|------|------|
| id | UUID | 唯一标识 |
| type | EventType | 事件类型: search/move/use/discard |
| itemId | UUID? | 关联物品 |
| fromLocation | LocationRef? | 原位置 |
| toLocation | LocationRef? | 新位置 |
| timestamp | Date | 时间戳 |
| aiProcessed | Bool | 是否已由 AI 处理 |

---

## 3. 核心功能流程

### 3.1 新手引导

1. **模式选择**: 个人模式 / 家庭模式
2. **快速设置** (约5分钟):
   - 语音/手工添加房间 (至少3个)
   - 添加主要容器
   - 录入5-10件"常找不到"的物品
   - AI 实时识别并分类
3. **引导完成**: 展示首页和查找演示

### 3.2 物品录入

**拍照模式**:
1. 拍摄物品照片
2. Vision Framework 初步分类
3. 云端 AI 提取属性
4. 用户确认/补充信息
5. AI 推荐存放位置
6. 用户采纳或自定义
7. 入库成功

**语音模式**:
1. 语音输入 ("新买的蓝色雨伞放在玄关")
2. Speech Framework 转文字
3. 云端 AI 解析: 物品 + 位置
4. 显示识别结果供确认
5. AI 推荐存放位置
6. 入库成功

### 3.3 智能查找

1. 用户输入文字/语音 ("我的充电器在哪")
2. 云端 AI 匹配物品
3. 返回空间链路: "客厅 → 电视柜 → 右侧抽屉"
4. 显示位置卡片
5. 用户找到后标记状态
6. 记录行为日志

---

## 4. AI 系统

### 4.1 AI 位置推荐

**评估因素**:
- 空间占用率 (容器已用容量/总容量)
- 物品关联性 (同类别物品放一起)
- 使用频率 (高频物品放易取位置)
- 用户历史偏好

**输出**: Top 3 推荐位置 (带理由)

### 4.2 AI 优化建议

**触发条件**:
- 周期性 (每周/每月)
- 行为阈值 (某物品查找>5次/月)

**分析维度**:
- 查找高频物品 → 建议移至更易取位置
- 空间利用率 → 建议整理/断舍离
- 物品过期风险 → 提醒保质期

---

## 5. UI 设计

### 5.1 导航结构

```
TabBar (4个 tabs):
├── Home  - 首页仪表盘
├── Items - 物品列表
├── Find  - 智能查找
└── Set   - 设置
```

### 5.2 主题色系

- **主色**: 暖橙色 (#FF9500) 或 柔和蓝绿 (#5AC8FA)
- **背景**: 米白色 (#FAFAFA) / 深色 (#1C1C1E)
- **强调**: 珊瑚色 (#FF6B6B)
- **字体**: SF Pro Rounded

---

## 6. 技术依赖

### 6.1 Swift Package Manager

```swift
// 数据库
SQLite.swift

// 网络
Alamofire

// 图片
Kingfisher

// AI
OpenAI SDK / Anthropic SDK
```

### 6.2 CloudKit

- Container: iCloud.com.yourteam.life-clean
- 启用可选同步

---

## 7. 性能要求

| 指标 | 目标 |
|------|------|
| 查找响应时间 | < 3秒 |
| AI 推荐生成 | < 5秒 |
| 错误率 | < 5% |
| 语音识别精度 | > 90% |

---

## 8. 开发计划

### Phase 1: 核心功能 (3-4周)
- 项目搭建、数据模型
- 空间管理 CRUD
- 物品管理 CRUD
- 基础查找功能

### Phase 2: AI 能力 (1-2周)
- 语音/图片集成
- AI 推荐逻辑
- 优化建议系统

### Phase 3: 体验打磨 (1周)
- 新手引导优化
- 性能调优
- 错误处理

---

*本文档基于 2026-02-13 的 brainstorming 产出*
