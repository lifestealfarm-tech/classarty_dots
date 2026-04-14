
==================================================

GNOME EXTENSIONS SETUP

    clean setup | simple install | consistent results

==================================================

EXTENSIONS

    [+] ArcMenu
    [+] Bluetooth Battery Meter
    [+] Blur My Shell
    [+] Caffeine
    [+] Color Picker
    [+] Dash to Dock
    [+] Just Perfection
    [+] Open Bar
    [+] Rounded Window Corners Reborn
    [+] Space Bar
    [+] Status Area Horizontal Spacing
    [+] Tiling Shell
    [+] User Themes
    [+] Vitals

==================================================

INSTALL

    Use GNOME Extensions app
        → search names exactly as listed
        → install each extension
        → tested on 2026-04-15

    Optional: install Ghostty for matching terminal setup

==================================================

BACKUP / RESTORE

    dconf dump /org/gnome/shell/extensions/ > extensions.conf
    dconf load /org/gnome/shell/extensions/ < extensions.conf

==================================================

GHOSTTY

    Apply:
        open terminal
        right click → configuration
        paste config

==================================================

INSTALL SCRIPT (PYWAL ONLY)

    Installs and sets up pywal

    chmod +x pywal_install.sh
    ./pywal_install.sh

==================================================

USAGE

    - change wallpaper in GNOME
    - colors update automatically via pywal

==================================================

NOTES

    - restart session if needed
    - GNOME only for auto mode
    - manual:
        wal -i image.jpg

==================================================

LICENSE

    MIT (configs only)

==================================================

