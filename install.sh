#!/bin/bash
set -e

THEME_NAME="hyprsddm"
THEME_DIR="/usr/share/sddm/themes/${THEME_NAME}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SDDM_CONF_DIR="/etc/sddm.conf.d"
AUTO_YES=false

for arg in "$@"; do
    case "$arg" in
        -y|--yes) AUTO_YES=true; shift ;;
    esac
done

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}==>${NC} Starting Hypr SDDM Installation..."

# 1. ROOT CHECK (early, before wasting time)
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error:${NC} Please run as root (use sudo)."
    exit 1
fi

# 2. NIXOS CHECK
if [ -f /etc/NIXOS ]; then
    echo -e "${RED}Warning:${NC} NixOS detected. Please use the declarative method in your config."
    exit 1
fi

# 3. SYSTEM DETECTION
if command -v sddm-greeter-qt6 >/dev/null 2>&1; then
    SYSTEM_QT="6"
    GREETER_CMD="sddm-greeter-qt6"
    TARGET_BRANCH="main"
    echo -e "${BLUE}==>${NC} System detected: ${GREEN}Qt6 (Modern)${NC}"
else
    SYSTEM_QT="5"
    GREETER_CMD="sddm-greeter"
    TARGET_BRANCH="qt5"
    echo -e "${BLUE}==>${NC} System detected: ${YELLOW}Qt5 (Legacy)${NC}"
fi

# 4. DEPENDENCY CHECK
echo -e "${BLUE}==>${NC} Checking dependencies..."
MISSING=()

if [ "$SYSTEM_QT" = "6" ]; then
    # Check for qt6-virtualkeyboard (package name varies by distro)
    if ! find /usr/lib /usr/lib64 2>/dev/null | grep -q "qtvirtualkeyboard"; then
        MISSING+=("qt6-virtualkeyboard")
    fi
fi

if [ ${#MISSING[@]} -gt 0 ]; then
    echo -e "${YELLOW}Warning:${NC} Possibly missing packages: ${MISSING[*]}"
    echo -e "         Virtual keyboard may not work without them."
    echo -e "         Install via your package manager and re-run if needed."
fi

# 5. AUTO-VERSION SWITCH (Git only)
if [ -d .git ]; then
    CURRENT_BRANCH=$(git branch --show-current)
    if [ "$CURRENT_BRANCH" != "$TARGET_BRANCH" ]; then
        echo -e "${YELLOW}==>${NC} Switching to ${GREEN}${TARGET_BRANCH}${NC} branch..."
        git checkout "$TARGET_BRANCH"
        exec "$SCRIPT_DIR/install.sh" "$@"
    fi
fi

# 6. INSTALL FILES
if [ -d "${THEME_DIR}" ]; then
    echo -e "${BLUE}==>${NC} Removing old installation..."
    rm -rf "${THEME_DIR}"
fi

echo -e "${BLUE}==>${NC} Installing Hypr SDDM (Qt${SYSTEM_QT}) to ${THEME_DIR}..."
mkdir -p "${THEME_DIR}"
cp -r \
    "$SCRIPT_DIR/assets" \
    "$SCRIPT_DIR/components" \
    "$SCRIPT_DIR/Main.qml" \
    "$SCRIPT_DIR/metadata.desktop" \
    "$SCRIPT_DIR/theme.conf" \
    "$SCRIPT_DIR/LICENSE" \
    "${THEME_DIR}/"
chmod -R 755 "${THEME_DIR}"
echo -e "${GREEN}✓${NC} Theme files installed."

# 7. APPLY THEME + SDDM CONFIG
echo ""
if [ "$AUTO_YES" = true ]; then
    echo -e "${BLUE}==>${NC} Auto-applying theme (non-interactive)..."
    APPLY_THEME=true
else
    read -p "Apply Hypr as your active SDDM theme now? (y/N) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] && APPLY_THEME=true || APPLY_THEME=false
fi

if [ "$APPLY_THEME" = true ]; then
    mkdir -p "${SDDM_CONF_DIR}"

    # Theme config
    cat > "${SDDM_CONF_DIR}/theme.conf" <<EOF
[Theme]
Current=${THEME_NAME}
EOF

    # Virtual keyboard config (separate file so it doesn't conflict with
    # anything the user has in their own sddm.conf)
    if [ "$SYSTEM_QT" = "6" ]; then
        cat > "${SDDM_CONF_DIR}/virtualkeyboard.conf" <<EOF
[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=${THEME_DIR}/components/,QT_IM_MODULE=qtvirtualkeyboard,QT_VIRTUALKEYBOARD_STYLE=pixie
EOF
        echo -e "${GREEN}✓${NC} Virtual keyboard configured."
    fi

    echo -e "${GREEN}✓${NC} Theme applied."
else
    echo -e "To apply manually, add to your SDDM config:"
    echo -e "  ${GREEN}[Theme]${NC}"
    echo -e "  ${GREEN}Current=${THEME_NAME}${NC}"
    if [ "$SYSTEM_QT" = "6" ]; then
        echo -e ""
        echo -e "  ${GREEN}[General]${NC}"
        echo -e "  ${GREEN}InputMethod=qtvirtualkeyboard${NC}"
        echo -e "  ${GREEN}GreeterEnvironment=QML2_IMPORT_PATH=${THEME_DIR}/components/,QT_IM_MODULE=qtvirtualkeyboard,QT_VIRTUALKEYBOARD_STYLE=pixie${NC}"
    fi
fi

echo ""
echo -e "${BLUE}==>${NC} Test with:"
echo -e "    ${GREEN}${GREETER_CMD} --test-mode --theme ${THEME_DIR}${NC}"
echo ""
echo -e "${GREEN}Done!${NC} Reboot to see Hypr SDDM on your login screen."
