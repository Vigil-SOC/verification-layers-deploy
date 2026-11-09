# verification-layers-deploy

DeepTempo's weekly deployment of a customized benchmark for coding agents, originally a fork of [Slop Code Bench](https://github.com/SprocketLab/slop-code-bench).

## Layout

- `deploy/weekly-seed.sh`: clones or updates the engine at the pinned commit
(`VL_ENGINE_REF`), runs `uv sync --frozen`, then `scripts/vl_seed.sh`. Credentials
come from the environment only.
- `deploy/vl-seed.service`, `deploy/vl-seed.timer`: systemd units for a weekly run
(Monday 06:00 UTC) on the Linux host. `deploy/crontab.example` is the cron
equivalent.
- `.env.example`: the variables the run needs, names only. The filled-in copy lives
at `/etc/verification-layers/env` on the host and is never committed.
- `posts/`: the DeepTempo write-up of each seed, once approved.

To move to a new engine version, change `VL_ENGINE_REF` in `deploy/weekly-seed.sh`.
