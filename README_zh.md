# Local AI Hub Compose

一个开箱即用、自托管的本地多模型 AI 反代网关编排脚手架。基于 Docker Compose，将 **New-API** 与常见的各类 AI 逆向/转接反代服务（如 WorkBuddy、Trae、Qoder、CLIProxy 等）统一部署在同一容器网络中。

适合个人开发者、独立黑客及小型开发团队，用于统一管理本地开发助手、编码插件（如 VS Code、Cursor、Windsurf 等）的 API 统一分发、额度控制与多号池管理。

[English README](./README.md) | [简体中文 README](./README_zh.md)

---

## 🌟 核心特性

- **统一容器互联编排**：内置预配自定义 Docker Bridge 网络（`ai-hub-net`），各容器通过服务名/容器名内网直连通信，彻底告别主机端口冲突与繁琐的反向代理配置。
- **开箱即用的 New-API 统一网关**：集中式令牌分发、用户额度管理、模型路由转发、通道限速与调用日志审计。
- **常见反代多 Hub 协同**：提供常用反代镜像的标准 Compose 服务模板与启动配置。
- **脱敏安全设计**：代码与配置完全剥离敏感信息，支持通过 `.env` 环境变量集中覆盖敏感项；`.gitignore` 严格排查本地数据文件、SQLite 数据库文件。
- **实战踩坑与排障指南**：收录 Docker 容器名解析 DNS 避坑、双区号池 Key 隔离机制、New-API 用户扣费额度与负余额排查实战文档。

---

## 📁 目录结构

```text
local-ai-hub-compose/
├── docker-compose.yml       # 核心服务编排定义
├── .env.example             # 环境变量配置模板
├── .gitignore               # 敏感信息与持久化数据忽略规则
├── LICENSE                  # MIT 开源协议
├── README.md                # 英文说明文档
├── README_zh.md             # 中文说明文档
└── docs/
    └── troubleshooting.md   # 核心避坑与排障实战指南（网络解析、双区隔离、额度机制）
```

---

## 🚀 快速开始

### 1. 环境准备

- Docker Engine 24.0+ 与 Docker Compose v2.20+
- 操作系统：Windows (Docker Desktop / WSL2) / Linux / macOS

### 2. 获取代码与初始化配置

```bash
git clone https://github.com/<your-username>/local-ai-hub-compose.git
cd local-ai-hub-compose

# 复制环境变量模板
cp .env.example .env
```

根据实际需要修改 `.env` 中的端口映射和认证密钥。

### 3. 一键启动

```bash
docker compose up -d
```

### 4. 访问服务

- **New-API Web 管理面板**：`http://localhost:3000`
  - 默认初始账号密码：`root` / `123456`（**首次登录请务必立即修改！**）
- **WorkBuddy Hub 管理面板**：`http://localhost:8788`
- **Trae Hub 管理面板**：`http://localhost:8791`
- **Qoder Hub 管理面板**：`http://localhost:8790`
- **CLIProxy API 入口**：`http://localhost:8317`

---

## ⚠️ 关键避坑必读（核心实战经验）

详细解析请参考：[常见排障与避坑指南](./docs/troubleshooting.md)。

1. **容器同网段互访禁止使用 `host.docker.internal`**：
   - 在自定义 Docker Bridge 网络内，各服务之间**直接使用容器名/服务名**通信，宿主机别名 `host.docker.internal` 在该网络中通常无法解析（报 `no such host`）。
   - 在 New-API 后台添加反代渠道时，API 代理地址请填写：
     - 正确：`http://workbuddy:8788`、`http://trae:8791`
     - 错误：`http://host.docker.internal:8788`

2. **New-API 令牌“无限制”与账户余额扣穿陷阱**：
   - 令牌（Token）勾选“无限制”并不代表无限免费调用，而是代表**直接消耗所属用户的账户余额**。
   - 若用户（如 admin）自身账户余额不足或扣穿至负数（例如大上下文并发消耗超速），所有客户端发起调用时都会直接报 `403 Insufficient user quota` 或 `403 user quota`。
   - 解决办法：在 New-API 管理后台「用户管理」中将对应用户的额度修改为充足的大数值，或在「钱包」中充值。

3. **双区/多账号号池与会话粘性缓存机制**：
   - 支持国内/国际双区的反代组件通常为独立账号池与独立鉴权 Key，不可混用；
   - 账号池分配算法往往存在会话粘性（优先复用已有缓存的账号），调整权重后旧会话通常仍走原账号，只有禁用旧号或新建会话才会切换。

---

## 🔒 安全说明

本脚手架为纯净模板，**不含任何真实 API Key、账号密码或私有环境路径**。所有挂载数据卷（`./data/`）均在 `.gitignore` 保护之中。若暴露至公网环境，请务必前置搭配 HTTPS 反向代理并配置高强度访问密码。

---

## 📄 开源协议

本项目基于 [MIT License](./LICENSE) 协议开源。
