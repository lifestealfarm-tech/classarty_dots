#!/bin/bash

set -e

echo "== Pywal Setup =="

echo "1) Install"
echo "2) Uninstall"
echo "3) Reinstall"
read -p "Choose an option [1-3]: " choice

install() {
    echo "== Installing pywal =="

    if command -v dnf >/dev/null; then
        sudo dnf install -y python3-pip
    elif command -v pacman >/dev/null; then
        sudo pacman -Sy --noconfirm python-pip
    elif command -v apt >/dev/null; then
        sudo apt update
        sudo apt install -y python3-pip
    else
        echo "Unsupported package manager"
        exit 1
    fi

    pip install --user pywal

    echo "== Setting up Ghostty =="

    CONFIG="$HOME/.config/ghostty/config"
    mkdir -p "$(dirname "$CONFIG")"

    sed -i '/^theme *=/d' "$CONFIG" 2>/dev/null || true

    cat >> "$CONFIG" << EOF
theme = $HOME/.cache/wal/ghostty.conf

window-decoration = false
background-opacity = 0.92
window-padding-x = 10
window-padding-y = 10
EOF

    echo "== Creating auto script =="

    mkdir -p "$HOME/.config"

    cat > "$HOME/.config/wal-auto.sh" << 'EOF'
#!/bin/bash

wal -R

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

    echo "== Initial run =="

    WALL=$(gsettings get org.gnome.desktop.background picture-uri | tr -d "'" | sed 's/file:\/\///')

    if [ -f "$WALL" ]; then
        wal -i "$WALL"
    fi

    echo "== Done =="
}

uninstall() {
    echo "== Removing setup =="

    rm -f "$HOME/.config/wal-auto.sh"
    rm -f "$HOME/.config/autostart/wal.desktop"

    CONFIG="$HOME/.config/ghostty/config"
    sed -i '/\.cache\/wal\/ghostty\.conf/d' "$CONFIG" 2>/dev/null || true

    echo "== Uninstalled =="
}

reinstall() {
    uninstall
    install
}

case "$choice" in
    1) install ;;
    2) uninstall ;;
    3) reinstall ;;
    *) echo "Invalid option" ;;
esac
