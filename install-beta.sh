#!/usr/bin/env bash
# Falcon PL BETA channel (opt-in). Installs the newest signed prerelease; the normal
# install.sh is unchanged and keeps installing stable.
#
#   curl -fsSL https://raw.githubusercontent.com/beartec-jpg/falcon-pl-releases/main/install-beta.sh | bash
#   ... | bash -s -- upgrade        # switch an existing node to beta
#   falcon-node upgrade --channel stable    # go back to stable later
#
# It downloads the beta's install-falcon-node.sh, checks the minisign signature on the
# release's SHA256SUMS (same pinned release key as stable) and the script's SHA256, then
# runs it with --channel beta. Extra arguments are passed through.
set -euo pipefail
REPO="${FALCON_RELEASE_REPO:-beartec-jpg/falcon-pl-releases}"
PUBKEY="RWTs+gnuKfzPik0Xbcf+m1hD/JrCUnWqaD/OAZFZEY2fcNc90D67mZlM"
die() { printf 'error %s\n' "$*" >&2; exit 1; }
command -v minisign >/dev/null || {
  if [[ $EUID -eq 0 ]] && command -v apt-get >/dev/null; then
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq minisign >/dev/null 2>&1 \
      || { apt-get update -qq >/dev/null 2>&1 && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq minisign >/dev/null 2>&1; } \
      || die "install minisign first (sudo apt install minisign)"
  else die "install minisign first (sudo apt install minisign)"; fi; }
TAG="${FALCON_BETA_TAG:-}"
if [[ -z "$TAG" ]]; then
  TAG="$(curl -fsSL --retry 3 "https://api.github.com/repos/$REPO/releases?per_page=30" | tr -d '\n' \
    | grep -oE '"tag_name": *"v[^"]+"[^{}]*"draft": *false' \
    | sed -E 's/^"tag_name": *"([^"]+)".*/\1/' | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+-beta\.[0-9]+$' \
    | sort -V | tail -1)" || true
  # Highest published beta tag by version, including a beta promoted to Latest (v2.9.79-beta.3),
  # so promoting a beta to stable never makes this script fall back to an older beta.
fi
[[ -n "$TAG" ]] || die "no beta release is available right now"
B="https://github.com/$REPO/releases/download/$TAG"; T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
for f in SHA256SUMS SHA256SUMS.minisig install-falcon-node.sh; do curl -fsSL --retry 3 -o "$T/$f" "$B/$f" || die "cannot download $f"; done
minisign -Vm "$T/SHA256SUMS" -P "$PUBKEY" -x "$T/SHA256SUMS.minisig" >/dev/null || die "SIGNATURE CHECK FAILED: do not install"
(cd "$T" && grep -E '  install-falcon-node.sh$' SHA256SUMS | sha256sum -c --quiet -) || die "CHECKSUM MISMATCH: do not install"
echo "falcon-node: beta $TAG (signature verified)"
bash "$T/install-falcon-node.sh" "$@" --channel beta
