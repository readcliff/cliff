#!/bin/sh
# Installs Cliff, the open-source terminal agent: https://readcliff.xyz
#
#   curl -fsSL https://readcliff.xyz/install.sh | sh
#
# What it does: checks for Node.js 18 or later, downloads one file (cliff.mjs), checks its SHA-256 against
# version.json, saves it as ~/.cliff/bin/cliff.mjs and adds a small `cliff` command to ~/.local/bin.
# No root, no other downloads, nothing sent anywhere. Read it first if you like: this is the whole installer.
# Remove Cliff: rm -rf ~/.cliff/bin ~/.local/bin/cliff   (your settings, sessions and wallet stay in ~/.cliff)
set -eu

BASE="${CLIFF_BASE:-https://readcliff.xyz}"
APP_DIR="${CLIFF_HOME:-$HOME/.cliff}/bin"
BIN_DIR="${CLIFF_BIN_DIR:-$HOME/.local/bin}"

say() { printf '%s\n' "$*" >&2; }
fail() { say "cliff install: $*"; exit 1; }

command -v node >/dev/null 2>&1 || fail "Cliff runs on Node.js 18 or later, and node was not found. Get it from https://nodejs.org (macOS: brew install node), then run this again."
major=$(node -p 'process.versions.node.split(".")[0]' 2>/dev/null || echo 0)
[ "$major" -ge 18 ] 2>/dev/null || fail "Node $(node -v 2>/dev/null) is too old; Cliff needs 18 or later. Update from https://nodejs.org."

fetch() {
  if command -v curl >/dev/null 2>&1; then curl -fsSL --proto '=https,http' "$1" -o "$2"
  elif command -v wget >/dev/null 2>&1; then wget -q -O "$2" "$1"
  else fail "curl or wget is needed to download Cliff."; fi
}

tmp=$(mktemp -d 2>/dev/null || mktemp -d -t cliff)
trap 'rm -rf "$tmp"' EXIT INT TERM

say "Downloading Cliff from $BASE"
fetch "$BASE/version.json" "$tmp/version.json" || fail "could not download $BASE/version.json"
fetch "$BASE/cliff.mjs" "$tmp/cliff.mjs" || fail "could not download $BASE/cliff.mjs"

want=$(node -e 'const v = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8")); if (!/^[0-9a-f]{64}$/.test(v.sha256)) process.exit(1); process.stdout.write(v.sha256 + " " + v.version)' "$tmp/version.json") || fail "version.json is not valid."
sha=${want%% *}
version=${want#* }
got=$(node -e 'process.stdout.write(require("crypto").createHash("sha256").update(require("fs").readFileSync(process.argv[1])).digest("hex"))' "$tmp/cliff.mjs")
[ "$got" = "$sha" ] || fail "the download's SHA-256 is $got, but version.json says $sha. Nothing was installed."

mkdir -p "$APP_DIR" "$BIN_DIR"
mv "$tmp/cliff.mjs" "$APP_DIR/cliff.mjs"
chmod 755 "$APP_DIR/cliff.mjs"
printf '#!/bin/sh\nexec node "%s" "$@"\n' "$APP_DIR/cliff.mjs" > "$BIN_DIR/cliff"
chmod 755 "$BIN_DIR/cliff"

installed=$("$BIN_DIR/cliff" --version 2>/dev/null || true)
[ "$installed" = "$version" ] || fail "installed, but \"$BIN_DIR/cliff --version\" did not answer $version."

say ""
say "Cliff $version is installed: $BIN_DIR/cliff (SHA-256 $sha)"
case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) say "Add $BIN_DIR to your PATH to type just 'cliff':"
     say "  echo 'export PATH=\"$BIN_DIR:\$PATH\"' >> ~/.profile   (zsh: ~/.zshrc)" ;;
esac
say ""
say "Next:"
say "  cliff setup     pick a model provider and paste your API key (it stays on this computer)"
say "  cliff           start in any folder"
say "  cliff --help    everything else"
