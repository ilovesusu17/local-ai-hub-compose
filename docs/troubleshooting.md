# Troubleshooting & Practical Pitfalls Guide

This guide compiles practical lessons, edge cases, and architectural caveats gathered from configuring and running multi-hub AI reverse-proxy clusters behind New-API.

---

## 1. Container DNS & Inter-Service Connectivity

### Symptom: `no such host` or connection refused inside New-API
When adding an upstream proxy channel inside the New-API console (e.g., pointing to WorkBuddy or Trae), requests fail with:
```text
dial tcp: lookup host.docker.internal on 127.0.0.11:53: no such host
```

### Cause
By default, custom user-defined Docker bridge networks (`ai-hub-net`) provide automatic DNS resolution **only for container and service names**. The special alias `host.docker.internal` is intended for host-container bridge loops and is frequently unresolvable within user-defined Linux/Windows container networks without explicit host-gateway extra_hosts entries.

### Solution
Always connect services via their **container name** and internal port:
- WorkBuddy upstream: `http://workbuddy:8788`
- Trae upstream: `http://trae:8791`
- Qoder upstream: `http://qoder:8790`
- CLIProxy upstream: `http://cliproxyapi:8317`

---

## 2. New-API "Unlimited" Token Balance Trap

### Symptom: HTTP 403 `Insufficient user quota, remaining quota: $-XX.XX`
Clients suddenly receive HTTP 403 errors stating `Insufficient user quota` or negative quota values, even though the token in use was created with the **"Unlimited" (`无限制`)** checkbox ticked.

### Cause
In New-API's accounting model:
- A token marked with a specific quota consumes only up to that threshold.
- A token marked as **Unlimited** redirects all billing directly to the **parent User Account's total quota balance**.
- When large context requests (e.g., 200k-400k tokens in long-chain coding sessions) execute rapidly, the parent user account's quota can be exhausted and enter negative figures.

### Solution
1. Log in to the New-API Web Console as `root`/`admin`.
2. Navigate to **Console -> Admin -> Users (用户管理)**.
3. Locate the target user and click **Edit (编辑)**.
4. Increase the **Quota (额度)** field to an ample number (e.g., `1000000000`) or top up via the Wallet interface.
5. Save changes. Downstream clients will resume normal operations immediately without restarting containers.

---

## 3. Dual-Region Multi-Account Isolation & Session Stickiness

### Symptom: Weight modifications do not immediately rotate the upstream account
When running multi-account pools with dual regions (Domestic vs. International pools):
1. Keys configured for Domestic pools cannot access International accounts, and vice-versa. Maintain separate upstream channels for each region.
2. Even after lowering an account's selection weight in the proxy hub, ongoing coding conversations continue targeting the previous account until restarted.

### Cause
Modern AI reverse proxy hubs implement KV cache affinity (session stickiness) to preserve prefix caching benefits and reduce token latency. The hub binds an ongoing session ID to the initial account assigned at session initiation.

### Solution
- To force an immediate rotation, explicitly disable the active account in the hub UI or create a brand new conversation thread in your coding assistant client.
- Do not mix model names between distinct regional channels in New-API; assign explicit aliases or routing models (e.g., `model-domestic`, `model-intl`).

---

## 4. Placeholder Hub Images Fail to Pull

### Symptom: `docker compose up` fails while pulling `ghcr.io/local-hub/*` (image not found / denied)

### Cause
The four hub services (`workbuddy`, `trae`, `qoder`, `cliproxyapi`) ship with **placeholder image names** as defaults in `docker-compose.yml`. The real upstream projects publish images under their own registries, so a fresh clone cannot pull `ghcr.io/local-hub/*`.

### Solution
1. In `.env`, set `WORKBUDDY_IMAGE`, `TRAE_IMAGE`, `QODER_IMAGE`, `CLIPROXY_IMAGE` to the real image references recommended by each upstream project's own README.
2. If you only need the gateway, remove the hub services you do not run and keep `new-api` alone.
3. Re-run `docker compose up -d` — swap the placeholders before first start so nothing mounts against a never-running container.

---

## 5. Healthchecks Report "unhealthy" While the Port Answers

### Symptom
A hub container shows `unhealthy` in `docker ps`, yet its web console opens fine from the browser.

### Cause
The generic `wget --spider` probe assumes the image ships `wget`. Some minimal images have no probe tool inside, so the check fails even though the service works.

### Solution
Replace that service's `healthcheck.test` with a probe the image really supports (for example a `node`-based check, the vendor's own status endpoint, or a `curl` variant) — or remove the healthcheck for that service. Healthchecks are observational here; nothing in this compose file depends on them.

---

## 6. Upstream Account Concurrency Lockout & Risk Cooldown (e.g. Code 11140 / 403 / 429)

### Symptom
A hub proxy repeatedly yields HTTP 403 or 429 errors indicating account restrictions, or the gateway logs display `account restricted / anomaly detected` (such as WorkBuddy upstream error code `11140`).

### Cause
When multiple agents or continuous long-context streams hit the upstream API simultaneously from a single IP or session pool, provider security defenses may temporarily lock the account realm to prevent mass credential suspension.

### Solution
1. **Enforce Cooldown Periods**: Configure the gateway or reverse proxy to enter a self-protecting cooldown interval (e.g. 15–30 minutes) rather than aggressive immediate retries.
2. **Account Sharding**: Split domestic and international accounts into distinct upstream pools.
3. **Dedicated Client Identity**: Ensure upstream tokens and client identifiers match expected API channel signatures to avoid heuristic flag rules.
