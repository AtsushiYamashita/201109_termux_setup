#!/bin/bash

echo "> INIT setup.sh"
echo ">> set variable values"
readonly FOLDER_TERMUX=.termux
readonly PROPERTY_FILE_TERMUX=.termux/termux.properties
readonly BASH_PROFILE=$HOME/.bash_profile
echo ">> done"
echo ">> termux storage setup"
termux-setup-storage
echo ">> done"
pushd ~/
echo ""

echo "> apps install"
yes | apt update
yes | apt upgrade
yes | apt install coreutils
yes | apt install vim tree curl git
echo ">> install deno"
yes | curl -fsSL https://deno.land/x/install/install.sh | sh
DENO_PROFILE=$(cat <<-END
    export DENO_INSTALL="$HOME/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"
END
)
echo $DENO_PROFILE >> $BASH_PROFILE
echo ">> deno installed"
# yes | apt install fish 
# yes | fish | curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
echo ""

echo "> .termux property update"
mkdir $FOLDER_TERMUX
TERMUX_KEYS=$(cat <<-END
    extra-keys = [ \
    ['ESC','|','/','HOME','UP','END','PGUP','DEL'], \
    ['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN','BKSP'] \
    ]
END
)
echo $TERMUX_KEYS > $PROPERTY_FILE_TERMUX
echo ""

echo "> DONE setup.sh"
popd
termux-reload-settings
echo ""

# echo "> P.S."
# echo ">> fish shell"
# echo " You can configuration of fish  "
# echo " Change shell to fish"
# echo " $ fish_config"
# echo "> "
# echo ""


