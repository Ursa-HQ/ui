# AGENTS.md — ursahq-ui

**This repo is:** Flutter web UIs for the UrsaHQ infrastructure stack — the launcher/shell portal, deep UIs for headless services, and a shared design system.
**This repo is NOT:** Rust code, backend APIs, trading logic, ML models, media stack.

## Sister repos

| Repo | Path | Purpose |
|------|------|---------|
| ursahq-infra | ../ursahq-infra | Docker backbone, nginx proxy configs |
| ursahq-trading | ../ursahq-trading | Trading engine, MT5 bridge |
| ursahq-sites | ../ursahq-sites | UrsaClimb SaaS + brochure sites |
| ursahq-ml | ../ursahq-ml | ML training, corpus pipeline |

## Structure

```
ursahq-ui/
├── packages/
│   └── ursahq_design_system/   # Shared Flutter package: theme, status widget, nav
├── apps/
│   ├── launcher/                # Portal shell — sidebar nav, subpath routing
│   ├── mt5-bridge/              # MT5 trade monitoring UI
│   ├── trading-dashboard/       # P&L, position viewer
│   ├── subgen-queue/            # Subtitle job manager
│   └── forge-admin/             # Forge server admin panel
├── docker/                      # Shared nginx Dockerfiles
└── wiki/                        # Design decisions, component docs

## Build

- `flutter build web` — per app
- `docker compose up -d <app>` — deploy

## Guardrails

- Never modify .env files
- UIs access APIs only — never embed secrets or backend logic
- Design system package: shared version, released on change
