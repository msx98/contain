exec /usr/lib64/trivalent/trivalent \
    --ozone-platform-hint=auto \
    --ozone-platform=wayland \
    --class=trivalent-$INSTANCE \
    "$@"
