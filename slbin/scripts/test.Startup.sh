#!/bin/bash

sHOSTNAME="sydelink-dev"
sROOTPWD="sydelink"
sNAME="Mastermind"
sUSERNAME="mastermind"
sUSERPWD="123456"

function pause(){
   read -p "$*"
}

SydeSystemSetup() {   # SydeLink Setup

    echo ">SydeLink Setup"
    echo $sHOSTNAME
    echo $sROOTPWD
    echo $sNAME
    echo $sUSERNAME
    echo $sUSERPWD
    echo $sUSERGROUPS
    echo ""

    echo "-Set root password"
	echo root:$sROOTPWD | chpasswd

    echo "-Adding user"
    adduser --quiet --disabled-password --shell /bin/bash --home /home/"$sUSERNAME" --gecos "$sNAME" "$sUSERNAME"
    (echo $sUSERPWD;echo $sUSERPWD;) | passwd "$sUSERNAME" >/dev/null 2>&1
    
    echo "-Adding user to groups"
    for additionalgroup in sudo netdev audio video disk tty users games dialout plugdev input bluetooth systemd-journal ssh adm dip pulse-access; do
        usermod -aG ${additionalgroup} ${sUSERNAME} 2>/dev/null
    done
    pause 'Press [Enter] key to continue...'

    echo "Setting Locals"
    # setting detected locales only for user
    if [[ -n $LOCALES ]]; then
        echo "export LC_ALL=$LOCALES" >> /home/$sUSERNAME/.bashrc
        echo "export LANG=$LOCALES" >> /home/$sUSERNAME/.bashrc
        echo "export LANGUAGE=$LOCALES" >> /home/$sUSERNAME/.bashrc
        echo "export LC_ALL=$LOCALES" >> /home/$sUSERNAME/.xsessionrc
        echo "export LANG=$LOCALES" >> /home/$sUSERNAME/.xsessionrc
        echo "export LANGUAGE=$LOCALES" >> /home/$sUSERNAME/.xsessionrc
    fi
    pause 'Press [Enter] key to continue...'

    echo "Xenial Fix"
    # fix for gksu in Xenial
    touch /home/$sUSERNAME/.Xauthority
    chown $sUSERNAME:$sUSERNAME /home/$sUSERNAME/.Xauthority
    RealName="$(awk -F":" "/^${sUSERNAME}:/ {print \$5}" </etc/passwd | cut -d',' -f1)"
    [ -z "$sNAME" ] && RealName=$sUSERNAME
    echo -e "\nDear \e[0;92m${sNAME}\x1B[0m, your account \e[0;92m${sUSERNAME}\x1B[0m has been created and is sudo enabled."
    echo -e "Please use this account for your daily work from now on.\n"
    pause 'Press [Enter] key to continue...'

    echo "Remove .not_logged_in_yet"
    rm -f /root/.not_logged_in_yet
    pause 'Press [Enter] key to continue...'

    echo "Setup profile sync"
    # set up profile sync daemon on desktop systems
    which psd >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${sUSERNAME} ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper" >> /etc/sudoers
        touch /home/${sUSERNAME}/.activate_psd
        chown $sUSERNAME:$sUSERNAME /home/${sUSERNAME}/.activate_psd
    fi
    pause 'Press [Enter] key to continue...'

    echo "Script finished"
    pause 'Press [Enter] key to continue...'
} # sydeUserSetup