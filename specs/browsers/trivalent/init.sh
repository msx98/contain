exec /usr/lib64/trivalent/trivalent \
    --ozone-platform-hint=auto \
    --ozone-platform=wayland \
    --password-store=gnome-keyring \
    --class=trivalent-$INSTANCE \
    "$@"
