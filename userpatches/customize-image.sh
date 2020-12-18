#!/bin/bash

# arguments: $RELEASE $LINUXFAMILY $BOARD $BUILD_DESKTOP
#
# This is the image customization script

# NOTE: It is copied to /tmp directory inside the image
# and executed there inside chroot environment
# so don't reference any files that are not already installed

# NOTE: If you want to transfer files between chroot and host
# userpatches/overlay directory on host is bind-mounted to /tmp/overlay in chroot
# The sd card's root path is accessible via $SDCARD variable.

RELEASE=$1
LINUXFAMILY=$2
BOARD=$3
BUILD_DESKTOP=$4

Main() {
	case $RELEASE in
		stretch)
			# your code here
			# InstallOpenMediaVault # uncomment to get an OMV 4 image
			;;
		buster)
			sydePacks
			setGitUser
			FirstBoot
			;;
		bullseye)
			# your code here
			;;
		bionic)
			# your code here
			;;
		focal)
			# your code here
			;;
	esac
} # Main


FirstBoot() {
	echo "SydeVFX - First Boot"
	# Set root password


	# Create new user for desktop
	

} # FirstBoot


setGitUser() {
	echo "SydeVFX - Setting git user as: Blaque with a Q"
	# Configure git
	git config --global user.name "Blaque with a Q"
	git config --global user.email sydelink@gmail.com
} # setGitUser


sydePacks() {
	echo "SydeVFX - Installing Packages for Development"

	#Install GParted
	echo "Installing GParted"
	apt install -y gparted

	#Install Terminator Terminal
	echo "Installing Terminator Terminal"
	apt install -y terminator

	#Install git
	echo "Installing Git, please congre git later..."
	apt install -y git

	#Install Visual Studio Code
	echo "Download VS Code .deb package"
	wget -q -O VSCode.deb https://aka.ms/linux-arm64-deb

	echo "Installing VS Code"
	apt install -y ./VSCode.deb

	#Install AppImageLauncher
	echo "Download AppImageLauncher .deb package"
	wget -q -O AppImageLauncher.deb https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher_2.2.0-travis995.0f91801.bionic_arm64.deb

	echo "Installing AppImageLauncher"
	apt install -y ./AppImageLauncher.deb

	#Install Etcher
	echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
	apt update && apt install balena-etcher-electron


} # InstallPacks

Main "$@"
