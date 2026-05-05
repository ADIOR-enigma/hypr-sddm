# 🎸 Hypr SDDM

A clean, modern, and minimal SDDM theme inspired by hyprlock and styled with a sleek, contemporary Linux aesthetic.

<div align="center">
  <table>
    <tr>
      <td><img src="https://github.com/user-attachments/assets/69149e29-9040-4ea7-acdd-38e11ae2a3d6" width="480"/></td>
      <td><img src="https://github.com/user-attachments/assets/da825aae-4aca-4f26-892a-243b8cafa7ac" width="480"/></td>
    </tr>
    <tr>
      <td><img src="https://github.com/user-attachments/assets/d6772a7f-c34a-48d8-88c9-bf250017afcb" width="480"/></td>
      <td><img src="https://github.com/user-attachments/assets/9c1c8dc3-c982-404f-a39d-64eba73fb1e8" width="480"/></td>
    </tr>
  </table>
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

# Arch:
```bash
 sudo pacman -S qt6-declarative qt6-svg qt6-quickcontrols2
```
# Fedora:
```bash
 sudo dnf install qt6-qtdeclarative qt6-qtsvg qt6-qtquickcontrols2
```
</details>


## 📦 2. Installation

Hypr SDDM automatically detects your system and installs the correct version.

### Method A: Automatic Script (Recommended)
This script intelligently detects your Qt version and handles everything:
```bash
git clone https://github.com/ADIOR-enigma/hypr-sddm.git
cd hypr-sddm
sudo ./install.sh
```

### Method B: Manual
1. Copy the folder to SDDM themes directory:
   `sudo cp -r hypr-sddm /usr/share/sddm/themes/hyprsddm`
2. Set the theme in `/etc/sddm.conf`:
   ```ini
   [Theme]
   Current=hyprsddm
   ```


## 🛠 Configuration & Testing

### Preview Without Logging Out
Run this command to preview the theme safely:
```bash
cd hypr-sddm
QT_IM_MODULE=qtvirtualkeyboard QML2_IMPORT_PATH=./components/ sddm-greeter-qt6 --test-mode --theme .
```

### Customization
Edit `theme.conf` or replace assets in `assets/`:
- **Wallpaper:** Replace `assets/background.jpg`.
- **Avatar:** Replace `assets/avatar.jpg`.

You can also update ur Wallpaper with matugen, for that u need to add the install script to sudoers.

## 🤝 Credits

- **Pixie-SDDM:** [xCaptaiN09](https://github.com/xCaptaiN09/pixie-sddm)
- **Font:** Google Sans Flex (included).

*Made with ❤️ for the Linux community.*
hehe
