# Contributing to Local AI Hub Compose

Thank you for your interest in contributing to **Local AI Hub Compose**!

Whether you are fixing a configuration bug, adding support for a new AI reverse-proxy hub, or improving documentation, your help is warmly welcomed.

---

## 🌟 How to Contribute (Fork & Pull Request Workflow)

We follow the standard GitHub Fork & Pull Request model. Here are the step-by-step instructions:

### 1. Fork the Repository
Click the **Fork** button at the top-right corner of the [repository page](https://github.com/ilovesusu17-a11y/local-ai-hub-compose) to create your own copy on GitHub.

### 2. Clone Your Fork Locally
```bash
git clone https://github.com/<your-username>/local-ai-hub-compose.git
cd local-ai-hub-compose
```

### 3. Create a Feature Branch
Keep your changes scoped and clearly named:
```bash
git checkout -b feature/add-new-proxy-service
# or
git checkout -b fix/docker-dns-documentation
```

### 4. Make Your Changes
- Keep configuration templates strictly sanitized.
- **NEVER hardcode real tokens, passwords, or personal credentials.**
- Add descriptive comments in `docker-compose.yml` and `.env.example`.

### 5. Test Locally
Verify that `docker compose config` passes without syntax errors, and test running your proposed service locally:
```bash
cp .env.example .env
docker compose up -d
```

### 6. Commit & Push
```bash
git add .
git commit -m "feat: add support for XYZ proxy hub"
git push origin feature/add-new-proxy-service
```

### 7. Open a Pull Request (PR)
- Go to your fork on GitHub and click **Compare & pull request**.
- Provide a clear summary of what you changed and why.
- Maintainers will review and discuss your contribution!

---

## 💡 Submitting Issues

If you find a bug or have a suggestion, please check existing [Issues](https://github.com/ilovesusu17-a11y/local-ai-hub-compose/issues) first. When filing an issue:
- Use the provided issue templates.
- **Never include raw tokens, sensitive URLs, or production passwords in logs.**

---

## 🔒 Security Vulnerabilities

Please do not disclose security vulnerabilities publicly in an issue. Report security concerns responsibly through private channels or GitHub Security Advisories.
