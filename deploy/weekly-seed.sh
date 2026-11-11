#!/usr/bin/env bash
# Weekly seed of the verification-layers instrument.
#
# Clones or updates Vigil-SOC/verification-layers at a pinned ref, installs
# it with uv, and runs scripts/vl_seed.sh. Credentials and the GCP project come
# from the environment (see .env.example); nothing is read from this repo.
#
#   deploy/weekly-seed.sh            # uses VL_* defaults below
#
# Host needs: git, uv, docker (daemon running, user in the docker group), and
# the Claude Code CLI at the version pinned in the engine's
# configs/agents/claude_code_vl.yaml. The engine is a uv project; its own
# Docker image is pulled on first run.
set -euo pipefail

: "${GOOGLE_APPLICATION_CREDENTIALS:?path to the Vertex-only service-account key}"
: "${ANTHROPIC_VERTEX_PROJECT_ID:?GCP project that bills the Vertex calls}"
export CLOUD_ML_REGION="${CLOUD_ML_REGION:-global}"
export DOCKER_CONFIG="${DOCKER_CONFIG:-$HOME/.docker}"

VL_ENGINE_URL="${VL_ENGINE_URL:-https://github.com/Vigil-SOC/verification-layers}"
VL_ENGINE_REF="${VL_ENGINE_REF:-bf8d53a7c35107d1a6eeff4cc38bb7503ba7d212}"   # tag or commit of the engine repo
VL_HOME="${VL_HOME:-$HOME/verification-layers}"    # engine checkout; outputs/ lives under it
VL_WORKERS="${VL_WORKERS:-2}"                      # parallel problems per arm
VL_LOG_DIR="${VL_LOG_DIR:-$VL_HOME/outputs/deploy-logs}"

if [[ ! -d "$VL_HOME/.git" ]]; then
  git clone --quiet "$VL_ENGINE_URL" "$VL_HOME"
fi
git -C "$VL_HOME" remote set-url origin "$VL_ENGINE_URL"   # follow VL_ENGINE_URL if an older checkout points elsewhere
git -C "$VL_HOME" fetch --quiet --tags origin
git -C "$VL_HOME" checkout --quiet --detach "$VL_ENGINE_REF"

cd "$VL_HOME"
uv sync --frozen --quiet
mkdir -p "$VL_LOG_DIR"
stamp="$(date -u +%Y%m%dT%H%M)"
echo "verification-layers seed $stamp: engine $(git rev-parse --short HEAD), $VL_WORKERS workers per arm"
scripts/vl_seed.sh "$VL_WORKERS" 2>&1 | tee "$VL_LOG_DIR/seed-$stamp.log"
status="${PIPESTATUS[0]}"

# The seed script writes outputs/vl/seed-<stamp>.md and .csv; list what landed.
ls -1t outputs/vl/seed-*.md 2>/dev/null | head -1
exit "$status"
