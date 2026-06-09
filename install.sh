#!/usr/bin/env bash
#
# SwiftLaw CLI installer — no Homebrew, no Node, no Python, no sudo.
#
#   curl -fsSL https://raw.githubusercontent.com/SwiftLaw-Conductor/homebrew-tap/main/install.sh | bash
#
# Downloads the latest self-contained native binary for your OS/arch and installs
# a `swiftlaw` command into ~/.local/bin. The binary is fully standalone
# (Bun-compiled) — nothing else to install. Authenticate with `swiftlaw login`.
#
set -euo pipefail

TAP_REPO="SwiftLaw-Conductor/homebrew-tap"
BIN_DIR="${HOME}/.local/bin"
BIN="${BIN_DIR}/swiftlaw"

info()  { printf '\033[1;36m==>\033[0m %s\n' "$1"; }
warn()  { printf '\033[1;33mwarning:\033[0m %s\n' "$1"; }
die()   { printf '\033[1;31merror:\033[0m %s\n' "$1" >&2; exit 1; }

# --- prerequisites -----------------------------------------------------------
command -v curl >/dev/null 2>&1 || die "curl is required."

# --- detect platform → release asset name ------------------------------------
OS="$(uname -s)"
ARCH="$(uname -m)"
case "${OS}" in
  Darwin) case "${ARCH}" in
            arm64)        ASSET="swiftlaw-darwin-arm64" ;;
            x86_64)       ASSET="swiftlaw-darwin-x64" ;;
            *) die "Unsupported macOS arch: ${ARCH}" ;;
          esac ;;
  Linux)  case "${ARCH}" in
            x86_64|amd64) ASSET="swiftlaw-linux-x64" ;;
            *) die "Unsupported Linux arch: ${ARCH} (only x86_64 is published).
  On Windows use: winget install SwiftLaw.CLI" ;;
          esac ;;
  *) die "Unsupported OS: ${OS}.
  On Windows use: winget install SwiftLaw.CLI" ;;
esac

# --- resolve the latest release ----------------------------------------------
info "Finding the latest SwiftLaw release…"
TAG="$(curl -fsSL "https://api.github.com/repos/${TAP_REPO}/releases/latest" \
        | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -1)"
[ -n "${TAG}" ] || die "Could not determine the latest release tag from ${TAP_REPO}."
VERSION="${TAG#cli-v}"
URL="https://github.com/${TAP_REPO}/releases/download/${TAG}/${ASSET}"

# --- download + install ------------------------------------------------------
TMP="$(mktemp -d)"
trap 'rm -rf "${TMP}"' EXIT
info "Downloading ${ASSET} (${VERSION})…"
curl -fSL "${URL}" -o "${TMP}/swiftlaw" || die "Download failed: ${URL}"

mkdir -p "${BIN_DIR}"
install -m 0755 "${TMP}/swiftlaw" "${BIN}"

# --- verify + PATH check + done ----------------------------------------------
INSTALLED="$("${BIN}" --version 2>/dev/null || true)"
[ -n "${INSTALLED}" ] || die "Installed binary failed to run (${BIN})."
printf '\033[1;32m✓ Installed swiftlaw %s → %s\033[0m\n' "${INSTALLED}" "${BIN}"

case ":${PATH}:" in
  *":${BIN_DIR}:"*) : ;;
  *) warn "${BIN_DIR} is not on your PATH. Add this to your shell profile:
    export PATH=\"${BIN_DIR}:\$PATH\"" ;;
esac
echo
echo "Get started:"
echo "  swiftlaw login        # paste an sl_… token (tryswiftlaw.com/app → avatar → CLI Tokens)"
echo "  swiftlaw              # interactive"
