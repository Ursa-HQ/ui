# UrsaHQ UI

Flutter web UIs for the UrsaHQ homeserver stack — a shell/launcher portal + deep UIs for headless services.

## Architecture

```
ursahq-ui/
├── packages/
│   └── ursahq_design_system/   # Shared: theme, status widgets, nav bar components
├── apps/
│   ├── launcher/                # The "better Homepage" — sidebar + content area shell
│   │                           # Routes to /service-name via nginx subpath
│   ├── mt5-bridge/              # MT5 trade monitor, open positions (TBD)
│   ├── trading-dashboard/       # P&L, position viewer (TBD)
│   ├── subgen-queue/            # Subtitle job queue (TBD)
│   └── ...                      # More as built
├── docker/                      # Shared nginx Dockerfiles for Flutter web builds
└── AGENTS.md
```

## Running

### Docker (recommended for deployment)
```bash
docker compose up -d launcher
```

### Manual (for development)
```bash
# Install Flutter SDK ≥3.x
cd apps/launcher
cp .env.example .env   # Set your API_URL
flutter build web
# Serve build/web/ with any HTTP server
```

## Repos

| Repo | Path | Purpose |
|------|------|---------|
| ursahq-infra | /mnt/fast/ursahq-infra | Nginx config, Docker backbone |
| ursahq-sites | /mnt/fast/ursahq-sites | UrsaClimb + brochure sites |
| ursahq-trading | /mnt/fast/ursahq-trading | Trading engine, MT5 |
| ursahq-open | /mnt/fast/ursahq-open | Public Rust crates |
