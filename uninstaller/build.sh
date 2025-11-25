#!/usr/bin/env bash

# JoyCast Uninstaller Build Script
# Builds, signs, and notarizes Uninstall JoyCast.driver.app

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Paths
SOURCE="$SCRIPT_DIR/Uninstall JoyCast Driver.applescript"
OUTPUT="$SCRIPT_DIR/Uninstall JoyCast Driver.app"
OUTPUT_ZIP="$SCRIPT_DIR/Uninstall JoyCast Driver.zip"
ICON="$PROJECT_ROOT/assets/joycast.icns"
CREDENTIALS_FILE="$PROJECT_ROOT/configs/credentials.env"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
GRAY='\033[0;90m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BOLD}${GREEN}=== Building JoyCast Uninstaller ===${NC}"

# Check source exists
if [[ ! -f "$SOURCE" ]]; then
    echo -e "${RED}Error: Source not found: $SOURCE${NC}"
    exit 1
fi

# Check icon exists
if [[ ! -f "$ICON" ]]; then
    echo -e "${RED}Error: Icon not found: $ICON${NC}"
    exit 1
fi

# Load credentials
if [[ -f "$CREDENTIALS_FILE" ]]; then
    echo -e "${YELLOW}Loading credentials...${NC}"
    source "$CREDENTIALS_FILE"
else
    echo -e "${RED}Error: $CREDENTIALS_FILE not found${NC}"
    exit 1
fi

# Validate signing credentials
if [[ -z "${APPLE_TEAM_ID:-}" || -z "${DEVELOPER_NAME:-}" ]]; then
    echo -e "${RED}Error: Missing APPLE_TEAM_ID or DEVELOPER_NAME in credentials${NC}"
    exit 1
fi

CODE_SIGN_CERT="Developer ID Application: $DEVELOPER_NAME ($APPLE_TEAM_ID)"

# Check notarization credentials
ENABLE_NOTARIZATION=false
if [[ -n "${APPLE_ID:-}" && -n "${APPLE_APP_PASSWORD:-}" ]]; then
    ENABLE_NOTARIZATION=true
    echo -e "${GREEN}✓ Notarization credentials found${NC}"
else
    echo -e "${YELLOW}⚠ Notarization skipped (no APPLE_ID/APPLE_APP_PASSWORD)${NC}"
fi

# Remove old build
if [[ -d "$OUTPUT" ]]; then
    echo -e "${YELLOW}Removing old build...${NC}"
    rm -rf "$OUTPUT"
fi

# Compile AppleScript to .app
echo -e "${YELLOW}Compiling AppleScript...${NC}"
osacompile -o "$OUTPUT" "$SOURCE"

# Replace icon
echo -e "${YELLOW}Setting icon...${NC}"
cp "$ICON" "$OUTPUT/Contents/Resources/applet.icns"

# Remove Assets.car (so applet.icns is used)
rm -f "$OUTPUT/Contents/Resources/Assets.car"

# Sign the app
echo -e "${YELLOW}Signing with: $CODE_SIGN_CERT${NC}"
codesign --force --deep --options runtime --sign "$CODE_SIGN_CERT" "$OUTPUT"

# Verify signature
echo -e "${YELLOW}Verifying signature...${NC}"
codesign --verify --verbose "$OUTPUT"
echo -e "${GREEN}✓ Signature valid${NC}"

# Notarize
if [[ "$ENABLE_NOTARIZATION" = true ]]; then
    echo -e "${YELLOW}Creating ZIP for notarization...${NC}"
    ZIP_PATH="/tmp/joycast_uninstaller_$$.zip"
    ditto -c -k --keepParent "$OUTPUT" "$ZIP_PATH"

    echo -e "${YELLOW}Submitting for notarization...${NC}"
    xcrun notarytool submit "$ZIP_PATH" \
        --apple-id "$APPLE_ID" \
        --password "$APPLE_APP_PASSWORD" \
        --team-id "$APPLE_TEAM_ID" \
        --wait

    echo -e "${YELLOW}Stapling notarization...${NC}"
    xcrun stapler staple "$OUTPUT"

    # Cleanup
    rm -f "$ZIP_PATH"

    echo -e "${GREEN}✓ Notarization complete${NC}"
fi

# Touch to refresh Finder
touch "$OUTPUT"

# Create distribution ZIP
echo -e "${YELLOW}Creating distribution ZIP...${NC}"
rm -f "$OUTPUT_ZIP"
ditto -c -k --keepParent "$OUTPUT" "$OUTPUT_ZIP"
echo -e "${GREEN}✓ ZIP created${NC}"

echo -e "\n${BOLD}${GREEN}=== Build Complete ===${NC}"
echo -e "Output:"
echo -e "  📦 $OUTPUT"
echo -e "  📦 $OUTPUT_ZIP"

# Show signature info
echo -e "\n${GRAY}Signature info:${NC}"
codesign -dv "$OUTPUT" 2>&1 | grep -E "Authority|TeamIdentifier" | head -5
