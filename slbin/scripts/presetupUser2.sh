#!/bin/bash


sydeUserSetup() {   # SydeLink Setup

    # Set root password
	echo root:sydeLink | chpasswd
	
    RealName="SydeVFX"
	RealUserName="sydevfx"
    Password="123456"
    
    adduser --quiet --disabled-password --shell /bin/bash --home /home/"$RealUserName" --gecos "$RealName" "$RealUserName"
    (echo $Password;echo $Password;) | passwd "$RealUserName" >/dev/null 2>&1
    for additionalgroup in sudo netdev audio video disk tty users games dialout plugdev input bluetooth systemd-journal ssh; do
        usermod -aG ${additionalgroup} ${RealUserName} 2>/dev/null
    done

    # setting detected locales only for user
    if [[ -n $LOCALES ]]; then
        echo "export LC_ALL=$LOCALES" >> /home/$RealUserName/.bashrc
        echo "export LANG=$LOCALES" >> /home/$RealUserName/.bashrc
        echo "export LANGUAGE=$LOCALES" >> /home/$RealUserName/.bashrc
        echo "export LC_ALL=$LOCALES" >> /home/$RealUserName/.xsessionrc
        echo "export LANG=$LOCALES" >> /home/$RealUserName/.xsessionrc
        echo "export LANGUAGE=$LOCALES" >> /home/$RealUserName/.xsessionrc
    fi

    # fix for gksu in Xenial
    touch /home/$RealUserName/.Xauthority
    chown $RealUserName:$RealUserName /home/$RealUserName/.Xauthority
    RealName="$(awk -F":" "/^${RealUserName}:/ {print \$5}" </etc/passwd | cut -d',' -f1)"
    [ -z "$RealName" ] && RealName=$RealUserName
    echo -e "\nDear \e[0;92m${RealName}\x1B[0m, your account \e[0;92m${RealUserName}\x1B[0m has been created and is sudo enabled."
    echo -e "Please use this account for your daily work from now on.\n"
    rm -f /root/.not_logged_in_yet

    # set up profile sync daemon on desktop systems
    which psd >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${RealUserName} ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper" >> /etc/sudoers
        touch /home/${RealUserName}/.activate_psd
        chown $RealUserName:$RealUserName /home/${RealUserName}/.activate_psd
    fi

} # sydeUserSetup