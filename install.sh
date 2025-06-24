#!/bin/bash

THEME_NAME="MilkGrub"
THEME_DIR="/boot/grub/themes/$THEME_NAME"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if we're in the right directory
if [ ! -f "$SCRIPT_DIR/theme.txt" ] || [ ! -d "$SCRIPT_DIR/icons" ]; then
    if [ -d "$SCRIPT_DIR/MilkGrub" ] && [ -f "$SCRIPT_DIR/MilkGrub/theme.txt" ]; then
        SCRIPT_DIR="$SCRIPT_DIR/MilkGrub"
    else
        echo "Error: Please run this script from inside the MilkGrub theme directory" >&2
        echo "or place the script in the parent folder of MilkGrub directory" >&2
        exit 1
    fi
fi

# Check root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: Run as root" >&2
    exit 1
fi

# Resolution selection
echo "Select display resolution:"
echo "1) Full HD (1920x1080)"
echo "2) 2K (2560x1440)"
echo "3) 4K (3840x2160)"
read -p "Enter choice [1-3]: " res_choice

case $res_choice in
    1) GFXMODE="1920x1080x32" ;;
    2) GFXMODE="2560x1440x32" ;;
    3) GFXMODE="3840x2160x32" ;;
esac

# Install theme
echo "Installing GRUB theme with $GFXMODE resolution..."
mkdir -p "$THEME_DIR"
cp -r "$SCRIPT_DIR"/* "$THEME_DIR/"

# Update GRUB config
sed -i '/GRUB_THEME=/d' /etc/default/grub
sed -i '/GRUB_GFXMODE=/d' /etc/default/grub

echo 'GRUB_THEME="/boot/grub/themes/MilkGrub/theme.txt"' >> /etc/default/grub
echo "GRUB_GFXMODE=\"$GFXMODE\"" >> /etc/default/grub

# Update GRUB
if command -v update-grub &> /dev/null; then
    update-grub
elif command -v grub-mkconfig &> /dev/null; then
    grub-mkconfig -o /boot/grub/grub.cfg
else
    echo "Error: Could not find update-grub or grub-mkconfig" >&2
    exit 1
fi

echo "Theme installed successfully with $GFXMODE resolution!"
