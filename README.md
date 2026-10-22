# Local AI Hub Compose

A production-ready, self-hosted Docker Compose template for orchestrating **New-API** alongside multiple AI reverse-proxy hubs (WorkBuddy, Trae, Qoder, CLIProxy, etc.) on a single unified Docker bridge network.

Designed for developers, homelabs, and small teams seeking a centralized, cost-effective API gateway for their local AI coding assistants and LLM tools.

[简体中文 README](./README_zh.md) | [English README](./README.md)

---

## 🌟 Features

- **Unified Network Orchestration**: Pre-configured user-defined Docker bridge network (`ai-hub-net`), enabling seamless inter-container routing by service/container name without host port collisions.
- **Out-of-the-Box New-API Gateway**: Centralized token distribution, user quota management, model routing, and per-channel rate limits.
- **Multi-Hub Ecosystem**: Ready-to-use Compose definitions for common proxy hubs (workbuddy2api-hub, trae, qoder, cliproxyapi).
- **Hardened Zero-Leakage Defaults**: Strictly sanitized configs, non-root storage paths, and zero hardcoded credentials. All variables mapped via `.env`.
- **Battle-Tested Pitfall Guide**: Real-world troubleshooting documentation for common Docker DNS gotchas, dual-region token routing, and New-API balance traps.

---

## 📁 Repository Structure

```text
local-ai-hub-compose/
├── docker-compose.yml       # Primary service orchestration
├── .env.example             # Environment variable template
├── .gitignore               # Strict exclusion of secrets and local mounts
├── LICENSE                  # MIT License
├── README.md                # English documentation
├── README_zh.md             # Chinese documentation
└── docs/
    └── troubleshooting.md   # Practical guide for DNS, quota, and regional routing
```

---

## 🚀 Quick Start

### 1. Prerequisites

- Docker Engine 24.0+ & Docker Compose v2.20+
- Host operating system: Linux / macOS / Windows with Docker Desktop or WSL2

### 2. Clone & Configure

```bash
git clone https://github.com/<your-username>/local-ai-hub-compose.git
cd local-ai-hub-compose

# Copy configuration template
cp .env.example .env
```

Review and adjust ports or credentials inside `.env` to match your local setup.

### 3. Launch Services

```bash
docker compose up -d
```

### 4. Initial Access

- **New-API Web Console**: `http://localhost:3000`
  - Default initial login: `root` / `123456` (**Change immediately upon first login!**)
- **WorkBuddy Hub Console**: `http://localhost:8788`
- **Trae Hub Console**: `http://localhost:8791`
- **Qoder Hub Console**: `http://localhost:8790`
- **CLIProxy API**: `http://localhost:8317`

---

## ⚠️ Critical Docker & Gateway Pitfalls

Read the comprehensive [Troubleshooting & Gotchas Guide](./docs/troubleshooting.md) for deeper explanations.

1. **Do NOT use `host.docker.internal` across Custom Docker Networks**:
   - In user-defined Docker bridge networks, containers resolve peers **by container or service name**, not `host.docker.internal`.
   - When adding a channel inside the New-API UI, specify:
     - `http://workbuddy:8788` (Correct)
     - `http://trae:8791` (Correct)
     - `http://host.docker.internal:8788` (❌ Will fail with `no such host`)

2. **New-API "Unlimited" Token Balance Trap**:
   - Marking a New-API user token as "Unlimited" (`无限制`) does **NOT** grant infinite free generations. It directs the token to consume the **owner's account balance**.
   - If the user account quota runs dry or drops negative, all client requests will immediately return HTTP `403 Insufficient user quota`.
   - Ensure the user account has adequate balance allocated via `Admin -> Users -> Edit Quota`.

3. **Dual-Region / Multi-Account Session Sticky Pools**:
   - Reverse-proxy hubs with dual-region support (e.g., Domestic vs. International pools) isolate their keys and upstream endpoints.
   - Active conversational sessions often latch onto their first selected pool account to maximize KV cache reuse. Switching account weights won't migrate in-flight sessions unless explicitly reset or toggled off.

---

## 🔒 Security & Privacy Notice

This repository contains **zero credentials, zero private keys, and zero proprietary configurations**. All persistent data directories and SQLite databases (`*.db`, `data/`) are strictly ignored via `.gitignore`. Always run this stack behind a trusted reverse proxy (e.g., Caddy, Nginx with HTTPS) if exposed outside `localhost`.

---

## 📄 License

Distributed under the [MIT License](./LICENSE).
