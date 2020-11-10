#!/bin/bash

echo "> INIT setup.sh"
echo ">> make folders"
mkdir bin
mkdir log
echo ">>"
source variables.sh
echo ">> log to $LOGGER"
LOGGER=~/log/$(date '+%y%m%d_%H%M%S').log
echo "Start log" >> $LOGGER
echo ">>"
echo ">> termux storage setup"
yes | termux-setup-storage >> $LOGGER
echo ">> done"
echo ">"

echo "> variable updated check"
IS_UPDATED=${#SSH_KEY_PASS}
echo $IS_UPDATED
if [ $IS_UPDATED -gt 0 ]; then
  echo "---> Checked ssh key pass is updated."
else
  echo "Must update ssh key configs(name,pass,port)"
  exit 1
fi
echo ">"

echo "> apps install"
echo ">> on pkg installing"
yes | pkg update  >> $LOGGER
yes | pkg install wget tmux  >> $LOGGER
yes | pkg install openssh  >> $LOGGER
yes | pkg install termux-api  >> $LOGGER
echo ">>"
echo ">> on apt installing"
yes | apt update  >> $LOGGER
yes | apt upgrade >> $LOGGER
yes | apt install coreutils nodejs >> $LOGGER
yes | apt install vim tree curl git >> $LOGGER
pushd ~
echo ">>"
echo ">> install deno"
yes | curl -fsSL https://deno.land/x/install/install.sh | sh  >> $LOGGER
DENO_PROFILE=$(cat <<-END
    export DENO_INSTALL="$HOME/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"
END
)
echo $DENO_PROFILE >> $BASH_PROFILE
source $BASH_PROFILE
echo ">>"
echo ">> install node-red"
npm i -g --unsafe-perm node-red  >> $LOGGER
echo ">>"
echo ">"


echo "> .termux property update"
mkdir $FOLDER_TERMUX
cat > $PROPERTY_FILE_TERMUX <<-END
    extra-keys = [ \
    ['ESC','|','/','HOME','UP','END','PGUP','DEL'], \
    ['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN','BKSP'] \
    ]
END
echo ">"


echo "> setup ssh"
yes | ssh-keygen -t rsa -f $SSH_KEY_FILE -N $SSH_KEY_PASS
yes | chmod 600 $SSH_KEY_FILE
echo ">"


echo "> bashrc update"
echo "" >> $BASHRC
echo "SSH_SERVER_PORT=$SSH_SERVER_PORT" >> $BASHRC
cat >> $BASHRC  <<-END
    # run deamons
    sshd -p $SSH_SERVER_PORT
    # alias
    alias ll="ls -laF"
    alias hi="history"
    alias ipof="ifconfig | grep 192.168| sed -e 's/^[[:space:]]*//' | cut -d' ' -f2"
    # tips print
    echo "# clipbord"
    echo " copy to android"
    echo " => 'termux-clipboard-set hoge'"
    echo " read from android"
    echo " => 'termux-clipboard-get'"
    echo "# file open"
    echo " open on android"
    echo " => 'termux-open https://google.co.jp'"
    echo "# ssh"
    echo " set client key"
    echo "=> 1. Send client public key to android clipbord"
    echo "=> 2. 'termux-clipboard-get >> ~/.ssh/authorized_keys'"
    echo ""
    # print own data 
    echo "> print own data"
    echo "uname -r : $(uname -r)"
    echo "ipof: $(ipof)"
    echo ""
END

source $BASHRC
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


