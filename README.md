# ✨ Pixie SDDM

A clean, modern, and minimal SDDM theme inspired by Google Pixel UI and Material Design 3. 

<div align="center">
  <img src="screenshots/lock_screen.png" width="45%" alt="Lock Screen" />
  <img src="screenshots/login_screen.png" width="45%" alt="Login Screen" />
</div>

## 🌟 Features

- **Pixel Aesthetic:** Clean typography and a unique two-tone stacked clock.
- **Material Design 3:** Dark card UI with smooth animations and "Material You" inspired accents.
- **Interactive Dropdowns:** Sophisticated user and session selection menus with perfect vertical alignment.
- **Keyboard Navigation:** Full support for navigating menus with `Up`/`Down` arrows and confirming with `Enter`.
- **Intelligent Fallbacks:** 
  - Shows a beautiful "Initial" circle (e.g., "C" for Captain) if no user avatar is found.
  - Automatically handles session names and icons for a polished look.
- **Blur Effects:** Adaptive background blur that transitions smoothly when the login card is active.

## 🚀 Installation

The easiest way to install **Pixie** is by using the provided installation script:

```bash
git clone https://github.com/xCaptaiN09/pixie-sddm.git && cd pixie-sddm && sudo ./install.sh
```

### Manual Installation (Alternative)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/xCaptaiN09/pixie-sddm.git
   ```

2. **Move to SDDM themes directory:**
   ```bash
   sudo cp -r pixie-sddm /usr/share/sddm/themes/pixie
   ```

### 3. Test the theme (Optional)
You can test the theme without logging out using the `sddm-greeter`:
```bash
sddm-greeter --test-mode --theme /usr/share/sddm/themes/pixie
```

## 🛠 Configuration

To set **Pixie** as your active theme, edit your SDDM configuration file (usually `/etc/sddm.conf` or a file in `/etc/sddm.conf.d/`):

```ini
[Theme]
Current=pixie
```

## 🎨 Customization

You can easily customize the theme by editing the `theme.conf` file inside the theme directory:

- **Background:** Replace `assets/background.jpg` with your own wallpaper.
- **Colors:** Change `accentColor` or `backgroundColor` to match your setup.
- **Fonts:** The theme uses `Google Sans Flex` by default.

## 📦 Requirements

- **SDDM**
- **QtQuick Controls 2**
- **QtGraphicalEffects**
- **Nerd Fonts** (for icons)

## 🤝 Credits

- **Author:** [xCaptaiN09](https://github.com/xCaptaiN09)
- **Design Inspiration:** Google Pixel & Material You.
- **Font:** Google Sans Flex.

---
*Made with ❤️ for the Linux community.*
