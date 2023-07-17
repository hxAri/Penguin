#!/usr/bin/env bash

# Andronix
# Shell utility to install Linux on Termux.

# ...

# Application name.
appname=Andronix

# Application author.
author="Ari Setiawan (hxAri)"
author_email="hxari@proton.me"

# Application version.
version=1.0.0

# Application repository.
github=https://github.com/hxAri/$appname
issues=https://github.com/hxAri/$appname/issues

# Termux directory.
termux=/data/data/com.termux/

# Installation directory.
install=/data/data/com.termux/linux

# Rootfs Images stored.
images=$install/.rootfs

# Termux architecture.
architect=$(dpkg --print-architecture)

# Square bracket with interpunch.
sint="[·]"

# Available distros.
distros=(
	"alpine"
	"arch"
	"debian"
	"fedora"
	"kali"
	"manjaro"
	"parrot"
	"ubuntu"
	"void"
)

# Array joins.
function joins()
{
	echo $(IFS="|" ; echo "$*" )
}

function puts()
{
	echo -e "\e[1;38;5;112m${appname,,}\e[1;38;5;214m: \e[1;38;5;229m$*\e[0m"
}

function stdin() {
	echo -e "$(stdio stdin $@)\x20\e[1;38;5;229m\c"
}

function stdio()
{
	prints=
	if [[ $1 != "" ]]; then
		prints="\e[1;32m$1"
		if [[ $2 != "" ]]; then
			prints+="\e[1;38;5;70m<"
			prints+="\e[1;38;5;112m$2"
			prints+="\e[1;38;5;70m>"
			if [[ $3 != "" ]]; then
				prints="\e[1;32m$1"
				prints+="\e[1;38;5;70m<"
				prints+="\e[1;38;5;112m$2"
				prints+="\e[1;38;5;70m<"
				prints+="\e[1;38;5;190m$3"
				if [[ $4 != "" ]]; then
					prints+="\e[1;38;5;214m:"
					prints+="\e[1;38;5;70m="
					prints+="\e[1;38;5;120m$4"
				fi
				prints+="\e[1;38;5;70m>>"
			fi
		fi
		echo -e "\x20\x20$prints\e[1;38;5;255m"
	fi
}

# Readline, get input from user.
# readline [prefix] [label] [default]
function readline()
{
	stdin $@
	if [[ $1 != "" ]]; then
		if [[ $2 != "" ]]; then
			read input
			if [[ $input == "" ]]; then
				input=$3
			fi
			eval "input${2^}=$input"
			echo -e "\x20\x20\c"
			echo -e "\e[1;32mstdin\c"
			echo -e "\e[1;38;5;70m<\c"
			echo -e "\e[1;38;5;112m$2\c"
			echo -e "\e[1;38;5;70m<\c"
			echo -e "\e[1;38;5;120m$input\c"
			echo -e "\e[1;38;5;70m>>"
		else
			read input
			echo -e "\x20\x20\c"
			echo -e "\e[1;32mstdin\c"
			echo -e "\e[1;38;5;70m<\c"
			echo -e "\e[1;38;5;112m$1\c"
			echo -e "\e[1;38;5;70m<\c"
			echo -e "\e[1;38;5;120m$input\c"
			echo -e "\e[1;38;5;70m>>\c"
		fi
	else
		read input
		echo -e "\x20\x20\c"
		echo -e "\e[1;32mstdio\c"
		echo -e "\e[1;38;5;70m<"
		echo -e "\e[1;38;5;112min\c"
		echo -e "\e[1;38;5;214m:\c"
		echo -e "\e[1;38;5;70m=\c"
		echo -e "\e[1;38;5;20m$input\c"
		echo -e "\e[1;38;5;70m>"
	fi
}

# Handle readlind input Action.
# readInputAction [distro] [action] [version]
function readInputAction()
{
	# Handle readline input selection mode.
	# readInputSelect [distro]
	function readInputSelect()
	{
		# Handle readline input dekstop environment.
		# readInputDekstopEnv [distro]
		function readInputDekstopEnv()
		{
			while [[ $inputDekstop == "" ]]; do
				readline $1 "dekstop" "XFCE"
				inputDekstop=${inputDekstop^^}
				case $inputDekstop in
					1|XFCE)
						inputDekstop=xfce
					;;
					2|LXQT)
						inputDekstop=lxqt
						case ${1,,} in
							alpine|arch)
								inputDekstop=
							;;
						esac
					;;
					3|LXDE)
						inputDekstop=lxde
						case ${1,,} in
							alpine)
								inputDekstop=
							;;
						esac
					;;
					*)
						inputDekstop=
					;;
				esac
			done
		}
		
		# Handle readline input window manager.
		# readInputWindowManager [distro]
		function readInputWindowManager()
		{
			while [[ $inputWindow == "" ]]; do
				readline $1 "window" "Awesome"
				inputWindow=${inputWindow,,}
				case $inputWindow in
					1|awesome) inputWindow=awesome ;;
					2|openbox) inputWindow=openbox ;;
					3|i3) inputWindow=i3 ;;
					*) inputDekstop= ;;
				esac
			done
		}
		
		while [[ $inputSelect == "" ]]; do
			readline $1 "select" "cli"
			inputSelect=${inputSelect,,}
			case $inputSelect in
				1|cli) inputSelect=cli ;;
				2|window)
					inputSelect=window
					if [[ ${1,,} != "alpine" ]]; then
						readInputWindowManager $1 $3
						window=$inputWindow
					else
						inputSelect=
					fi
				;;
				3|dekstop)
					inputSelect=dekstop
					readInputDekstopEnv $1 $3
					dekstop=$inputDekstop
				;;
				*) inputSelect= ;;
			esac
			select=${inputSelect,,}
		done
	}
	
	# Handle readline input version.
	# readInputVersion [distro] [default]
	function readInputVersion()
	{
		if [[ ${1,,} == "ubuntu" ]]; then
			while [[ $inputVersion == "" ]]; do
				readline $1 "version" $2
				case $inputVersion in
					1|22|22.04) inputVersion=22.04 ;;
					2|20|20.04) inputVersion=20.04 ;;
					3|18|18.04) inputVersion=18.04 ;;
					*)
						inputVersion=
						continue
					;;
				esac
				version=$inputVersion
			done
		fi
	}
	
	stdio stdin $1
	while [[ $inputAction == "" ]]; do
		readline $1 "action" $2
		case ${inputAction,,} in
			1|install) action=install ;;
			2|import) action=import ;;
			3|remove) action=remove ;;
			4|cancel|main) action=cancel ;;
			*)
				inputAction=
				continue
			;;
		esac
	done
	
	# If action is not cancel.
	if [[ $action != "cancel" ]]; then
		if [[ ${1,,} == "ubuntu" ]]; then
			readInputVersion $1 $3
			version=$inputVersion
		fi
		if [[ $action == "import" ]]; then
			readInputImport
			import=$inputImport
		fi
		readInputSelect $1
		select=$inputSelect
		if [[ $select == "window" ]]; then
			window=$inputWindow
		elif [[ $select == "dekstop" ]]; then
			dekstop=$inputDekstop
		fi
	fi
}

# Handle Alpine Actions.
function alpine()
{
	# Prints informations.
	clear
	echo -e
	echo -e "$(stdio stdout alpine)"
	echo -e "  $sint Distro Alpine"
	echo -e "  $sint Developer Alpine Linux Development Team"
	echo -e "  $sint Available Versions"
	echo -e "      [+] Alpine v3.10"
	echo -e "  $sint Available Install"
	echo -e "      [+] CLI Only"
	echo -e "      [+] Desktop Environment"
	echo -e "          [+] XFCE"
	echo -e "  $sint Actions"
	echo -e "      [1] Install"
	echo -e "      [2] Import"
	echo -e "      [3] Remove"
	echo -e "      [4] Cancel"
	echo -e
	
	# Handle input action for alpine.
	readInputAction "alpine" "install"
	case $action in
		cancel) main
		;;
		remove)
		;;
		import)
		;;
		install)
		;;
	esac
}

# Handle Arch Actions.
function arch()
{
	# Prints informations.
	clear
	echo -e
	echo -e "$(stdio stdout arch)"
	echo -e "  $sint Distro Arch Linux"
	echo -e "  $sint Developer Lavente Polyak and others"
	echo -e "  $sint Available Versions"
	echo -e "      [+] Arch Linux v2021.07.01"
	echo -e "  $sint Available Install"
	echo -e "      [+] CLI Only"
	echo -e "      [+] Window Manager"
	echo -e "          [+] Awesome"
	echo -e "          [+] Openbox"
	echo -e "          [+] i3"
	echo -e "      [+] Desktop Environment"
	echo -e "          [+] XFCE"
	echo -e "          [+] LXDE"
	echo -e "  $sint Actions"
	echo -e "      [1] Install"
	echo -e "      [2] Import"
	echo -e "      [3] Remove"
	echo -e "      [4] Cancel"
	echo -e
	
	# Handle input action for .
	readInputAction "arch" "install"
	case $action in
		cancel) main
		;;
		remove)
		;;
		import)
		;;
		install)
		;;
	esac
}

# Handle Debian Actions.
function debian()
{
	# Prints informations.
	clear
	echo -e
	echo -e "$(stdio stdout debian)"
	echo -e "  $sint Distro Debian"
	echo -e "  $sint Developer The Debian"
	echo -e "  $sint Available Versions"
	echo -e "      [+] Debian v10.00"
	echo -e "  $sint Available Install"
	echo -e "      [+] CLI Only"
	echo -e "      [+] Window Manager"
	echo -e "          [+] Awesome"
	echo -e "          [+] Openbox"
	echo -e "          [+] i3"
	echo -e "      [+] Desktop Environment"
	echo -e "          [+] XFCE"
	echo -e "          [+] LXQT"
	echo -e "          [+] LXDE"
	echo -e "  $sint Actions"
	echo -e "      [1] Install"
	echo -e "      [2] Import"
	echo -e "      [3] Remove"
	echo -e "      [4] Cancel"
	echo -e
	
	# Handle input action for .
	readInputAction "debian" "install"
	case $action in
		cancel) main
		;;
		remove)
		;;
		import)
		;;
		install)
		;;
	esac
}

# Handle Fedora Actions.
function fedora()
{
	# Prints informations.
	clear
	echo -e
	echo -e "$(stdio stdout fedora)"
	echo -e "  $sint Distro Fedora"
	echo -e "  $sint Developer Fedora Project"
	echo -e "  $sint Available Versions"
	echo -e "      [+] Fedora v33"
	echo -e "  $sint Available Install"
	echo -e "      [+] CLI Only"
	echo -e "      [+] Window Manager"
	echo -e "          [+] Awesome"
	echo -e "          [+] Openbox"
	echo -e "          [+] i3"
	echo -e "      [+] Desktop Environment"
	echo -e "          [+] XFCE"
	echo -e "          [+] LXQT"
	echo -e "          [+] LXDE"
	echo -e "  $sint Actions"
	echo -e "      [1] Install"
	echo -e "      [2] Import"
	echo -e "      [3] Remove"
	echo -e "      [4] Cancel"
	echo -e
	
	# Handle input action for .
	readInputAction "fedora" "install"
	case $action in
		cancel) main
		;;
		remove)
		;;
		import)
		;;
		install)
		;;
	esac
}

# Handle Kali Actions.
function kali()
{
	# Prints informations.
	clear
	echo -e
	echo -e "$(stdio stdout kali)"
	echo -e "  $sint Distro Kali Linux"
	echo -e "  $sint Developer Offensive Security"
	echo -e "  $sint Available Versions"
	echo -e "      [+] Kali Linux v21.2"
	echo -e "  $sint Available Install"
	echo -e "      [+] CLI Only"
	echo -e "      [+] Window Manager"
	echo -e "          [+] Awesome"
	echo -e "          [+] Openbox"
	echo -e "          [+] i3"
	echo -e "      [+] Desktop Environment"
	echo -e "          [+] XFCE"
	echo -e "          [+] LXQT"
	echo -e "          [+] LXDE"
	echo -e "  $sint Actions"
	echo -e "      [1] Install"
	echo -e "      [2] Import"
	echo -e "      [3] Remove"
	echo -e "      [4] Cancel"
	echo -e
	
	# Handle input action for .
	readInputAction "kali" "install"
	case $action in
		cancel) main
		;;
		remove)
		;;
		import)
		;;
		install)
		;;
	esac
}

# Handle Manjaro Actions.
function manjaro()
{
	# Prints informations.
	clear
	echo -e
	echo -e "$(stdio stdout manjaro)"
	echo -e "  $sint Distro Manjaro"
	echo -e "  $sint Developer Manjaro GmbH & Co. KG"
	echo -e "  $sint Available Versions"
	echo -e "      [+] Manjaro v21"
	echo -e "  $sint Available Install"
	echo -e "      [+] CLI Only"
	echo -e "      [+] Window Manager"
	echo -e "          [+] Awesome"
	echo -e "          [+] Openbox"
	echo -e "          [+] i3"
	echo -e "      [+] Desktop Environment"
	echo -e "          [+] XFCE"
	echo -e "          [+] LXQT"
	echo -e "          [+] LXDE"
	echo -e "  $sint Actions"
	echo -e "      [1] Install"
	echo -e "      [2] Import"
	echo -e "      [3] Remove"
	echo -e "      [4] Cancel"
	echo -e
	
	# Handle input action for .
	readInputAction "manjaro" "install"
	case $action in
		cancel) main
		;;
		remove)
		;;
		import)
		;;
		install)
		;;
	esac
}

# Handle Parrot Actions.
function parrot()
{
	# This functionality does not implemented at this time.
	echo 0
}

# Handle Ubuntu Actions.
function ubuntu()
{
	# Default Ubuntu Mode for install.
	local select=cli
	
	# Default Import is always empty.
	# Because we don't know where source destination.
	local import=
	
	# Default Ubuntu Directory.
	local target=$install/ubuntu
	local folder=ubuntu-fs
	
	# Default Ubuntu Executable.
	local starts=ubuntu-start
	local binary=ubuntu
	
	# Default Ubuntu Environment for install.
	local dekstop=XFCE
	
	# Default Ubuntu Window Manager for install.
	local window=Awesome
	
	# Default Ubuntu Version for install.
	local version=22.04
	
	# Handle Ubuntu Import.
	function ubuntuImport()
	{
		echo
	}
	
	# Handle Ubuntu Install.
	function ubuntuInstall()
	{
		# Ubuntu Install Source Destination.
		local source=$target/$version
		
		# Ubuntu RootFS name.
		local rootfs=ubuntu-rootfs.$version.tar.gz
		if [[ $version == 18.04 ]]; then
			rootfs=ubuntu-rootfs.$version.tar.xz
		fi
		
		# Resolve Source Destination.
		case $select in
			cli) source=$source/cli ;;
			window) source=$source/window/$window ;;
			dekstop) source=$source/dekstop/$dekstop ;;
			*)
				puts "ubuntu: $select: unknown selection mode"
				exit 1
			;;
		esac
		
		# Check if folder is does not exists.
		if [[ ! -d $source ]]; then
			mkdir -p $source
		fi
		
		# Check if file system does not exists.
		if [[ ! -d $source/$folder ]]; then
			if [[ ! -f $images/$rootfs ]]; then
				case $version in
					22.04)
						case ${architect,,} in
							aarch64) arcurl="arm64" ;;
							*)
								puts "ubuntu: $architect: $version: unsupported architecture"
								exit 1
							;;
						esac
						arcurl="https://github.com/AndronixApp/AndronixOrigin/raw/master/Rootfs/Ubuntu22/jammy-${arcurl}.tar.gz"
					;;
					20.04)
						case ${architect,,} in
							aarch64) arcurl="arm64" ;;
							arm) arcurl="armhf" ;;
							amd64) arcurl="amd64" ;;
							x86_64) arcurl="amd64" ;;
							*)
								puts "ubuntu: $architect: $version: unsupported architecture"
								exit 1
							;;
						esac
						arcurl="https://github.com/AndronixApp/AndronixOrigin/raw/master/Rootfs/Ubuntu20/focal-${arcurl}.tar.gz"
					;;
					18.04)
						case ${architect,,} in
							aarch64) arcurl="arm64" ;;
							arm) arcurl="armhf" ;;
							amd64) arcurl="amd64" ;;
							x86_64) arcurl="amd64" ;;
							i*86) arcurl="i386" ;;
							x86) arcurl="i386" ;;
							*)
								puts "ubuntu: $architect: $version: unsupported architecture"
								exit 1
							;;
						esac
						arcurl="https://github.com/Techriz/AndronixOrigin/blob/master/Rootfs/Ubuntu/${arcurl}/ubuntu-rootfs-${arcurl}.tar.xz?raw=true"
					;;
					*)
						puts "ubuntu: $version: unsupported version"
						exit 1
					;;
				esac
				wget $arcurl -O $images/$rootfs
			fi
			#mkdir -p $source/$folder
			#proot --link2symlink tar -xf $images/$rootfs -C $source/$folder
		fi
		
		# Avoid access denied.
		#chmod 755 $source/$folder/proc
		
		mkdir -p $source/ubuntu-binds
		mkdir -p $source/$folder/proc/fakethings
		
		echo $target
		echo $source
		echo $source/$rootfs
		echo $arcurl
	}
	
	# Prints Ubuntu informations.
	clear
	echo -e
	echo -e "$(stdio stdout ubuntu)"
	echo -e "  $sint Distro Ubuntu"
	echo -e "  $sint Developer Canonical"
	echo -e "  $sint Available Versions"
	echo -e "      [+] Ubuntu v22.04"
	echo -e "      [+] Ubuntu v20.04"
	echo -e "      [+] Ubuntu v18.04"
	echo -e "  $sint Available Install"
	echo -e "      [+] CLI Only"
	echo -e "      [+] Window Manager"
	echo -e "          [+] Awesome"
	echo -e "          [+] Openbox"
	echo -e "          [+] i3"
	echo -e "      [+] Desktop Environment"
	echo -e "          [+] XFCE"
	echo -e "          [+] LXQT"
	echo -e "          [+] LXDE"
	echo -e "  $sint Actions"
	echo -e "      [1] Install"
	echo -e "      [2] Import"
	echo -e "      [3] Remove"
	echo -e "      [4] Cancel"
	echo -e
	
	# Get input action for ubuntu.
	readInputAction "ubuntu" "install" $version
	case $action in
		cancel) main
		;;
		remove)
		;;
		import)
		;;
		install) ubuntuInstall ;;
	esac
}

# Handle Void Actions.
function voidx()
{
	# Prints informations.
	clear
	echo -e
	echo -e "$(stdio stdout void)"
	echo -e "  $sint Distro Void"
	echo -e "  $sint Developer Void Linux Team"
	echo -e "  $sint Available Versions"
	echo -e "      [+] Void Rolling Release"
	echo -e "  $sint Available Install"
	echo -e "      [+] CLI Only"
	echo -e "      [+] Window Manager"
	echo -e "          [+] Awesome"
	echo -e "          [+] Openbox"
	echo -e "          [+] i3"
	echo -e "      [+] Desktop Environment"
	echo -e "          [+] XFCE"
	echo -e "          [+] LXQT"
	echo -e "          [+] LXDE"
	echo -e "  $sint Actions"
	echo -e "      [1] Install"
	echo -e "      [2] Import"
	echo -e "      [3] Remove"
	echo -e "      [4] Cancel"
	echo -e
	
	# Handle input action for void.
	readInputAction "void" "install"
	case $action in
		cancel) main
		;;
		remove)
		;;
		import)
		;;
		install)
		;;
	esac
}

# Main Program.
function main()
{
	clear
	local inputDistro=
	
	echo -e
	echo -e "$(stdio stdout main)"
	echo -e "  $sint $appname v$version"
	echo -e "  [i] Author $author"
	echo -e "  [i] E-Mail $author_email"
	echo -e "  [s] Github $github"
	echo -e "  [!] Issues $issues"
	echo -e "  [+] Distro"
	echo -e "      [1] Alpine"
	echo -e "      [2] Arch Linux"
	echo -e "      [3] Debian"
	echo -e "      [4] Fedora"
	echo -e "      [5] Kali Linux"
	echo -e "      [6] Manjaro"
	echo -e "      [7] Parrot OS"
	echo -e "      [8] Ubuntu"
	echo -e "      [9] Void"
	echo -e ""
	echo -e "\x20\x20\c"
	echo -e "\e[1;32mstdin\c"
	echo -e "\e[1;38;5;70m<\c"
	echo -e "\e[1;38;5;112mmain\c"
	echo -e "\e[1;38;5;70m>\c"
	echo -e "\x20\e[1;38;5;229m"
	
	while [[ $inputDistro == "" ]]; do
		readline "main" "distro"
		case ${inputDistro,,} in
			1|alpine) alpine; break ;;
			2|arch) arch; break ;;
			3|debian) debian; break ;;
			4|fedora) fedora; break ;;
			5|kali) kali; break ;;
			6|manjaro) manjaro; break ;;
			7|parrot) parrot; break ;;
			8|ubuntu) ubuntu; break ;;
			9|void) voidx; break ;;
			0|exit)
				echo && exit 0
			;;
			*)
				inputDistro=
			;;
		esac
	done
}

# Trying make directory for save downloaded rootfs.
mkdir -p $images

# Starting main program.
main
