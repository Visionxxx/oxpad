#!/usr/bin/env bash
# Build Oxpad-<version>-x86_64.AppImage from the release binary.
# Used both locally and by the GitHub release workflow.
set -euo pipefail
cd "$(dirname "$0")/.."

VERSION=$(grep -m1 '^version' Cargo.toml | cut -d'"' -f2)
APPDIR=target/appimage/Oxpad.AppDir
TOOL=target/appimage/appimagetool

rm -rf "$APPDIR"
mkdir -p "$APPDIR/usr/bin" "$APPDIR/usr/share/icons/hicolor/256x256/apps"

cp target/release/oxpad-gui "$APPDIR/usr/bin/"
cp assets/oxpad.desktop "$APPDIR/"
cp assets/oxpad-256.png "$APPDIR/usr/share/icons/hicolor/256x256/apps/oxpad.png"
cp assets/oxpad-256.png "$APPDIR/oxpad.png"
cp assets/oxpad-256.png "$APPDIR/.DirIcon"

cat > "$APPDIR/AppRun" << 'EOF'
#!/bin/sh
HERE=$(dirname "$(readlink -f "$0")")
exec "$HERE/usr/bin/oxpad-gui" "$@"
EOF
chmod +x "$APPDIR/AppRun"

if [ ! -x "$TOOL" ]; then
    curl -fsSL -o "$TOOL" \
        https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage
    chmod +x "$TOOL"
fi

# --appimage-extract-and-run works without FUSE (containers, CI)
ARCH=x86_64 "$TOOL" --appimage-extract-and-run "$APPDIR" "Oxpad-${VERSION}-x86_64.AppImage"
echo "Built Oxpad-${VERSION}-x86_64.AppImage"
