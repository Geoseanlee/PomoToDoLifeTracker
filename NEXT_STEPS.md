# 下一步操作指南

**最后修改时间**: 2024-12-19 14:30:00

## 1. 安装依赖包

```bash
# 安装根目录依赖
pnpm install

# 安装 Web 项目依赖  
cd web && pnpm install
```

## 2. 启动开发环境

### 安装 Docker Desktop（必需）
下载并安装：https://docs.docker.com/desktop/

### 启动 Supabase 本地服务
```bash
# 回到根目录
cd ..
npx supabase start
```

首次启动会下载 Docker 镜像，需要几分钟时间。

### 配置环境变量
创建 `web/.env.local` 文件：
```env
NEXT_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=从控制台获取
SUPABASE_SERVICE_ROLE_KEY=从控制台获取
```

启动 Supabase 后，会显示所有服务的 URL 和密钥。

### 启动 Web 开发服务器
```bash
cd web
pnpm dev
```

## 3. 测试 Auth 流程

1. 访问 http://localhost:3000/auth
2. 注册新用户账户
3. 检查 Supabase Studio (http://127.0.0.1:54323) 中的用户数据

## 4. 第二周计划（T+3周目标：Web MVP）

接下来需要实现：

### 核心功能开发
- [ ] Task CRUD 操作
- [ ] 番茄钟计时器组件
- [ ] 统计面板（圆饼图 + 折线图）
- [ ] 日历视图
- [ ] 本地通知

### 技术任务
- [ ] 设置 GraphQL 或 REST API 
- [ ] 离线数据缓存 (IndexedDB)
- [ ] 响应式设计
- [ ] 多语言支持 (i18n)

## 5. 有用的开发工具

- **Supabase Studio**: http://127.0.0.1:54323 - 数据库管理界面
- **Inbucket**: http://127.0.0.1:54324 - 邮件测试工具
- **API 文档**: http://127.0.0.1:54321/rest/v1/ - 自动生成的 API

## 6. 常用命令

```bash
# 重置数据库
npx supabase db reset

# 生成新的迁移文件
npx supabase migration new <name>

# 生成 TypeScript 类型
npx supabase gen types typescript --local > web/src/types/supabase.ts

# 停止所有服务
npx supabase stop
```

## 7. 故障排除

### Docker 相关问题
- 确保 Docker Desktop 正在运行
- 检查端口 54321-54326 是否被占用

### 依赖安装问题
- 确保使用 Node.js 18+ 和 pnpm 8+
- 清理缓存：`pnpm store prune`

### Auth 问题  
- 检查环境变量是否正确设置
- 确认 Supabase 服务正常运行

---

🎯 **目标**：在第二周结束时，您应该有一个可运行的 Web MVP，包含完整的任务管理和番茄钟功能！ 