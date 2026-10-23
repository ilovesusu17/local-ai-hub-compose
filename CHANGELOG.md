# # Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2026-10-23

### Added
- **Diagnostic Scripts**: Added cross-platform port verification scripts (`scripts/check-ports.sh` and `scripts/check-ports.ps1`) for local gateway listener testing.
- **Troubleshooting Documentation**: Added Section 6 to `docs/troubleshooting.md` addressing upstream account lockout, rate limiting, and risk-control cooldown strategies (e.g. error code 11140).

### Changed
- **Documentation Refinement**: Updated clone references and namespace pointers across English and Chinese README documents.

## [0.1.0] - 2026-10-21

### Added
- **Unified Compose Architecture**: Docker Compose template combining `new-api` with `workbuddy2api-hub`, `trae2api`, `qoder2api`, and `cliproxyapi`.
- **Pre-configured Docker Network**: User-defined bridge network (`ai-hub-net`) for zero-collision inter-container DNS routing.
- **Sanitized Environment Template**: Complete `.env.example` with full configuration comments.
- **Bilingual Documentation**: Comprehensive `README.md` and `README_zh.md` including ASCII architecture diagrams and quickstart steps.
- **Practical Troubleshooting Guide**: `docs/troubleshooting.md` addressing Docker host gateway DNS gotchas, account quota negatives, and regional token isolation.
- **Step-by-step Usage Guide**: `docs/usage.md` detailing channel configuration in New-API.
- **Community Standards**: Added `CONTRIBUTING.md`, GitHub Bug Report & Feature Request issue templates, and MIT License.
