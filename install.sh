#!/bin/bash

# Pixie SDDM Theme Installer
# Author: xCaptaiN09

set -e

THEME_NAME="pixie"
THEME_DIR="/usr/share/sddm/themes/${THEME_NAME}"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}==>${NC} Installing ${GREEN}${THEME_NAME}${NC} SDDM theme..."

# Check for root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error:${NC} Please run as root (use sudo)."
    exit 1
fi

# Check for sddm
if ! command -v sddm >/dev/null 2>&1; then
    echo -e "${RED}Warning:${NC} SDDM is not detected. Please ensure it is installed."
fi

# Create theme directory
if [ -d "${THEME_DIR}" ]; then
    echo -e "${BLUE}==>${NC} Existing theme found. Cleaning up..."
    rm -rf "${THEME_DIR}"
fi

echo -e "${BLUE}==>${NC} Creating directory: ${THEME_DIR}"
mkdir -p "${THEME_DIR}"

# Copy files
echo -e "${BLUE}==>${NC} Copying files..."
cp -r assets components Main.qml metadata.desktop theme.conf LICENSE "${THEME_DIR}/"

# Set permissions
echo -e "${BLUE}==>${NC} Setting permissions..."
chmod -R 755 "${THEME_DIR}"

echo -e "${GREEN}Done!${NC} Theme installed to ${THEME_DIR}"
echo -e ""

# Interactive configuration
read -p "Would you like to set Pixie as your active SDDM theme? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}==>${NC} Applying theme configuration..."
    mkdir -p /etc/sddm.conf.d
    echo -e "[Theme]\nCurrent=pixie" | tee /etc/sddm.conf.d/theme.conf > /dev/null
    echo -e "${GREEN}Theme applied successfully!${NC}"
else
    echo -e "To apply the theme manually:"
    echo -e "1. Edit ${BLUE}/etc/sddm.conf${NC} or ${BLUE}/etc/sddm.conf.d/default.conf${NC}"
    echo -e "2. Set ${GREEN}Current=pixie${NC} under the ${GREEN}[Theme]${NC} section."
fi

echo -e ""
echo -e "You can test the theme without logging out using:"
echo -e "${BLUE}sddm-greeter --test-mode --theme ${THEME_DIR}${NC}"
