# Life Progress Tracker: Pomodoro ToDo

番茄钟 · 待办清单 · 日历统计  |  Pomodoro · To-Do · Calendar Tracker

---

## ✨ 特色 Features

- 番茄钟计时器与 ToDo 任务绑定 / Pomodoro timer linked to tasks
- 自定义番茄与休息时长、循环次数 / Customizable durations & cycles
- Todo 列表与分类管理 / Todo list & category management
- 日历可视化专注分布 / Calendar visualization of focus blocks
- 统计面板：圆饼图+折线图 / Statistics dashboard (pie & line charts)
- 跨平台：Web、桌面 (Windows/macOS)、移动 (Android/iOS) / Cross-platform support
- 离线优先，自动同步 / Offline-first with automatic sync
- 多语言：简体中文、English（后续支持多语） / Multi-language (ZH/EN)

## 🏆 最小可行版本 MVP

1. 用户注册 / 登录（Supabase Auth）
2. Todo 创建 / 编辑 / 完成 / 删除，支持自定义分类
3. Pomodoro 计时器（25/5 默认，可自定义），结束本地通知 / Web Push
4. 今日统计视图：圆饼图（各任务占比）、折线图（番茄数量随时间）
5. 日历视图：以方块展示番茄专注区块
6. 中英文界面切换

> **MVP 不含：** 深度专注模式、等级系统、宠物/皮肤、AI Agent 等。

## 🔧 技术栈 Tech Stack

| Layer | Web | Desktop | Mobile | Shared / Backend |
|-------|-----|---------|--------|------------------|
| UI    | React + TypeScript + Ant Design | Tauri (Rust) + Web UI | React Native (Expo) | Ant Design Mobile |
| Data  | Supabase (PostgreSQL)           | Supabase            | Supabase            | Supabase Edge Functions |
| Sync  | GraphQL (Apollo Client)         | GraphQL             | GraphQL             | Hasura or Apollo Server |
| Local | IndexedDB (Dexie.js)            | SQLite (via Tauri)  | SQLite (Expo SQLite)| ─ |
| Notify| Web Push API                    | OS Notification API | FCM / APNs          | ─ |

## 🏗️ 架构概览 Architecture

```mermaid
flowchart TD
    subgraph Client
        A[Web (React)] -- reuse --> B[Desktop (Tauri)]
        C[Mobile (React Native)]
    end
    subgraph Sync Layer
        D[GraphQL API]
    end
    subgraph Backend
        E[Supabase Auth]
        F[PostgreSQL DB]
        G[Edge Functions / CRON]
    end
    A --- D
    B --- D
    C --- D
    D --- F
    D --- E
    G --> D
```

## 🚀 快速开始 Getting Started

> 假设使用 **pnpm** & **Supabase CLI** ，并采用 Monorepo 结构（`web/`, `desktop/`, `mobile/`, `packages/`）。

```bash
# 克隆仓库
$ git clone https://github.com/yourname/PomoToDoLifeTracker.git
$ cd PomoToDoLifeTracker

# 安装根依赖
$ pnpm install

# 启动本地 Supabase (需 Docker)
$ supabase start

# 运行 Web 端
$ cd web && pnpm dev
```

更多平台指令详见 `docs/requirements.md`。

## 📦 打包 / 发布 Build & Release

- **Web**: `pnpm build` → 产出静态文件，可部署 Vercel/Netlify。
- **Desktop**: `pnpm tauri build` → Windows `.msi` / macOS `.dmg`。
- **Mobile**: `expo build` / EAS Build。

## 🛡️ 隐私与备份 Privacy & Backup

1. **数据加密**：Supabase PostgreSQL 默认磁盘加密；敏感字段可应用 pgcrypto 或 Row Level Security。
2. **端到端同步**：本地离线数据仅缓存于 IndexedDB/SQLite，可在设置中一键清空。
3. **数据导出**：用户可导出 JSON/CSV；后台计划任务每日快照至 S3 存储。
4. **隐私政策**：遵循 GDPR / CCPA；未来若采集匿名使用统计，将提前征得同意。

## 💰 Monetization Roadmap

- 核心功能 MIT 开源；
- **付费增值**（未来）：
  - AI Agent 建议 & 总结
  - 自定义主题 / 宠物 / 声音包
  - 高级分析报表（可导出 PDF）

> Dual-license 也可作为后续选项：个人 MIT，商业需购买 License。

## 🗺️ Roadmap

- [ ] MVP 完成 & 内测
- [ ] 专注模式（移动端白名单 / 屏蔽通知）
- [ ] 等级系统 & 徽章
- [ ] 多语言：繁中 / 日语 / 德语 / 西语
- [ ] 插件生态 / 自托管支持

## 🤝 Contributing

欢迎 Issue / PR！在提交之前请阅读 `CONTRIBUTING.md`。

## 📄 License

MIT License (TBD)
