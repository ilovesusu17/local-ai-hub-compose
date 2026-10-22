# Local AI Hub Compose

> **v0.1.0** — 开箱即用、自托管的本地多模型 AI 反代网关编排脚手架。基于 Docker Compose，将 **New-API** 与常见的各类 AI 逆向/转接反代服务（如 WorkBuddy、Trae、Qoder、CLIProxy 等）统一部署在同一容器网络中。

适合个人开发者、独立黑客及小型开发团队，用于统一管理本地开发助手、编码插件（如 VS Code、Cursor、Windsurf 等）的 API 统一分发、额度控制与多号池管理。

[English README](./README.md) | [简体中文 README](./README_zh.md) | [渠道配置指引](./docs/usage.md) | [排障避坑指南](./docs/troubleshooting.md)

---

## 🏗️ 架构拓扑图

```text
  +-----------------------------------------------------------------------+
  |                             本地开发者宿主机                          |
  |  (VS Code / Cursor / Windsurf / Terminal / Python / Node 各类客户端)   |
  +-----------------------------------+-----------------------------------+
                                      |
                     HTTP 请求分发    | (端口 3000)
                                      v
  +===================================+===================================+
  |              统一自定义 Docker 桥接网络 (ai-hub-net)                  |
  |                                                                       |
  |   +---------------------------------------------------------------+   |
  |   |              New-API 网关统一管理容器 (new-api)               |   |
  |   |  - 令牌生成、鉴权验证与用户账户额度管控                       |   |
  |   |  - 模型路由分发与健康检测                                     |   |
  |   +-----------+---------------+---------------+---------------+   |
  |               |               |               |               |       |
  |   http://     |   http://     |   http://     |   http://     |       |
  |   workbuddy   |   trae        |   qoder       |   cliproxyapi |       |
  |   :8788       |   :8791       |   :8790       |   :8317       |       |
  |               v               v               v               v       |
  |        +------------+  +------------+  +------------+  +------------+ |
  |        | WorkBuddy  |  |    Trae    |  |   Qoder    |  | CLIProxy   | |
  |        |    Hub     |  |    Hub     |  |    Hub     |  |    API     | |
  |        +-----+------+  +-----+------+  +-----+------+  +-----+------+ |
  +==============|===============|===============|===============|========+
                 |               |               |               |
                 +---------------+-------+-------+---------------+
                                         |
                                         v (出网 HTTPS)
                           +----------------------------+
                           |     各类上游模型提供方     |
                           +----------------------------+
```

---

## 🌟 核心特性

- **统一容器互联编排**：内置预配自定义 Docker Bridge 网络（`ai-hub-net`），各容器通过服务名/容器名内网直连通信，彻底告别主机端口冲突与繁琐的反向代理配置。
- **开箱即用的 New-API 统一网关**：集中式令牌分发、用户额度管理、模型路由转发、通道限速与调用日志审计。
- **常见反代多 Hub 协同**：提供常用反代镜像的标准 Compose 服务模板与启动配置。
- **脱敏安全设计**：代码与配置完全剥离敏感信息，支持通过 `.env` 环境变量集中覆盖敏感项；`.gitignore` 严格排除本地数据文件、SQLite 数据库文件。
- **实战踩坑与排障指南**：收录 Docker 容器名解析 DNS 避坑、双区号池 Key 隔离机制、New-API 用户扣费额度与负余额排查实战文档。

---

## 🚀 极简快速开始（三步启动）

1. **获取代码并复制配置文件模板**：
   ```bash
   git clone https://github.com/ilovesusu17-a11y/local-ai-hub-compose.git
   cd local-ai-hub-compose
   cp .env.example .env
   ```
2. **一键拉起容器网络**：
   ```bash
   docker compose up -d
   ```
3. **打开控制面板开始使用**：
   - New-API 管理后台：`http://localhost:3000`（默认初始管理员：`root` / `123456`，请务必立即修改）
   - WorkBuddy Hub 面板：`http://localhost:8788`
   - Trae Hub 面板：`http://localhost:8791`

---

## 📁 目录结构

```text
local-ai-hub-compose/
├── docker-compose.yml       # 核心服务编排定义（含详细中文注释与端口说明）
├── .env.example             # 完整环境变量配置模板
├── .gitignore               # 敏感信息与持久化数据忽略规则
├── LICENSE                  # MIT 开源协议
├── CHANGELOG.md             # 语义化版本变更历史
├── CONTRIBUTING.md          # 社区贡献与 Fork / PR 提交流程规范
├── README.md                # 英文说明文档
├── README_zh.md             # 中文说明文档
├── .github/
│   └── ISSUE_TEMPLATE/      # 标准化 GitHub Issue 反馈与需求模板
└── docs/
    ├── usage.md             # New-API 渠道正确挂载与使用实战指引
    └── troubleshooting.md   # 核心避坑与排障指南（DNS 解析、双区隔离、额度机制）
```

---

## 🤝 社区贡献 / 欢迎 Fork 改进！

非常欢迎提交 Issue、提出新反代组件支持或完善文档！

我们推崇开放协作：
1. 点击右上角 **[Fork 仓库](https://github.com/ilovesusu17-a11y/local-ai-hub-compose/fork)** 到你自己的 GitHub 账号；
2. 切出特性分支（`git checkout -b feature/support-new-hub`）；
3. 提交你的脱敏改动并推送到你的 Fork 仓库；
4. 发起 **Pull Request (PR)**，维护者会第一时间核对合并！

详见 [CONTRIBUTING.md](./CONTRIBUTING.md)。

---

## ⚠️ 关键避坑必读（核心实战经验）

详细解析请参考：[排障避坑指南](./docs/troubleshooting.md) 与 [渠道接入指南](./docs/usage.md)。

1. **容器同网段互访禁止使用 `host.docker.internal`**：
   - 在自定义 Docker Bridge 网络内，各服务之间**直接使用容器名/服务名**通信，宿主机别名 `host.docker.internal` 会报 `no such host`。在 New-API 后台添加反代渠道时，API 地址请填写 `http://workbuddy:8788`、`http://trae:8791`。
2. **New-API 令牌“无限制”与账户余额扣穿陷阱**：
   - 令牌（Token）勾选“无限制”代表**直接扣减所属用户的账户总余额**。若账户余额不足或扣成负数，所有客户端都会报错 `403 Insufficient user quota`。需在管理后台「用户管理」中修改充足额度。
3. **双区/多账号号池与会话粘性缓存机制**：
   - 国内/国际双区反代为独立账号池与 Key，不可混挂重名模型；调整账号权重后，已有活跃会话存在会话粘性，需新建会话才能生效。

---

## 🔒 安全说明

本脚手架为纯净模板，**不含任何真实 API Key、账号密码或私有环境路径**。所有挂载数据卷（`./data/`）均在 `.gitignore` 保护之中。若暴露至公网环境，请务必前置搭配 HTTPS 反向代理并配置高强度访问密码。

---

## 📄 开源协议

本项目基于 [MIT License](./LICENSE) 协议开源。

---

## 🧭 项目治理文档

| 文档 | 用途 |
| --- | --- |
| [CHANGELOG.md](./CHANGELOG.md) | 版本历史与发布记录 |
| [CONTRIBUTING.md](./CONTRIBUTING.md) | Fork → 切分支 → 提 PR 完整流程 |
| [SECURITY.md](./SECURITY.md) | 安全漏洞私密报告渠道 |
| [Issue 模板](./.github/ISSUE_TEMPLATE) | 缺陷反馈与功能请求表单 |
| [PR 模板](./.github/PULL_REQUEST_TEMPLATE.md) | 每个 Pull Request 自动附带的检查清单 |
| [CODEOWNERS](./.github/CODEOWNERS) | 维护者评审路由 |
