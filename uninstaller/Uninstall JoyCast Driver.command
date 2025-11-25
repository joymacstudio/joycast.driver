#!/usr/bin/env bash

# JoyCast Driver Uninstaller
# Double-click this file to uninstall JoyCast driver from your Mac

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

clear
echo -e "${BOLD}╔════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║     JoyCast Driver Uninstaller         ║${NC}"
echo -e "${BOLD}╚════════════════════════════════════════╝${NC}"
echo

# Check macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo -e "${RED}Error: This script only works on macOS${NC}"
    echo
    read -n 1 -s -r -p "Press any key to close..."
    exit 1
fi

DRIVER_PATH="/Library/Audio/Plug-Ins/HAL/JoyCast.driver"

# Check if driver exists
if [[ ! -d "$DRIVER_PATH" ]]; then
    echo -e "${YELLOW}JoyCast driver is not installed.${NC}"
    echo
    read -n 1 -s -r -p "Press any key to close..."
    exit 0
fi

echo -e "Found JoyCast driver at:"
echo -e "${YELLOW}$DRIVER_PATH${NC}"
echo

# Confirm uninstallation
read -p "Do you want to uninstall JoyCast driver? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Uninstallation cancelled.${NC}"
    echo
    read -n 1 -s -r -p "Press any key to close..."
    exit 0
fi

echo

# Check if running as root, if not - request sudo
if [[ $EUID -ne 0 ]]; then
    echo -e "${YELLOW}Administrator privileges required.${NC}"
    echo "Please enter your password:"
    echo
    sudo -v || {
        echo -e "${RED}Failed to get administrator privileges.${NC}"
        echo
        read -n 1 -s -r -p "Press any key to close..."
        exit 1
    }
fi

# Remove the driver
echo -e "${YELLOW}Removing JoyCast driver...${NC}"
sudo rm -rf "$DRIVER_PATH"

# Restart CoreAudio
echo -e "${YELLOW}Restarting CoreAudio...${NC}"
sudo killall -9 coreaudiod 2>/dev/null || true

# Wait for CoreAudio to restart
sleep 2

# Verify removal
if [[ -d "$DRIVER_PATH" ]]; then
    echo -e "${RED}Error: Failed to remove driver${NC}"
    echo
    read -n 1 -s -r -p "Press any key to close..."
    exit 1
fi

echo
echo -e "${GREEN}✓ JoyCast driver successfully removed!${NC}"
echo -e "${GREEN}✓ CoreAudio restarted${NC}"

# Check system audio
if system_profiler SPAudioDataType 2>/dev/null | grep -q "JoyCast"; then
    echo
    echo -e "${YELLOW}Note: You may need to restart your Mac for${NC}"
    echo -e "${YELLOW}changes to fully take effect.${NC}"
fi

echo
echo -e "${GREEN}${BOLD}Uninstallation complete!${NC}"
echo
read -n 1 -s -r -p "Press any key to close..."
