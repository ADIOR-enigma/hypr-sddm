# ✨ Pixie SDDM

A clean, modern, and minimal SDDM theme inspired by Google Pixel UI and Material Design 3. 

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

## 🌟 Features

- **Pixel Aesthetic:** Clean typography and a unique two-tone stacked clock.
- **Material You Dynamic Colors:** Intelligent color extraction that samples your wallpaper for UI accents.
- **Smooth Transitions:** High-performance fade-in animations for all UI elements.
- **Material Design 3:** Dark card UI with smooth interactions and responsive dropdowns.
- **Keyboard Navigation:** Full support for navigating menus with arrows and `Enter`.
- **Blur Effects:** Adaptive background blur that transitions smoothly when the login card is active.

---

## 📦 Installation & Versioning

Pixie SDDM now supports both the latest **Qt6** engine and the legacy **Qt5** engine.

| System Type | Engine | Recommended Branch |
| :--- | :--- | :--- |
| **Bleeding Edge** (Fedora 40+, Arch, Nix, Cachy) | **Qt6** | `main` (Default) |
| **Stable/LTS** (Ubuntu 22.04/24.04, Debian 12) | **Qt5** | `qt5` |

### 1. Automatic Script (Recommended)
This script detects your system and installs the theme.
```bash
git clone https://github.com/xCaptaiN09/pixie-sddm.git
cd pixie-sddm

# OPTIONAL: If you are on an older Qt5 system (Ubuntu/Debian):
# git checkout qt5

sudo ./install.sh
```

### 2. Arch Linux (AUR)
The AUR package automatically tracks the latest version:
```bash
yay -S pixie-sddm-git
```

---

## 🛠 Prerequisites

Ensure you have the required modules for your version:

<details>
<summary><b>Qt6 (Default / Main Branch)</b></summary>

```bash
# Arch: sudo pacman -S qt6-declarative qt6-svg qt6-quickcontrols2
# Fedora: sudo dnf install qt6-qtdeclarative qt6-qtsvg qt6-qtquickcontrols2
```
</details>

<details>
<summary><b>Qt5 (Legacy / qt5 Branch)</b></summary>

```bash
# Ubuntu: sudo apt install qml-module-qtgraphicaleffects qml-module-qtquick-controls2
# Arch: sudo pacman -S qt5-graphicaleffects qt5-quickcontrols2
```
</details>

### 3. NixOS (Declarative)
NixOS users should add the following to their `configuration.nix`. 

**Note:** This snippet uses the **Qt6** version. For **Qt5**, change `rev = "main"` to `rev = "qt5"` and use `pkgs.libsForQt5` packages.

```nix
{ pkgs, ... }: {
  services.displayManager.sddm = {
    enable = true;
    theme = "pixie";
  };

  environment.systemPackages = [
    (pkgs.stdenv.mkDerivation {
      name = "pixie-sddm";
      src = pkgs.fetchFromGitHub {
        owner = "xCaptaiN09";
        repo = "pixie-sddm";
        rev = "main"; # Change to "qt5" for legacy systems
        sha256 = "sha256-0000000000000000000000000000000000000000000=";
      };
      installPhase = ''
        mkdir -p $out/share/sddm/themes/pixie
        cp -r * $out/share/sddm/themes/pixie/
      '';
    })
    pkgs.kdePackages.qtdeclarative
    pkgs.kdePackages.qtquickcontrols2
    pkgs.kdePackages.qtsvg
    pkgs.kdePackages.qteffects
  ];
}
```

After editing, apply the configuration by running:
```bash
sudo nixos-rebuild switch
```

> [!TIP]
> **First-time build:** Nix will likely report a "hash mismatch" error because of the dummy `sha256` value. Simply copy the **actual hash** from the error message, update it in your config, and run the rebuild command again.

### 4. Manual
1. Clone the repository:
   ```bash
   git clone https://github.com/xCaptaiN09/pixie-sddm.git
   ```
2. Copy the folder to SDDM themes directory:
   ```bash
   sudo cp -r pixie-sddm /usr/share/sddm/themes/pixie
   ```
3. Set the theme in `/etc/sddm.conf`:
   ```ini
   [Theme]
   Current=pixie
   ```

---

## 🛠 Configuration & Testing

### Preview Without Logging Out
Run this command to preview the theme:
```bash
sddm-greeter --test-mode --theme /usr/share/sddm/themes/pixie
```

---

## 🎨 Customization

Edit the `theme.conf` file inside the theme directory:
- **Wallpaper:** Replace `assets/background.jpg` with your own image.
- **Avatar:** Put your profile picture in `assets/avatar.jpg`.
- **Colors:** Adjust `accentColor` for manual overrides if needed.

## 🤝 Credits

- **Author:** [xCaptaiN09](https://github.com/xCaptaiN09)
- **Design:** Inspired by Google Pixel and MD3.
- **Font:** Google Sans Flex (included).

---
*Made with ❤️ for the Linux community.*
