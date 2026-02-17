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

# Create theme directory
echo -e "${BLUE}==>${NC} Creating directory: ${THEME_DIR}"
mkdir -p "${THEME_DIR}"

# Copy files
echo -e "${BLUE}==>${NC} Copying files..."
cp -r assets components Main.qml metadata.desktop theme.conf LICENSE "${THEME_DIR}/"

# Set permissions
echo -e "${BLUE}==>${NC} Setting permissions..."
chmod -R 755 "${THEME_DIR}"

echo -e "${GREEN}Done!${NC}"
echo -e ""
echo -e "To apply the theme, you can:"
echo -e "1. Edit ${BLUE}/etc/sddm.conf${NC} or ${BLUE}/etc/sddm.conf.d/default.conf${NC}"
echo -e "2. Set ${GREEN}Current=pixie${NC} under the ${GREEN}[Theme]${NC} section."
echo -e ""
echo -e "Or run this command to set it automatically:"
echo -e "${BLUE}sudo mkdir -p /etc/sddm.conf.d && echo -e \"[Theme]\nCurrent=pixie\" | sudo tee /etc/sddm.conf.d/theme.conf${NC}"
echo -e ""
echo -e "You can test the theme without logging out using:"
echo -e "${BLUE}sddm-greeter --test-mode --theme ${THEME_DIR}${NC}"
