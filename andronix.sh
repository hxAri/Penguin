#!/usr/bin/env bash

# Andronix
# Shell utility to install Linux on Termux.
# Please report any issues or bugs you find while using this tool.

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

# Allows remove image after install for some space.
remove=1

# Termux architecture.
architect=$(dpkg --print-architecture)

# Square bracket with interpunch.
sint="[·]"

# Array joins.
function joins() {
	echo $(IFS="|" ; echo "$*" )
}

# Empty block.
function pass() {
	return 0
}

# Prints with prefix app name.
function puts() {
	echo -e "\e[1;38;5;112m${appname,,}\e[1;38;5;214m: \e[1;38;5;229m$*\e[0m"
}

# Fakethings builder.
# procFakethingBuilder [version|vmstat|stat] [destination]
function procFakethingBuilder()
{
	if [[ $1 != "" ]]; then
		if [[ $2 == "" ]]; then
			echo -e "..fakething: proc destination can't empty"
			exit 1
		fi
		if [[ $1 == "version" ]]; then
			cat <<- EOF > $2/proc/fakethings/version
				Linux version 5.4.0-faked (andronix@fakeandroid) (gcc version 4.9.x (Andronix fake /proc/version) ) #1 SMP PREEMPT Sun Sep 13 00:00:00 IST 2020
			EOF
		elif [[ $1 == "vmstat" ]]; then
			cat <<- EOF > $2/proc/fakethings/vmstat
				nr_free_pages 15717
				nr_zone_inactive_anon 87325
				nr_zone_active_anon 259521
				nr_zone_inactive_file 95508
				nr_zone_active_file 57839
				nr_zone_unevictable 58867
				nr_zone_write_pending 0
				nr_mlock 58867
				nr_page_table_pages 24569
				nr_kernel_stack 49552
				nr_bounce 0
				nr_zspages 80896
				nr_free_cma 0
				nr_inactive_anon 87325
				nr_active_anon 259521
				nr_inactive_file 95508
				nr_active_file 57839
				nr_unevictable 58867
				nr_slab_reclaimable 17709
				nr_slab_unreclaimable 47418
				nr_isolated_anon 0
				nr_isolated_file 0
				workingset_refault 33002180
				workingset_activate 5498395
				workingset_restore 2354202
				workingset_nodereclaim 140006
				nr_anon_pages 344014
				nr_mapped 193745
				nr_file_pages 218441
				nr_dirty 0
				nr_writeback 0
				nr_writeback_temp 0
				nr_shmem 1880
				nr_shmem_hugepages 0
				nr_shmem_pmdmapped 0
				nr_anon_transparent_hugepages 0
				nr_unstable 0
				nr_vmscan_write 8904094
				nr_vmscan_immediate_reclaim 139732
				nr_dirtied 8470080
				nr_written 16835370
				nr_indirectly_reclaimable 8273152
				nr_unreclaimable_pages 130861
				nr_dirty_threshold 31217
				nr_dirty_background_threshold 15589
				pgpgin 198399484
				pgpgout 31742368
				pgpgoutclean 45542744
				pswpin 3843200
				pswpout 8903884
				pgalloc_dma 192884869
				pgalloc_normal 190990320
				pgalloc_movable 0
				allocstall_dma 0
				allocstall_normal 3197
				allocstall_movable 1493
				pgskip_dma 0
				pgskip_normal 0
				pgskip_movable 0
				pgfree 384653565
				pgactivate 34249517
				pgdeactivate 44271435
				pglazyfree 192
				pgfault 46133667
				pgmajfault 5568301
				pglazyfreed 0
				pgrefill 55909145
				pgsteal_kswapd 58467386
				pgsteal_direct 255950
				pgscan_kswapd 86628315
				pgscan_direct 415889
				pgscan_direct_throttle 0
				pginodesteal 18
				slabs_scanned 31242197
				kswapd_inodesteal 1238474
				kswapd_low_wmark_hit_quickly 11637
				kswapd_high_wmark_hit_quickly 5411
				pageoutrun 32167
				pgrotated 213328
				drop_pagecache 0
				drop_slab 0
				oom_kill 0
				pgmigrate_success 729722
				pgmigrate_fail 450
				compact_migrate_scanned 43510584
				compact_free_scanned 248175096
				compact_isolated 1494774
				compact_stall 6
				compact_fail 3
				compact_success 3
				compact_daemon_wake 9438
				compact_daemon_migrate_scanned 43502436
				compact_daemon_free_scanned 248107303
				unevictable_pgs_culled 66418
				unevictable_pgs_scanned 0
				unevictable_pgs_rescued 8484
				unevictable_pgs_mlocked 78830
				unevictable_pgs_munlocked 8508
				unevictable_pgs_cleared 11455
				unevictable_pgs_stranded 11455
				swap_ra 0
				swap_ra_hit 7
				speculative_pgfault 221449963
			EOF
		elif [[ $1 == "stat" ]]; then
			cat <<- EOF > $2/proc/fakethings/stat
				cpu  5502487 1417100 4379831 62829678 354709 539972 363929 0 0 0
				cpu0 611411 171363 667442 7404799 61301 253898 205544 0 0 0
				cpu1 660993 192673 571402 7853047 39647 49434 29179 0 0 0
				cpu2 666965 186509 576296 7853110 39012 48973 26407 0 0 0
				cpu3 657630 183343 573805 7863627 38895 48768 26636 0 0 0
				cpu4 620516 161440 594973 7899146 39438 47605 26467 0 0 0
				cpu5 610849 155665 594684 7912479 40258 46870 26044 0 0 0
				cpu6 857685 92294 387182 8096756 46609 22110 12364 0 0 0
				cpu7 816434 273809 414043 7946709 49546 22311 11284 0 0 0
				intr 601715486 0 0 0 0 70612466 0 2949552 0 93228 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 12862684 625329 10382717 16209 55315 8510 0 0 0 0 11 11 13 270 192 40694 95 7 0 0 0 36850 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 286 6378 0 0 0 54 0 3239423 2575191 82725 0 0 127 0 0 0 1791277 850609 20 9076504 0 301 0 0 0 0 0 3834621 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 806645 0 0 0 0 0 7243 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2445850 52 1783 0 0 5091520 0 0 0 3 0 0 0 0 0 5475 0 198001 0 2 42 1289224 0 2 202483 4 0 8390 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3563336 4202122 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 1 0 0 1 0 1 0 17948 0 0 612 0 0 0 0 2103 0 0 20 0 0 0 0 0 0 0 0 0 0 0 0 0 10 0 0 0 0 0 0 0 11 11 12 0 12 0 52 752 0 0 0 0 0 0 0 743 0 14 0 0 12 0 0 1863 229 0 464 0 0 0 0 0 0 8588 97 7236426 92766 622 31 0 0 0 18 4 4 0 5 0 0 116013 7 0 0 752406
				ctxt 826091808
				btime 1611513513
				processes 288493
				procs_running 1
				procs_blocked 0
				softirq 175407567 14659158 51739474 28359 5901272 8879590 0 11988166 46104015 0 36107533
			EOF
		else
			echo -e "..$1: unknown proc fakething"
			exit 1
		fi
	else
		echo -e "..fakething: proc can't empty"
		exit 1
	fi
}

# Prints standard input label.
function stdin() {
	echo -e "$(stdio stdin $@)\x20\e[1;38;5;229m\c"
}

# Prints standard input/output label.
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
	local binary=ubuntu
	local execute=ubuntu-start
	
	# Default Ubuntu Environment for install.
	local dekstop=XFCE
	
	# Default Ubuntu Window Manager for install.
	local window=Awesome
	
	# Default Ubuntu Version for install.
	local version=22.04
	
	# Handle Ubuntu Import.
	function ubuntuImport()
	{
		# Ubuntu Install Source Destination.
		local source=$target/$version
	}
	
	# Handle Ubuntu Install.
	function ubuntuInstall()
	{
		# Default Ubuntu Install Source Destination.
		local source=$target/$version
		
		# Default Ubuntu RootFS name.
		local rootfs=ubuntu-rootfs.$version.tar.gz
		
		# Resolve Ubuntu RootFS name and archive url.
		if [[ $version == 22.04 ]]; then
			case ${architect,,} in
				aarch64) archurl="arm64" ;;
				*)
					echo -e "..ubuntu: $version: $architect: unsupported architecture"
					exit 1
				;;
			esac
			archive="https://github.com/AndronixApp/AndronixOrigin/raw/master/Rootfs/Ubuntu22/jammy-${archurl}.tar.gz"
		elif [[ $version == 20.03 ]]; then
			case ${architect,,} in
				aarch64) archurl="arm64" ;;
				arm) archurl="armhf" ;;
				amd64) archurl="amd64" ;;
				x86_64) archurl="amd64" ;;
				*)
					echo -e "..ubuntu: $version: $architect: unsupported architecture"
					exit 1
				;;
			esac
			archive="https://github.com/AndronixApp/AndronixOrigin/raw/master/Rootfs/Ubuntu20/focal-${archurl}.tar.gz"
		elif [[ $version == 18.04 ]]; then
			case ${architect,,} in
				aarch64) archurl="arm64" ;;
				arm) archurl="armhf" ;;
				amd64) archurl="amd64" ;;
				x86_64) archurl="amd64" ;;
				i*86) archurl="i386" ;;
				x86) archurl="i386" ;;
				*)
					echo -e "..ubuntu: $version: $architect: unsupported architecture"
					exit 1
				;;
			esac
			archive="https://github.com/Techriz/AndronixOrigin/blob/master/Rootfs/Ubuntu/${archurl}/ubuntu-rootfs-${archurl}.tar.xz?raw=true"
			rootfs=ubuntu-rootfs.$version.tar.xz
		else
			echo -e "..ubuntu: $version: unsupported version"
			exit 1
		fi
		
		# Resolve Ubuntu Source Destination.
		case $select in
			cli) source=$source/cli ;;
			window) source=$source/window/$window ;;
			dekstop) source=$source/dekstop/$dekstop ;;
			*)
				echo -e "..ubuntu: $version: $select: unknown selection mode"
				exit 1
			;;
		esac
		
		# Check if file system does not exists.
		if [[ ! -d $source/$folder ]]; then
			if [[ ! -f $images/$rootfs ]]; then
				wget $archive -O $images/$rootfs
			fi
			mkdir -p $source/$folder
			if [[ $version == 18.04 ]]; then
				proot --link2symlink tar -xJf $images/$rootfs -C $source/$folder||:
			else
				proot --link2symlink tar -xf $images/$rootfs --exclude=dev -C $source/$folder||:
			fi
			echo -e "\n..ubuntu: $version: $rootfs: remove tarball"
			while [[ $inputRemove == "" ]]; do
				readline "ubuntu" "remove" "Y"
				case ${inputRemove,,} in
					y|yes)
						echo -e "\n..ubuntu: $version: $rootfs: removing"
						rm -f $images/$rootfs
					;;
					n|no) ;;
					*)
						inputRemove=
					;;
				esac
			done
		fi
		
		mkdir -p $source/ubuntu-binds
		if [[ -d $source/$folder/proc ]]; then
			chmod 755 $source/$folder/proc
			mkdir -p $source/$folder/proc/fakethings
			if [[ ! -f $source/$folder/proc/fakethings/version ]]; then
				procFakethingBuilder "version" $source/$folder
			fi
			if [[ ! -f $source/$folder/proc/fakethings/vmstat ]]; then
				procFakethingBuilder "vmstat" $source/$folder
			fi
			if [[ ! -f $source/$folder/proc/fakethings/stat ]]; then
				procFakethingBuilder "stat" $source/$folder
			fi
		fi
		
		case $version in
			22.04)
				if [[ ! -f $source/$execute ]]; then
					cat > $source/$execute <<- EOM
						#!/usr/bin/env bash
						
						# Change current working directory.
						cd \$(dirname \$0)
						
						# Avoid termux-exec, execve() conflicts with PRoot.
						unset LD_PRELOAD
						
						# Arrange command.
						command="proot"
						command+=" --kill-on-exit"
						command+=" --link2symlink"
						command+=" -0"
						command+=" -r $source/$folder"
						
						if [ -n "\$(ls -A $source/ubuntu-binds)" ]; then
						    for f in $source/ubuntu-binds/*; do
						        . \$f
						    done
						fi
						
						command+=" -b /dev"
						command+=" -b /proc"
						command+=" -b /sys"
						command+=" -b /data"
						command+=" -b $source/$folder/root:/dev/shm"
						command+=" -b /proc/self/fd/2:/dev/stderr"
						command+=" -b /proc/self/fd/1:/dev/stdout"
						command+=" -b /proc/self/fd/0:/dev/stdin"
						command+=" -b /dev/urandom:/dev/random"
						command+=" -b /proc/self/fd:/dev/fd"
						command+=" -b $source/$folder/proc/fakethings/stat:/proc/stat"
						command+=" -b $source/$folder/proc/fakethings/vmstat:/proc/vmstat"
						command+=" -b $source/$folder/proc/fakethings/version:/proc/version"
						
						# Uncomment the following line to have
						# access to the home directory of termux.
						#command+=" -b /data/data/com.termux/files/home:/root"
						
						command+=" -b /sdcard"
						command+=" -w /root"
						command+=" /usr/bin/env -i"
						command+=" MOZ_FAKE_NO_SANDBOX=1"
						command+=" HOME=/root"
						command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
						command+=" TERM=\$TERM"
						command+=" LANG=C.UTF-8"
						command+=" /bin/bash --login"
						com="\$@"
						
						if [ -z "\$1" ]; then
						    exec \$command
						else
						    \$command -c "\$com"
						fi
					EOM
					
					echo -e "\n..ubuntu: $version: $execute: fixing shebang"
					termux-fix-shebang $source/$execute
					
					echo -e "..ubuntu: $version: $execute: allow executable"
					chmod +x $source/$execute
				fi
				if [[ $select == "dekstop" ]]; then
					case ${dekstop,,} in
						xfce)
							rinku="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT/XFCE4"
						;;
						lxqt)
							rinku="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT/LXQT"
						;;
						lxde)
							rinku="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT/LXDE"
						;;
					esac
					
					mkdir -p $source/$folder/var/tmp
					rm -rf $source/$folder/usr/local/bin/*
					echo "127.0.0.1 localhost localhost" > $source/$folder/etc/hosts
					
					echo -e "\n..ubuntu: $version: vnc: downloading"
					wget -q https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Rootfs/Ubuntu19/vnc -P $source/$folder/usr/local/bin > /dev/null
					echo -e "\n..ubuntu: $version: vnc: allow executable"
					chmod +x $source/$folder/usr/local/bin/vnc
					
					echo -e "\n..ubuntu: $version: vncpasswd: downloading"
					wget -q https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Rootfs/Ubuntu19/vncpasswd -P $source/$folder/usr/local/bin > /dev/null
					echo -e "\n..ubuntu: $version: vncpasswd: allow executable"
					chmod +x $source/$folder/usr/local/bin/vncpasswd
					
					echo -e "\n..ubuntu: $version: vncserver-start: downloading"
					wget -q https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Rootfs/Ubuntu19/vncserver-stop -P $source/$folder/usr/local/bin > /dev/null
					echo -e "\n..ubuntu: $version: vncserver-start: allow executable"
					chmod +x $source/$folder/usr/local/bin/vncserver-start
					
					echo -e "\n..ubuntu: $version: vncserver-stop: downloading"
					wget -q https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Rootfs/Ubuntu19/vncserver-start -P $source/$folder/usr/local/bin > /dev/null
					echo -e "\n..ubuntu: $version: vncserver-stop: allow executable"
					chmod +x $source/$folder/usr/local/bin/vncserver-stop
					
					echo -e "\n..ubuntu: $version: dekstop: setup of ${dektop^^} VNC"
					echo -e "..ubuntu: $version: $dekstop: setup apt retry count"
					echo "APT::Acquire::Retries \"3\";" > $source/$folder/etc/apt/apt.conf.d/80-retries
					
					echo -e "..ubuntu: $version: $dekstop: .bash_profile: removing"
					rm -rf $source/$folder/root/.bash_profile
					
					echo -e "..ubuntu: $version: $dekstop: .hushlogin: creating"
					touch $source/$folder/root/.hushlogin
					
					echo -e "..ubuntu: $version: $dekstop: ${dekstop}.sh: downloading"
					wget --tries=20 $rinku/${dekstop}22.sh -O $source/$folder/root/dekstop.sh
					
					echo -e "..ubuntu: $version: $dekstop: .bash_profile: building"
					cat <<- EOF > $source/$folder/root/.bash_profile
						#!/usr/bin/env bash
						
						# Remove old resolve configuration.
						rm -rf /etc/resolv.conf
						
						# Create new resolve configuration.
						echo "nameserver 8.8.8.8" >> /etc/resolv.conf
						
						# Installing required packages.
						apt update -y && apt install sudo wget nano screenfetch -y > /dev/null
						clear
						
						# Create directory for vnc configuration.
						mkdir -p ~/.vnc
						
						if [ ! -f /root/dekstop.sh ]; then
							echo -e "..ubuntu: $version: $dekstop: ${dekstop}.sh: downloading"
						    wget --tries=20 $rinku/${dekstop}22.sh -O /root/${dekstop}.sh
						    bash ~/$dekstop.sh
						else
						    bash ~/$dekstop.sh
						fi
						clear
						
						if [ ! -f /usr/local/bin/vncserver-start ]; then
						    echo -e "\n..ubuntu: $version: vncserver-start: downloading"
						    wget --tries=20 $rinku/vncserver-start -O /usr/local/bin/vncserver-start
						    echo -e "\n..ubuntu: $version: vncserver-start: removing"
						    chmod +x /usr/local/bin/vncserver-start
						    
						    echo -e "\n..ubuntu: $version: vncserver-stop: downloading"
						    wget --tries=20 $rinku/vncserver-stop -O /usr/local/bin/vncserver-stop
						    echo -e "\n..ubuntu: $version: vncserver-stop: removing"
						    chmod +x /usr/local/bin/vncserver-stop
						fi
						clear
						
						if [ ! -f /usr/bin/vncserver ]; then
						    apt install tigervnc-standalone-server -y
						fi
						clear
						
						echo -e "..ubuntu: $version: $dekstop: ${dekstop}.sh: removing"
						rm -rf /root/{dekstop}.sh
						
						echo -e "..ubuntu: $version: $dekstop: .bash_profile: removing"
						rm -rf ~/.bash_profile
						
						clear && screenfetch
					EOF
				elif [[ $select == "window" ]]; then
					case ${window,,} in
						awesome) ;;
						openbox) ;;
						i3) ;;
					esac
				fi
			;;
			20.04)
				if [[ $select == "dekstop" ]]; then
					case ${dekstop,,} in
						xfce) ;;
						lxqt) ;;
						lxde) ;;
					esac
				elif [[ $select == "window" ]]; then
					case ${window,,} in
						awesome) ;;
						openbox) ;;
						i3) ;;
					esac
				fi
			;;
			18.04)
				if [[ $select == "dekstop" ]]; then
					case ${dekstop,,} in
						xfce) ;;
						lxqt) ;;
						lxde) ;;
					esac
				elif [[ $select == "window" ]]; then
					case ${window,,} in
						awesome) ;;
						openbox) ;;
						i3) ;;
					esac
				fi
			;;
		esac
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
		cancel)
			main
		;;
		remove)
			ubuntuRemove
		;;
		import)
			ubuntuImport
			ubuntuInstall
		;;
		install)
			ubuntuInstall
		;;
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
