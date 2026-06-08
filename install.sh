#!/usr/bin/env bash
#
# SwiftLaw CLI installer — no Homebrew, no Xcode Command Line Tools, no sudo.
#
#   curl -fsSL https://raw.githubusercontent.com/SwiftLaw-Conductor/homebrew-tap/main/install.sh | bash
#
# Downloads the latest self-contained release bundle and installs a `swiftlaw`
# command into ~/.local/bin. Requires Node (runtime); auto-installs uv (the
# Python document engine provisioner) if it's missing.
#
set -euo pipefail

TAP_REPO="SwiftLaw-Conductor/homebrew-tap"
APP_DIR="${HOME}/.local/share/swiftlaw"
BIN_DIR="${HOME}/.local/bin"
BIN="${BIN_DIR}/swiftlaw"

info()  { printf '\033[1;36m==>\033[0m %s\n' "$1"; }
warn()  { printf '\033[1;33mwarning:\033[0m %s\n' "$1"; }
die()   { printf '\033[1;31merror:\033[0m %s\n' "$1" >&2; exit 1; }

# --- prerequisites -----------------------------------------------------------
command -v curl >/dev/null 2>&1 || die "curl is required."
command -v tar  >/dev/null 2>&1 || die "tar is required."

NODE="$(command -v node || true)"
if [ -z "${NODE}" ]; then
  die "Node.js (>=20) is required but was not found.
  Install it from https://nodejs.org/ (LTS) and re-run this installer."
fi

# uv provisions the Python document engine on first run. Install it if absent
# (official, self-contained, no sudo).
if ! command -v uv >/dev/null 2>&1; then
  info "Installing uv (Python engine provisioner)…"
  curl -LsSf https://astral.sh/uv/install.sh | sh >/dev/null 2>&1 || \
    warn "Could not auto-install uv. Install it from https://docs.astral.sh/uv/ before running 'swiftlaw init'."
fi

# --- resolve latest release --------------------------------------------------
info "Finding the latest SwiftLaw release…"
TAG="$(curl -fsSL "https://api.github.com/repos/${TAP_REPO}/releases/latest" \
        | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -1)"
[ -n "${TAG}" ] || die "Could not determine the latest release tag from ${TAP_REPO}."
VERSION="${TAG#v}"
URL="https://github.com/${TAP_REPO}/releases/download/${TAG}/swiftlaw-${VERSION}.tar.gz"

# --- download + install ------------------------------------------------------
TMP="$(mktemp -d)"
trap 'rm -rf "${TMP}"' EXIT
info "Downloading swiftlaw ${VERSION}…"
curl -fSL "${URL}" -o "${TMP}/swiftlaw.tar.gz" || die "Download failed: ${URL}"

info "Installing to ${APP_DIR}…"
rm -rf "${APP_DIR}"; mkdir -p "${APP_DIR}"
tar -xzf "${TMP}/swiftlaw.tar.gz" -C "${APP_DIR}" --strip-components=1

mkdir -p "${BIN_DIR}"
cat > "${BIN}" <<EOF
#!/bin/bash
exec "${NODE}" "${APP_DIR}/dist/index.js" "\$@"
EOF
chmod 0755 "${BIN}"

# --- PATH check + done -------------------------------------------------------
printf '\033[1;32m✓ Installed swiftlaw %s\033[0m\n' "${VERSION}"
case ":${PATH}:" in
  *":${BIN_DIR}:"*) : ;;
  *) warn "${BIN_DIR} is not on your PATH. Add this to your shell profile:
    export PATH=\"${BIN_DIR}:\$PATH\"" ;;
esac
echo
echo "Get started:"
echo "  swiftlaw init                       # provision the engine + set your API key"
echo "  swiftlaw \"draft an NDA for ...\"      # one-shot"
echo "  swiftlaw                            # interactive"
