#!/bin/bash

RootPasswd="sydelink"
RealName="Mastermind"
RealUserName="mastermind"
UserPasswd="123456"

function pause(){
   read -p "$*"
}

SydeSystemSetup() {   # SydeLink Setup

    echo ">Starting SydeSystemSetup..."
    echo $RootPasswd
    echo $RealName
    echo $RealUserName
    echo $UserPasswd

    echo "-Set root password"
	echo root:$RootPasswd | chpasswd

    echo "-Adding user"
    adduser --quiet --disabled-password --shell /bin/bash --home /home/"$RealUserName" --gecos "$RealName" "$RealUserName"
    (echo $Password;echo $Password;) | passwd "$RealUserName" >/dev/null 2>&1
    
    echo "-Adding user to groups"
    for additionalgroup in sudo netdev audio video disk tty users games dialout plugdev input bluetooth systemd-journal ssh adm dip pulse-access; do
        usermod -aG ${additionalgroup} ${RealUserName} 2>/dev/null
    done
    pause 'Press [Enter] key to continue...'

    echo "Setting Locals"
    # setting detected locales only for user
    if [[ -n $LOCALES ]]; then
        echo "export LC_ALL=$LOCALES" >> /home/$RealUserName/.bashrc
        echo "export LANG=$LOCALES" >> /home/$RealUserName/.bashrc
        echo "export LANGUAGE=$LOCALES" >> /home/$RealUserName/.bashrc
        echo "export LC_ALL=$LOCALES" >> /home/$RealUserName/.xsessionrc
        echo "export LANG=$LOCALES" >> /home/$RealUserName/.xsessionrc
        echo "export LANGUAGE=$LOCALES" >> /home/$RealUserName/.xsessionrc
    fi
    pause 'Press [Enter] key to continue...'

    echo "Xenial Fix"
    # fix for gksu in Xenial
    touch /home/$RealUserName/.Xauthority
    chown $RealUserName:$RealUserName /home/$RealUserName/.Xauthority
    RealName="$(awk -F":" "/^${RealUserName}:/ {print \$5}" </etc/passwd | cut -d',' -f1)"
    [ -z "$RealName" ] && RealName=$RealUserName
    echo -e "\nDear \e[0;92m${RealName}\x1B[0m, your account \e[0;92m${RealUserName}\x1B[0m has been created and is sudo enabled."
    echo -e "Please use this account for your daily work from now on.\n"
    pause 'Press [Enter] key to continue...'

    echo "Remove .not_logged_in_yet"
    rm -f /root/.not_logged_in_yet
    pause 'Press [Enter] key to continue...'

    echo "Setup profile sync"
    # set up profile sync daemon on desktop systems
    which psd >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${RealUserName} ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper" >> /etc/sudoers
        touch /home/${RealUserName}/.activate_psd
        chown $RealUserName:$RealUserName /home/${RealUserName}/.activate_psd
    fi
    pause 'Press [Enter] key to continue...'

    echo "Script finished"
    pause 'Press [Enter] key to continue...'
} # sydeUserSetup