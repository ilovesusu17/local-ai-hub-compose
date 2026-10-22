# Local AI Hub Compose

[![release](https://img.shields.io/badge/release-v0.1.0-blue)](./CHANGELOG.md)
[![license](https://img.shields.io/badge/license-MIT-green)](./LICENSE)
[![docker compose](https://img.shields.io/badge/Docker--Compose-required-2496ed?logo=docker&logoColor=white)](./docker-compose.yml)
[![prereqs](https://img.shields.io/badge/needs-Docker%20Desktop%20%7C%20Engine-lightgrey)](./docs/troubleshooting.md)
[![contributions](https://img.shields.io/badge/contributions-welcome-brightgreen)](./CONTRIBUTING.md)

> **v0.1.0** — A self-hosted, all-in-one Docker Compose orchestration template for **New-API** and multiple AI reverse-proxy hubs on a unified Docker bridge network.

Designed for developers, homelabs, and small engineering teams seeking a centralized, cost-effective API gateway for their local AI coding assistants and LLM tools.

[简体中文 README](./README_zh.md) | [English README](./README.md) | [Usage Guide](./docs/usage.md) | [Troubleshooting](./docs/troubleshooting.md)

---

## 🏗️ Architecture

```text
  +-----------------------------------------------------------------------+
  |                          Local Developer Host                         |
  |  (VS Code / Cursor / Windsurf / Terminal / Python / Node Clients)     |
  +-----------------------------------+-----------------------------------+
                                      |
                     HTTP Requests    | (Port 3000)
                                      v
  +===================================+===================================+
  |              Unified Docker Bridge Network (ai-hub-net)               |
  |                                                                       |
  |   +---------------------------------------------------------------+   |
  |   |              New-API Gateway Container (new-api)              |   |
  |   |  - Token Authentication & Quota Management                    |   |
  |   |  - Model Routing & Load Balancing                             |   |
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
                                         v (Outbound HTTPS)
                           +----------------------------+
                           |  Upstream Model Providers  |
                           +----------------------------+
```

---

## 🌟 Features

- **Unified Network Orchestration**: Pre-configured user-defined Docker bridge network (`ai-hub-net`), enabling seamless inter-container routing by service/container name without host port collisions.
- **Out-of-the-Box New-API Gateway**: Centralized token distribution, user quota management, model routing, and per-channel rate limits.
- **Multi-Hub Ecosystem**: Ready-to-use Compose definitions for common proxy hubs (workbuddy2api-hub, trae, qoder, cliproxyapi).
- **Hardened Zero-Leakage Defaults**: Strictly sanitized configs, non-root storage paths, and zero hardcoded credentials. All variables mapped via `.env`.
- **Battle-Tested Pitfall Guide**: Real-world troubleshooting documentation for common Docker DNS gotchas, dual-region token routing, and New-API balance traps.

---

## 🚀 Quick Start (3 Steps)

1. **Clone and copy environment template**:
   ```bash
   git clone https://github.com/ilovesusu17-a11y/local-ai-hub-compose.git
   cd local-ai-hub-compose
   cp .env.example .env
   ```
2. **Start the containers**:
   ```bash
   docker compose up -d
   ```
   > **Note**: `new-api` pulls a real upstream image, but the four hub services ship as **placeholder image names** (`ghcr.io/local-hub/*`). Replace `WORKBUDDY_IMAGE` / `TRAE_IMAGE` / `QODER_IMAGE` / `CLIPROXY_IMAGE` in `.env` with the images you actually run (or remove those services) before `up`, otherwise their pulls will fail.
3. **Open the web consoles**:
   - New-API Gateway: `http://localhost:3000` (Default: `root` / `123456`)
   - WorkBuddy Hub: `http://localhost:8788`
   - Trae Hub: `http://localhost:8791`
   - Qoder Hub: `http://localhost:8790`
   - CLIProxy API: `http://localhost:8317`

---

## 📁 Repository Structure

```text
local-ai-hub-compose/
├── docker-compose.yml       # Primary service orchestration with comments
├── .env.example             # Comprehensive environment variable template
├── .gitignore               # Strict exclusion of secrets and local mounts
├── LICENSE                  # MIT License
├── CHANGELOG.md             # Semantic release history
├── CONTRIBUTING.md          # Fork & Pull Request guidelines
├── README.md                # English documentation
├── README_zh.md             # Chinese documentation
├── .github/
│   └── ISSUE_TEMPLATE/      # Standardized bug & feature request templates
└── docs/
    ├── usage.md             # Practical guide for New-API channel setup
    └── troubleshooting.md   # Practical guide for DNS, quota, and regional routing
```

---

## 🤝 Contributing / Welcome to Fork!

Contributions, feature suggestions, and documentation improvements are welcome!

We love community collaboration. If you have a fix or want to add support for another reverse-proxy container:
1. **[Fork this repository](https://github.com/ilovesusu17-a11y/local-ai-hub-compose/fork)** to your own account.
2. Create a feature branch (`git checkout -b feature/awesome-hub`).
3. Commit your sanitized changes and push to your fork.
4. Submit a **Pull Request**!

Please check [CONTRIBUTING.md](./CONTRIBUTING.md) for detailed guidelines.

---

## ⚠️ Critical Docker & Gateway Pitfalls

Read the comprehensive [Troubleshooting Guide](./docs/troubleshooting.md) and [Usage Guide](./docs/usage.md) for full details:

1. **Do NOT use `host.docker.internal` across Custom Docker Networks**:
   - Always route channels using **container names** (e.g. `http://workbuddy:8788`, `http://trae:8791`).
2. **New-API "Unlimited" Token Balance Trap**:
   - Marking a token as "Unlimited" redirects billing directly to the **parent user's quota balance**. Keep user quotas topped up to prevent `403 Insufficient user quota` errors.
3. **Dual-Region / Multi-Account Session Sticky Pools**:
   - Maintain separate channels for domestic vs. international account pools, and be aware of KV cache affinity on ongoing sessions.

---

## 🔒 Security & Privacy Notice

This repository contains **zero credentials, zero private keys, and zero proprietary configurations**. All persistent data directories and SQLite databases (`*.db`, `data/`) are strictly ignored via `.gitignore`. Always run this stack behind a trusted reverse proxy (e.g., Caddy, Nginx with HTTPS) if exposed outside `localhost`.

---

## 📄 License

Distributed under the [MIT License](./LICENSE).

---

## 🧭 Project Governance

| Document | Purpose |
| --- | --- |
| [CHANGELOG.md](./CHANGELOG.md) | Version history and release notes |
| [CONTRIBUTING.md](./CONTRIBUTING.md) | Fork → branch → PR workflow |
| [SECURITY.md](./SECURITY.md) | How to report vulnerabilities privately |
| [Issue templates](./.github/ISSUE_TEMPLATE) | Bug report and feature request forms |
| [PR template](./.github/PULL_REQUEST_TEMPLATE.md) | Checklist applied to every pull request |
| [CODEOWNERS](./.github/CODEOWNERS) | Maintainer review routing |
