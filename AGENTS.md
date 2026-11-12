# netpi

Ansible-based setup that turns an Ubuntu host (made for a Raspberry Pi 4)
into a network troubleshooting toolkit: CLI tools plus Docker services
(Graylog, Pi-hole, Uptime Kuma, Smokeping, ntopng, Wireshark, …) behind a
Homer dashboard. I deploy it myself on my own hosts. Public repo.

Follows the SG303 baseline v2 (`sgstack/global/AGENTS.md`,
`sgstack/baseline/tools.md`). If you cannot read those: work on a branch,
open a PR, merge only with green checks (squash); never commit secrets or
personal data; English for everything in the repo; talk to me in German.

## Commands

- Install on a target host: `cp example-config.yml config.yml`, edit it,
  then `./setup.sh` (installs Ansible, runs
  `ansible/playbooks/setup_netpi.yml` locally with `config.yml`). Never run
  it on this dev host.
- Lint shell scripts: `shellcheck setup.sh && shfmt -d .`
- Validate a compose file: `docker compose -f docker/<tool>/docker-compose.yml config --quiet`
  (add `--env-file docker/<tool>/.env.example` where one exists). CI does
  this for every file that is not an Ansible template.

## Release

No releases or tags; `main` is what gets installed.

## Conventions

- Each service lives in `docker/<tool>/docker-compose.yml`. The playbook
  copies them to `{{ data_path }}/docker/<tool>/` (default `/opt`).
- Compose files that contain `{{ … }}` (wetty, sftpgo, speedtest-tracker) are
  Ansible templates, rendered with the `template` module; keep the Jinja
  syntax valid for Ansible, not for Docker Compose.
- User settings live in `config.yml` (gitignored); every new setting needs a
  documented default in `example-config.yml`.
- Secrets never go into compose files: use `${VAR:?message}` and a
  `.env.example` next to the compose file (see `docker/graylog/`). Real `.env`
  files are gitignored.
- Images are pinned to a major version where the image publishes one;
  Dependabot ignores majors that need manual upgrade steps (OpenSearch,
  MongoDB, Graylog), documented in `.github/dependabot.yml` and the README.
- The tool list for users is `docs/tools.md`; the dashboard config is
  `docker/homer/`. Update both when adding or removing a tool.
- Supported targets: Ubuntu Server 22.04 and 24.04 on arm64 (Raspberry Pi)
  and x86_64.

## Deviations from baseline

- `image-pinned`: the linuxserver.io images, Pi-hole, Homer, CORSair,
  OpenSpeedTest and ntopng stay on `latest` because they publish no
  major-version tags (see README "Image versions").
