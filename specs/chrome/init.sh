dbus-run-session -- google-chrome-stable \
--ozone-platform-hint=auto \
--ozone-platform=wayland \
--user-data-dir=$HOME/.config/google-chrome \
--class=Google-chrome-$INSTANCE \
"$@"