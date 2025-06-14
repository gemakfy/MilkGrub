#!/bin/bash

THEME_NAME="MilkGrub"
THEME_DIR="/boot/grub/themes/$THEME_NAME"
CURRENT_DIR=$(pwd)

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
cp -r "$CURRENT_DIR"/* "$THEME_DIR/"

# Update GRUB config
sed -i '/GRUB_THEME=/d' /etc/default/grub
sed -i '/GRUB_GFXMODE=/d' /etc/default/grub

echo 'GRUB_THEME="/boot/grub/themes/MilkGrub/theme.txt"' >> /etc/default/grub
echo "GRUB_GFXMODE=\"$GFXMODE\"" >> /etc/default/grub

# Update GRUB
if command -v update-grub &> /dev/null; then
    update-grub
else
    grub-mkconfig -o /boot/grub/grub.cfg
fi

echo "Theme installed successfully with $GFXMODE resolution!"
