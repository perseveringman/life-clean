# LifeClean - AI 物品管理系统

一个 AI 驱动的家庭和个人物品收纳管理应用。

## 运行项目

1. **用 Xcode 打开**:
   ```bash
   open LifeClean.xcodeproj
   ```
   或者
   ```bash
   xed .
   ```

2. **创建 Xcode 项目** (如果 .xcodeproj 不存在):
   - 打开 Xcode
   - File → New → Project
   - 选择 iOS → App
   - Product Name: `LifeClean`
   - Interface: `SwiftUI`
   - 保存到项目目录
   - 将 `Sources` 文件夹中的文件添加到项目中

## 项目结构

```
Sources/
├── App/
│   ├── LifeCleanApp.swift      # App 入口
│   └── ContentView.swift       # 主 TabView
├── Features/
│   ├── Onboarding/             # 新手引导
│   ├── Home/                   # 首页
│   ├── Items/                  # 物品管理
│   ├── Search/                 # 智能查找
│   └── Settings/               # 设置
├── Core/
│   └── Models/                 # 数据模型
└── Design/
    └── Theme/                  # 主题系统
```

## 技术栈

- SwiftUI (iOS 17+)
- 本地存储: SQLite.swift (待添加)
- 云端同步: CloudKit (待实现)
- AI: Vision Framework + Speech Framework + OpenAI/Claude API

## 功能进度

- [x] 项目基础架构
- [x] 新手引导流程
- [x] 首页仪表盘
- [x] 物品列表
- [x] 智能查找入口
- [ ] 设置页面
- [ ] 数据持久化
- [ ] CloudKit 同步
- [ ] 语音/图片 AI 集成

## 版本

- 1.0.0 (开发中)
