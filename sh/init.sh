#!/usr/bin

# =========================================================================
# フロントエンドのアプリケーション開発に必要なものをインストールします.
# [USAGE] sh init.sh
# =========================================================================

# =========================================================================

cd `dirname ${0}`
source ./utils.sh

# =========================================================================

usage_exit() {
    echo "Usage: $0 [-d node_module install directory]" 1>&2
    exit 1
}

DIR=../
UPDATE=0

while getopts u OPT
do
    case $OPT in
        u)  UPDATE=1
			;;
        \?) usage_exit
            ;;
    esac
done

# =========================================================================
# install.

# --- If gem command is not available. Exit script.
if ! type gem > /dev/null 2>&1; then
	cecho $red "init.sh is required gem. But not found."
	exit 1
fi

# --- If npm command is not available. Exit script.
if ! type npm > /dev/null 2>&1; then
	cecho $red "init.sh is required npm. But not found."
	exit 1
fi

# =========================================================================
# install.

source ./install_sass.sh
source ./install_node_modules.sh

# =========================================================================
# install packages.

cd $DIR

cecho $green "\nInstall node_modules from package.json"
pwd
sleep 1

npm install

# =========================================================================

echo "\ninit.sh completed"