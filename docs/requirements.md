# PomoToDoLifeTracker – 需求规格说明书 / Requirements Specification

> version: 0.1.0 · last update: YYYY-MM-DD

## 1. 引言 Introduction

### 1.1 目标 Purpose
提供一个跨平台的专注番茄钟 + 待办管理 + 日历统计工具，帮助用户量化并改善时间管理。

### 1.2 范围 Scope
面向个人开发者、学生及自由职业者，支持 Web、桌面 (macOS/Windows)、移动 (Android/iOS)。

### 1.3 定义 Definitions
- **PomodoroSession**: 单个番茄或休息周期的记录。
- **Task (Todo)**: 用户创建的可完成项。
- **Category**: 自定义分组，用于统计聚合。

## 2. 总体描述 Overall Description

### 2.1 用户角色 Users
| 角色 | 描述 |
|------|------|
| 未登录游客 | 仅可体验计时，不保存数据 |
| 注册用户   | 完整功能；数据云同步 |
| 管理员     | 系统维护、数据审计 |

### 2.2 产品功能 Product Functions
1. **Auth**: 邮箱/密码 & OAuth；重置密码。
2. **Task CRUD**: 创建、编辑、完成、删除；支持分类、优先级、备注。
3. **Pomodoro**: 启动 / 暂停 / 结束；自定义工作 & 休息时长；循环次数。
4. **Notification**: 结束提醒（声/震/推送）。
5. **Statistics**: 
   - Pie: 当日各 Task 占比
   - Line: 每小时番茄数
6. **Calendar**: 渲染 PomodoroSession 方块至日视图 / 周视图。
7. **Settings**: 语言切换、番茄默认参数、本地缓存管理。

### 2.3 操作环境 Operating Environment
- 浏览器：最新 Chrome / Edge / Safari / Firefox
- 桌面：Windows 10+, macOS 12+
- 移动：Android 8+, iOS 14+

### 2.4 设计与实现约束 Design Constraints
- 使用 TypeScript 全栈
- 数据库：PostgreSQL (Supabase)
- 框架：React、Tauri、React Native

### 2.5 用户文档 User Documentation
- README.md → 安装 & 使用
- 在线帮助中心（规划中）

## 3. 具体需求 Specific Requirements

### 3.1 功能需求 Functional Requirements
| ID | 标题 | 描述 |
|----|------|------|
| FR-1 | 用户注册 | 用户可通过邮箱/密码注册账号 |
| FR-2 | 登录/退出 | 支持 Session 保持与退出 |
| FR-3 | 创建 Task | 填写标题、Category、预估番茄数 |
| FR-4 | 启动番茄 | 只能在已选 Task 上启动；记录开始时间 |
| FR-5 | 通知提醒 | 番茄结束时本地通知；若离线由服务端推送 |
| FR-6 | 数据统计 | 展示当日专注分布、历史趋势 |
| FR-7 | 日历显示 | 在 Calendar 中渲染番茄块 |
| FR-8 | 离线可用 | 网络中断时可正常使用，在线后自动同步 |

### 3.2 非功能需求 Non-Functional Requirements
| ID | 类别 | 描述 |
|----|------|------|
| NFR-1 | 性能 | 启动时间 < 3s；番茄计时误差 < ±1s |
| NFR-2 | 安全 | 采用 HTTPS / TLS 1.2+；密码散列 (bcrypt)；数据库 RLS |
| NFR-3 | 可用性 | 月平均可用性 ≥ 99.5% |
| NFR-4 | 可扩展 | 预计 10k MAU 无需架构变更 |
| NFR-5 | 隐私 | 遵循 GDPR，支持数据导出 / 删除 |
| NFR-6 | 本地化 | Must support ZH & EN UI |

### 3.3 数据模型 Data Model
```mermaid
erDiagram
    User ||--o{ Task : owns
    Task ||--|{ PomodoroSession : has
    User ||--o{ Category : creates
    Category ||--o{ Task : groups

    User {
        id UUID PK
        email string
        locale string
    }
    Category {
        id UUID PK
        name string
        user_id FK
    }
    Task {
        id UUID PK
        title string
        est_pomodoros int
        category_id FK
        user_id FK
        completed_at timestamp
    }
    PomodoroSession {
        id UUID PK
        task_id FK
        user_id FK
        start_time timestamp
        end_time timestamp
        type enum(work, break)
    }
```

### 3.4 API (GraphQL 提示)
```
mutation startPomodoro($taskId: UUID!) { startPomodoro(taskId: $taskId) { id startTime } }
subscription onPomodoroDone($userId: UUID!) { pomodoroFinished(userId: $userId) { id task { title } } }
```

## 4. MVP Checklist
- [ ] Auth (FR-1, FR-2)
- [ ] Task CRUD (FR-3)
- [ ] Pomodoro (FR-4, FR-5)
- [ ] Statistics (FR-6)
- [ ] Calendar (FR-7)
- [ ] Offline (FR-8)

## 5. 里程碑 Milestones
| 日期 | 目标 |
|------|------|
| T+1 周 | 完成数据库 schema & Auth |
| T+3 周 | Web MVP 可运行 |
| T+6 周 | Desktop Beta |
| T+10 周 | Mobile Alpha |

## 6. 附录 Appendix
- 图标与 UI 资源链接
- 参考产品：番茄 ToDo、TickTick、Forest 