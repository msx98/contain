exec /usr/bin/chromium-browser \
    --ozone-platform-hint=auto \
    --ozone-platform=wayland \
    --password-store=gnome-keyring \
    --class=contain--$INSTANCE \
    "$@"
