#!/bin/bash

set -e

echo "== Installing pywal =="

# Detect package manager
if command -v dnf >/dev/null; then
    sudo dnf install -y python3-pip
elif command -v pacman >/dev/null; then
    sudo pacman -Sy --noconfirm python-pip
elif command -v apt >/dev/null; then
    sudo apt update
    sudo apt install -y python3-pip
else
    echo "No supported package manager found"
    exit 1
fi

pip install --user pywal

echo "== Setting up Ghostty =="

GHOSTTY_CONFIG="$HOME/.config/ghostty/config"
mkdir -p "$(dirname "$GHOSTTY_CONFIG")"

# Add theme line if not exists
if ! grep -q "theme = $HOME/.cache/wal/ghostty.conf" "$GHOSTTY_CONFIG" 2>/dev/null; then
    echo "theme = $HOME/.cache/wal/ghostty.conf" >> "$GHOSTTY_CONFIG"
fi

echo "== Creating auto script =="

mkdir -p "$HOME/.config"

cat > "$HOME/.config/wal-auto.sh" << 'EOF'
#!/bin/bash

gsettings monitor org.gnome.desktop.background picture-uri | while read -r _; do
    wal -i "$(gsettings get org.gnome.desktop.background picture-uri | tr -d "'" | sed 's/file:\/\///')"
done
EOF

chmod +x "$HOME/.config/wal-auto.sh"

echo "== Enabling autostart =="

mkdir -p "$HOME/.config/autostart"

cat > "$HOME/.config/autostart/wal.desktop" << EOF
[Desktop Entry]
Type=Application
Exec=$HOME/.config/wal-auto.sh
Name=Pywal Auto
X-GNOME-Autostart-enabled=true
EOF

echo "== Running initial theme =="

WALL=$(gsettings get org.gnome.desktop.background picture-uri | tr -d "'" | sed 's/file:\/\///')

if [ -f "$WALL" ]; then
    wal -i "$WALL"
else
    echo "No wallpaper found, skipping initial wal"
fi

echo "== Done =="
echo "Change wallpaper → colors update automatically"
