export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools"
BUILD_TOOLS_DIR="$ANDROID_SDK_ROOT/build-tools"
LATEST_BUILD_TOOLS=$(ls -d "$BUILD_TOOLS_DIR"/*/ | sort -V | tail -n 1)
export PATH="$PATH:$LATEST_BUILD_TOOLS"
export ADB_SERVER_SOCKET=tcp:10.7.0.1:5037
code --wait --verbose --password-store=gnome-libsecret