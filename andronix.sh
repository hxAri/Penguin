#!/usr/bin/env bash

# Application version.
version=1.0.0

# Termux directory.
termux=/data/data/com.termux/

# Installation directory.
install=/data/data/com.termux/linux

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

# Prints available distro distributions.
function printsDistro()
{
	clear
	echo -e ""
	echo -e "    1. Alpine"
	echo -e "       Alpine Linux Development Team"
	echo -e "    2. Arch"
	echo -e "       Lavente Polyak and others"
	echo -e "    3. Debian"
	echo -e "       The Debian"
	echo -e "    4. Fedora"
	echo -e "       Fedora Project"
	echo -e "    5. Kali"
	echo -e "       Offensive Security"
	echo -e "    6. Manjaro"
	echo -e "       Manjaro GmbH & Co. KG"
	echo -e "    7. Parrot"
	echo -e "       Lorenzo \"Palinuro\" Faletra, Parrot Dev Team"
	echo -e "    8. Ubuntu"
	echo -e "       Canonical"
	echo -e "    9. Void"
	echo -e "       Void Linux Team"
	echo -e ""
}

# Readline, get input from user.
# readline [prefix] [label] [default]
function readline()
{
	if [[ $1 != "" ]]; then
		if [[ $2 != "" ]]; then
			if [[ $3 != "" ]]; then
				echo -e "\x20\x20stdin<$1<$2:=$3>>\x20\c"
			else
				echo -e "\x20\x20stdin<$1<$2>>\x20\c"
			fi
			read input
			if [[ $input == "" ]]; then
				input=$3
			fi
			eval "input${2^}=$input"
			echo -e "\x20\x20stdin<$2<$input>>"
		else
			echo -e "\x20\x20stdin<$1>\x20\c"
			read input
			echo -e "\x20\x20stdin<$1<$input>>"
		fi
	else
		echo -e "\x20\x20stdio<in>\x20\c"
		read input
		echo -e "\x20\x20stdio<in:=$input>"
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
					1|XFCE) inputDekstop=XFCE ;;
					2|LXQT) inputDekstop=LXQT ;;
					3|LXDE) inputDekstop=LXDE ;;
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
					1|awesome) inputWindow=Awesome ;;
					2|openbox) inputWindow=Openbox ;;
					3|i3) inputWindow=i3 ;;
					*)
						inputDekstop=
					;;
				esac
			done
		}
		
		while [[ $inputSelect == "" ]]; do
			readline $1 "select" "cli"
			inputSelect=${inputSelect,,}
			case $inputSelect in
				1|cli) ;;
				2|window)
					readInputWindowManager $1 $3
					window=$inputWindow
				;;
				3|dekstop)
					readInputDekstopEnv $1 $3
					dekstop=$inputDekstop
				;;
				*) inputSelect= ;;
			esac
			select=$inputSelect
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
		else
			readInputSelect $1
			select=$inputSelect
		fi
		if [[ $select == "window" ]]; then
			window=$inputWindow
		elif [[ $select == "dekstop" ]]; then
			dekstop=$inputDekstop
		fi
	fi
	
	# Handle action.
	case $action in
		cancel) main
		;;
		remove)
			case ${1,,} in
				alpine) ;;
				arch) ;;
				debian) ;;
				fedora) ;;
				kali) ;;
				manjaro) ;;
				parrot) ;;
				ubuntu) ;;
				void) ;;
				*)
					echo "$1: unsupported distro distribution"
					exit 1
				;;
			esac
		;;
		import)
			case ${1,,} in
				alpine) ;;
				arch) ;;
				debian) ;;
				fedora) ;;
				kali) ;;
				manjaro) ;;
				parrot) ;;
				ubuntu) ;;
				void) ;;
				*)
					echo "$1: unsupported distro distribution"
					exit 1
				;;
			esac
		;;
		install)
			case ${1,,} in
				alpine) ;;
				arch) ;;
				debian) ;;
				fedora) ;;
				kali) ;;
				manjaro) ;;
				parrot) ;;
				ubuntu) ;;
				void) ;;
				*)
					echo "$1: unsupported distro distribution"
					exit 1
				;;
			esac
		;;
	esac
}

# Handle Alpine Installation.
function alpine()
{
	# Prints informations.
	clear
	echo -e
	echo -e "  stdout<alpine>"
	echo -e "  $sint Distro Alpine"
	echo -e "  $sint Developer Alpine Linux Development Team"
	echo -e "  $sint Available Versions"
	echo -e "      [+]  v"
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
	echo -e ""
	echo -e "  stdin<alpine>"
	
	# Handle actions
	readInputAction "" "install"
}

# Handle Arch Installation.
function arch()
{
	echo 0
}

# Handle Debian Installation.
function debian()
{
	echo 0
}

# Handle Fedora Installation.
function fedora()
{
	echo 0
}

# Handle Kali Installation.
function kali()
{
	echo 0
}

# Handle Manjaro Installation.
function manjaro()
{
	echo 0
}

# Handle Parrot Installation.
function parrot()
{
	echo 0
}

# Handle Ubuntu Installation.
function ubuntu()
{
	# Default Ubuntu Mode for install.
	local select=cli
	
	# Default Import is always empty.
	# Because we don't know where source destination.
	local import=
	
	# Default Ubuntu Environment for install.
	local dekstop=XFCE
	
	# Default Ubuntu Window Manager for install.
	local window=Awesome
	
	# Default Ubuntu Version for install.
	local version=22.04
	
	# Available Ubuntu Versions for install.
	local ubuntuVersions=(
		"22.04"
		"20.04"
		"18.04"
	)
	
	# Prints Ubuntu informations.
	clear
	echo -e
	echo -e "  stdout<ubuntu>"
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
	echo -e ""
	echo -e "  stdin<ubuntu>"
	
	# Handle actions
	readInputAction "ubuntu" "install" $version
}

# Handle Void Installation.
function voidx()
{
	echo 0
}

function main()
{
	local input=
	printsDistro
	while true; do
		if [[ $input != "" ]]; then
			case $input in
				1|alpine) alpine; break ;;
				2|arch) arch; break ;;
				3|debian) debian; break ;;
				4|fedora) fedora; break ;;
				5|kali) kali; break ;;
				6|manjaro) manjaro; break ;;
				7|parrot) parrot; break ;;
				8|ubuntu) ubuntu; break ;;
				9|void) voidx; break ;;
				0|cancel) main; break ;;
				*)
					input=
					continue
				;;
			esac
		fi
		readline "distro"
	done
}

clear && main
echo
