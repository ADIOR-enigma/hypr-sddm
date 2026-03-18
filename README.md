# ✨ Hypr SDDM

A clean, modern, and minimal SDDM theme inspired by hyprlock and styled with a sleek, contemporary Linux aesthetic. Supports only the latest Qt6 engine.

<div align="center">
  <img src="screenshots/lock_screen.png" width="45%" alt="Lock Screen" />
  <img src="screenshots/login_screen.png" width="45%" alt="Login Screen" />
</div>

<div align="center">
  <img src="screenshots/lock_screen_2.png" width="22%" />
  <img src="screenshots/login_screen_2.png" width="22%" />
  <img src="screenshots/lock_screen_3.png" width="22%" />
  <img src="screenshots/login_screen_3.png" width="22%" />
</div>

<div align="center">
  <img src="screenshots/lock_screen_4.png" width="22%" />
  <img src="screenshots/login_screen_4.png" width="22%" />
  <img src="screenshots/lock_screen_5.png" width="22%" />
  <img src="screenshots/login_screen_5.png" width="22%" />
</div>

## 🌟 Features

- **Hypr-Inspired Aesthetic:** Clean layout, elegant typography, and a modern lockscreen-inspired design.
- **Dynamic Accent Colors:** Intelligent color extraction that samples your wallpaper for UI accents.
- **Smooth Blur Effects:** High-performance Gaussian blur.
- **Universal Circle Avatar:** A polished, anti-aliased circular profile mask that works reliably across systems.
- **Minimal Modern UI:** Dark translucent cards, subtle depth, and smooth interactions.
- **Keyboard Navigation:** Full support for navigating menus with arrows and `Enter`.


## 🛠 1. Prerequisites (Essential)

Before installing, make sure the required modules for your system are present to avoid rendering issues or a black screen:

<details open>

```bash
# Arch: sudo pacman -S qt6-declarative qt6-svg qt6-quickcontrols2
```
```bash
# Fedora: sudo dnf install qt6-qtdeclarative qt6-qtsvg qt6-qtquickcontrols2
```
</details>


## 📦 2. Installation

Hypr SDDM automatically detects your system and installs the correct version.

### Method A: Automatic Script (Recommended)
This script intelligently detects your Qt version and handles everything:
```bash
git clone https://github.com/xCaptaiN09/pixie-sddm.git
cd pixie-sddm
sudo ./install.sh
```

### Method B: Manual
1. Copy the folder to SDDM themes directory:
   `sudo cp -r pixie-sddm /usr/share/sddm/themes/pixie`
2. Set the theme in `/etc/sddm.conf`:
   ```ini
   [Theme]
   Current=pixie
   ```


## 🛠 Configuration & Testing

### Preview Without Logging Out
Run this command to preview the theme safely:
```bash
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/pixie
```

### Customization
Edit `theme.conf` or replace assets in `assets/`:
- **Wallpaper:** Replace `assets/background.jpg`.
- **Avatar:** Replace `assets/avatar.jpg`.

## 🤝 Credits

- **Pixie-SDDM:** [xCaptaiN09](https://github.com/xCaptaiN09/pixie-sddm)
- **Font:** Google Sans Flex (included).

*Made with ❤️ for the Linux community.*
