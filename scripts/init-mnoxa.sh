#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Config
# -----------------------------
MISE_FILE="mise.toml"
FNOX_FILE="fnox.toml"
FNOX_DIR="${HOME}/.config/fnox"
AGE_KEY_FILE="${FNOX_DIR}/age.txt"
SCRIPT_URL="https://raw.githubusercontent.com/tumit/mnox/main/scripts/mnoxa.sh"

# -----------------------------
# Helpers
# -----------------------------
log() {
  echo "[mnoxa] $1"
}

error() {
  echo "[mnoxa][ERROR] $1" >&2
  exit 1
}

# -----------------------------
# Pre-checks
# -----------------------------
if ! command -v mise >/dev/null 2>&1; then
  error "mise is not installed. Install it first: https://mise.jdx.dev"
fi

# -----------------------------
# Create mise.toml
# -----------------------------
if [ -f "$MISE_FILE" ]; then
  log "$MISE_FILE already exists. Skipping generation."
else
  log "Creating $MISE_FILE..."

  cat > "$MISE_FILE" <<'EOF'
[plugins]
fnox-env = "https://github.com/jdx/mise-env-fnox"

[tools]
fnox = "latest"

[env]
_.fnox-env = { tools = true }
EOF

  log "$MISE_FILE created."
fi

# -----------------------------
# Install tools
# -----------------------------
log "Installing tools via mise..."
mise install

# -----------------------------
# Ensure age is installed
# -----------------------------
if ! command -v age >/dev/null 2>&1; then
  log "age is not installed."

  log "Please install age manually:"
  log "  Arch Linux: sudo pacman -S age"
  log "  macOS: brew install age"

  error "age is required before continuing."
fi

# -----------------------------
# Setup fnox age key
# -----------------------------
mkdir -p "$FNOX_DIR"

if [ -f "$AGE_KEY_FILE" ]; then
  log "Using existing age key: $AGE_KEY_FILE"
else
  log "Generating new age key..."
  age-keygen -o "$AGE_KEY_FILE"
  log "Age key generated at $AGE_KEY_FILE"
fi

# -----------------------------
# Extract public key
# -----------------------------
log "Extracting age public key..."

AGE_PUBLIC_KEY=$(grep -Eo 'age1[0-9a-z]+' "$AGE_KEY_FILE" | head -n1 || true)

if [ -z "$AGE_PUBLIC_KEY" ]; then
  error "Failed to extract age public key from $AGE_KEY_FILE"
fi

log "Public key: $AGE_PUBLIC_KEY"

# -----------------------------
# Create fnox.toml
# -----------------------------
if [ -f "$FNOX_FILE" ]; then
  log "$FNOX_FILE already exists. Skipping generation."
else
  log "Creating $FNOX_FILE..."

  cat > "$FNOX_FILE" <<EOF
default_provider = "age"

[providers.age]
type = "age"
recipients = ["$AGE_PUBLIC_KEY"]
EOF

  log "$FNOX_FILE created."
fi

# -----------------------------
# Verify
# -----------------------------
log "Verifying installation..."
mise ls || log "Could not list installed tools (non-fatal)."

# -----------------------------
# Done
# -----------------------------
log "Done."
log "Tip: run 'mise doctor' if something looks wrong."
log "Script source: $SCRIPT_URL"
