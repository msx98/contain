#!/bin/bash

set -e

install_or_update_conda() {
    local CONDA_DIR="$1"
    if [ ! -d "$CONDA_DIR" ]; then
        echo "Installing Miniconda..."
        wget -4 -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
        bash /tmp/miniconda.sh -b -p "$CONDA_DIR"
        rm /tmp/miniconda.sh
    else
        CONDA="$CONDA_DIR/bin/conda"
        echo "Accepting TOS"
        $CONDA tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
        $CONDA tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
        echo "Updating Miniconda..."
        $CONDA update
    fi
}

install_texlive() {
    local TEXLIVE_DIR="$1"
    TEXLIVE_INSTALLER_DIR="/home/user/tmp/install-tl"
    if [ ! -d "$TEXLIVE_DIR" ]; then
        echo "No TexLive installation found."
        mkdir -p ${TEXLIVE_INSTALLER_DIR}
        TAR_NAME="install-tl-unx.tar.gz"
        if [ ! -f "/home/user/tmp/${TAR_NAME}" ]; then
            echo "Downloading TexLive installer..."
            wget -4 -q https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz -O /home/user/tmp/${TAR_NAME}
            echo "Extracting TexLive installer..."
            tar -xzf /home/user/tmp/${TAR_NAME} -C ${TEXLIVE_INSTALLER_DIR} --strip-components=1
        fi
        cd ${TEXLIVE_INSTALLER_DIR}
        echo "Installing TexLive (this may take a while)..."
        perl install-tl --no-interaction --scheme=full --location=https://mirror.rabisu.com/mirrors/CTAN/systems/texlive/tlnet \
            --texdir=${TEXLIVE_DIR} \
            --texmfvar=${TEXLIVE_DIR}/texmf-var \
            --texmfconfig=${TEXLIVE_DIR}/texmf-config
        echo "Cleaning up TexLive installer..."
        rm -rf /home/user/tmp
        cat << 'EOF' > /home/user/.bashrc
# TexLive environment variables
export TEXLIVE_DIR="$HOME/texlive"
export MANPATH="\$TEXLIVE_DIR/texmf-dist/doc/man:\$MANPATH"
export INFOPATH="\$TEXLIVE_DIR/texmf-dist/doc/info:\$INFOPATH"
export PATH="\$TEXLIVE_DIR/bin/x86_64-linux:\$PATH"
EOF
        echo "TexLive installation complete."
    else
        echo "TexLive already installed."
    fi
}

setup_vscode() {
    if [ ! -d "/home/user/.config/Code" ]; then
        echo "Setting up VSCode configuration..."
        mkdir -p /home/user/.config/Code/User
        cat > /home/user/.config/Code/User/settings.json << 'EOF'
{
    "terminal.integrated.defaultProfile.linux": "bash",
    "terminal.integrated.profiles.linux": {
        "bash": {
            "path": "/bin/bash"
        }
    }
}
EOF
    else
        echo "VSCode configuration already exists."
    fi
}


#install_or_update_conda "/home/user/.miniconda3"
#install_texlive "/home/user/texlive"
setup_vscode

#conda create -n py312 python=3.12 pandas numpy matplotlib seaborn scikit-learn jupyterlab ipykernel torch tqdm transformers huggingface_hub -y
