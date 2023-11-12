#!/usr/bin/env bash

#
# Penguin
#
# Shell utility to install Linux on Termux.
# Please report any issues or bugs you find while using this tool.
# If there is an outdated distro installation, or an outdated gpg key
# it is purely not this script's fault because, this tool is not completely
# self-contained, it fetches various Linux Root File System (rootfs) resources
# from various sources, and be thankful they ever existed.
#
# @author Ari Setiawan
# @create 11.07-2023 18:21
# @github https://github.com/hxAri/Penguin
#
# Penguin Copyright (c) 2023 - Ari Setiawan <hxari@proton.me>
# Penguin Licence under GNU General Public Licence v3
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#

# Application name.
appname=Penguin

# Application author.
author="Ari Setiawan (hxAri)"
author_email="hxari@proton.me"

# Application version.
version=1.0.0

# Application repository.
github=https://github.com/hxAri/$appname
issues=https://github.com/hxAri/$appname/issues

# Termux directory.
termux=/data/data/com.termux

# Installation directory.
install=/data/data/com.termux/linux

# Rootfs Images stored.
images=$install/.rootfs

# Termux architecture.
architect=$(dpkg --print-architecture)

# Square bracket with interpunch.
sint="[·]"

# Handle Building common Binary for execute Launch Script.
# binaryBuilder [distro] [binary] [launch] [folder] [source]
function binaryBuilder() {

	local distro=$1
	local binary=$2
	local launch=$3
	local folder=$4
	local source=$5
	
	if [[ $distro == "" ]]; then
		echo -e "..\n..$appname: distro name can't be empty"
		exit 1
	fi
	if [[ $binary == "" ]]; then
		echo -e "..\n..$distro: binary filename required"
		exit 1
	fi
	if [[ $launch == "" ]]; then
		echo -e "..\n..$distro: launch script name required"
		exit 1
	fi
	if [[ $folder == "" ]]; then
		echo -e "..\n..$distro: folder name can't be empty"
		exit 1
	fi
	if [[ $source == "" ]]; then
		echo -e "..\n..$distro: source of installed distro required"
		exit 1
	fi
	
	echo -e "..\n..$distro: /:bin/$binary: building"
	cat <<- EOF > $termux/files/usr/bin/${binary}
		#!/usr/bin/env bash
		echo -e "#!/usr/bin/env bash
		
		# Default ${distro^} Selection.
		select=cli
		window=awesome
		desktop=xfce
		
		if [[ \\\$1 != \"\" ]]; then
		    case \\\${1,,} in
		        cli) select=cli ;;
		        window)
		            select=window
		            if [[ \\\$2 != \"\" ]]; then
		                case \\\${2,,} in
		                    awesome) window=awesome ;;
		                    openbox) window=openbox ;;
		                    i3) window=i3 ;;
		                    *)
		                        echo -e \"$distro: \\\$2: unsupported window manager\"
		                        exit 1
		                    ;;
		                esac
		            fi
		        ;;
		        desktop)
		            select=desktop
		            if [[ \\\$2 != \"\" ]]; then
		                case \\\${2^^} in
		                    XFCE) desktop=xfce ;;
		                    LXQT) desktop=lxqt ;;
		                    LXDE) desktop=lxde ;;
		                    *)
		                        echo -e \"$distro: \\\$2: unsupported desktop environment\"
		                        exit 1
		                esac
		            fi
		        ;;
		        *)
		            echo -e \"$distro: \\\$1: unsupported selection mode\"
		            exit 1
		        ;;
		    esac
		fi
		
		# Default ${distro^} Source.
		source=$source/\\\$select
		
		# Resolve ${distro^} Source.
		case \\\$select in
		    window) source+=/\\\$window ;;
		    desktop) source+=/\\\$desktop ;;
		esac
		
		if [[ ! -d \\\$source/$folder ]] || [[ ! -d \\\$source/${distro,,}-binds ]] || [[ ! -f \\\$source/$launch ]]; then
		    case \\\$select in
		        cli) echo -e \"$distro: \\\$select: is not installed\" ;;
		        window) echo -e \"$distro: \\\$select: \\\$window: is not installed\" ;;
		        desktop) echo -e \"$distro: \\\$select: \\\$desktop: is not installed\" ;;
		    esac
		    exit 1
		else
		    if [[ -d \\\$source/$folder/proc ]]; then
		        chmod 755 \\\$source/$folder/proc
		        mkdir -p \\\$source/$folder/proc/fakethings
		        if [[ ! -d \\\$source/$folder/proc/fakethings ]]; then
		            mkdir -p \\\$source/$folder/proc/fakethings
		        fi
		        if [[ ! -f \\\$source/$folder/proc/fakethings/version ]]; then
		            cat <<- EOF > \\\$source/$folder/proc/fakethings/version
		\t\t\t\tLinux version 5.4.0-faked (andronix@fakeandroid) (gcc version 4.9.x (Andronix fake /proc/version) ) #1 SMP PREEMPT Sun Sep 13 00:00:00 IST 2020
		\t\t\tEOF
		        fi
		        if [[ ! -f \\\$source/$folder/proc/fakethings/vmstat ]]; then
		            cat <<- EOF > \\\$source/$folder/proc/fakethings/vmstat
		\t\t\t\tnr_free_pages 15717
		\t\t\t\tnr_zone_inactive_anon 87325
		\t\t\t\tnr_zone_active_anon 259521
		\t\t\t\tnr_zone_inactive_file 95508
		\t\t\t\tnr_zone_active_file 57839
		\t\t\t\tnr_zone_unevictable 58867
		\t\t\t\tnr_zone_write_pending 0
		\t\t\t\tnr_mlock 58867
		\t\t\t\tnr_page_table_pages 24569
		\t\t\t\tnr_kernel_stack 49552
		\t\t\t\tnr_bounce 0
		\t\t\t\tnr_zspages 80896
		\t\t\t\tnr_free_cma 0
		\t\t\t\tnr_inactive_anon 87325
		\t\t\t\tnr_active_anon 259521
		\t\t\t\tnr_inactive_file 95508
		\t\t\t\tnr_active_file 57839
		\t\t\t\tnr_unevictable 58867
		\t\t\t\tnr_slab_reclaimable 17709
		\t\t\t\tnr_slab_unreclaimable 47418
		\t\t\t\tnr_isolated_anon 0
		\t\t\t\tnr_isolated_file 0
		\t\t\t\tworkingset_refault 33002180
		\t\t\t\tworkingset_activate 5498395
		\t\t\t\tworkingset_restore 2354202
		\t\t\t\tworkingset_nodereclaim 140006
		\t\t\t\tnr_anon_pages 344014
		\t\t\t\tnr_mapped 193745
		\t\t\t\tnr_file_pages 218441
		\t\t\t\tnr_dirty 0
		\t\t\t\tnr_writeback 0
		\t\t\t\tnr_writeback_temp 0
		\t\t\t\tnr_shmem 1880
		\t\t\t\tnr_shmem_hugepages 0
		\t\t\t\tnr_shmem_pmdmapped 0
		\t\t\t\tnr_anon_transparent_hugepages 0
		\t\t\t\tnr_unstable 0
		\t\t\t\tnr_vmscan_write 8904094
		\t\t\t\tnr_vmscan_immediate_reclaim 139732
		\t\t\t\tnr_dirtied 8470080
		\t\t\t\tnr_written 16835370
		\t\t\t\tnr_indirectly_reclaimable 8273152
		\t\t\t\tnr_unreclaimable_pages 130861
		\t\t\t\tnr_dirty_threshold 31217
		\t\t\t\tnr_dirty_background_threshold 15589
		\t\t\t\tpgpgin 198399484
		\t\t\t\tpgpgout 31742368
		\t\t\t\tpgpgoutclean 45542744
		\t\t\t\tpswpin 3843200
		\t\t\t\tpswpout 8903884
		\t\t\t\tpgalloc_dma 192884869
		\t\t\t\tpgalloc_normal 190990320
		\t\t\t\tpgalloc_movable 0
		\t\t\t\tallocstall_dma 0
		\t\t\t\tallocstall_normal 3197
		\t\t\t\tallocstall_movable 1493
		\t\t\t\tpgskip_dma 0
		\t\t\t\tpgskip_normal 0
		\t\t\t\tpgskip_movable 0
		\t\t\t\tpgfree 384653565
		\t\t\t\tpgactivate 34249517
		\t\t\t\tpgdeactivate 44271435
		\t\t\t\tpglazyfree 192
		\t\t\t\tpgfault 46133667
		\t\t\t\tpgmajfault 5568301
		\t\t\t\tpglazyfreed 0
		\t\t\t\tpgrefill 55909145
		\t\t\t\tpgsteal_kswapd 58467386
		\t\t\t\tpgsteal_direct 255950
		\t\t\t\tpgscan_kswapd 86628315
		\t\t\t\tpgscan_direct 415889
		\t\t\t\tpgscan_direct_throttle 0
		\t\t\t\tpginodesteal 18
		\t\t\t\tslabs_scanned 31242197
		\t\t\t\tkswapd_inodesteal 1238474
		\t\t\t\tkswapd_low_wmark_hit_quickly 11637
		\t\t\t\tkswapd_high_wmark_hit_quickly 5411
		\t\t\t\tpageoutrun 32167
		\t\t\t\tpgrotated 213328
		\t\t\t\tdrop_pagecache 0
		\t\t\t\tdrop_slab 0
		\t\t\t\toom_kill 0
		\t\t\t\tpgmigrate_success 729722
		\t\t\t\tpgmigrate_fail 450
		\t\t\t\tcompact_migrate_scanned 43510584
		\t\t\t\tcompact_free_scanned 248175096
		\t\t\t\tcompact_isolated 1494774
		\t\t\t\tcompact_stall 6
		\t\t\t\tcompact_fail 3
		\t\t\t\tcompact_success 3
		\t\t\t\tcompact_daemon_wake 9438
		\t\t\t\tcompact_daemon_migrate_scanned 43502436
		\t\t\t\tcompact_daemon_free_scanned 248107303
		\t\t\t\tunevictable_pgs_culled 66418
		\t\t\t\tunevictable_pgs_scanned 0
		\t\t\t\tunevictable_pgs_rescued 8484
		\t\t\t\tunevictable_pgs_mlocked 78830
		\t\t\t\tunevictable_pgs_munlocked 8508
		\t\t\t\tunevictable_pgs_cleared 11455
		\t\t\t\tunevictable_pgs_stranded 11455
		\t\t\t\tswap_ra 0
		\t\t\t\tswap_ra_hit 7
		\t\t\t\tspeculative_pgfault 221449963
		\t\t\tEOF
		        fi
		        if [[ ! -f \\\$source/$folder/proc/fakethings/stat ]]; then
		            cat <<- EOF > \\\$source/$folder/proc/fakethings/stat
		\t\t\t\tcpu  5502487 1417100 4379831 62829678 354709 539972 363929 0 0 0
		\t\t\t\tcpu0 611411 171363 667442 7404799 61301 253898 205544 0 0 0
		\t\t\t\tcpu1 660993 192673 571402 7853047 39647 49434 29179 0 0 0
		\t\t\t\tcpu2 666965 186509 576296 7853110 39012 48973 26407 0 0 0
		\t\t\t\tcpu3 657630 183343 573805 7863627 38895 48768 26636 0 0 0
		\t\t\t\tcpu4 620516 161440 594973 7899146 39438 47605 26467 0 0 0
		\t\t\t\tcpu5 610849 155665 594684 7912479 40258 46870 26044 0 0 0
		\t\t\t\tcpu6 857685 92294 387182 8096756 46609 22110 12364 0 0 0
		\t\t\t\tcpu7 816434 273809 414043 7946709 49546 22311 11284 0 0 0
		\t\t\t\tintr 601715486 0 0 0 0 70612466 0 2949552 0 93228 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 12862684 625329 10382717 16209 55315 8510 0 0 0 0 11 11 13 270 192 40694 95 7 0 0 0 36850 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 286 6378 0 0 0 54 0 3239423 2575191 82725 0 0 127 0 0 0 1791277 850609 20 9076504 0 301 0 0 0 0 0 3834621 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 806645 0 0 0 0 0 7243 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2445850 52 1783 0 0 5091520 0 0 0 3 0 0 0 0 0 5475 0 198001 0 2 42 1289224 0 2 202483 4 0 8390 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3563336 4202122 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 1 0 0 1 0 1 0 17948 0 0 612 0 0 0 0 2103 0 0 20 0 0 0 0 0 0 0 0 0 0 0 0 0 10 0 0 0 0 0 0 0 11 11 12 0 12 0 52 752 0 0 0 0 0 0 0 743 0 14 0 0 12 0 0 1863 229 0 464 0 0 0 0 0 0 8588 97 7236426 92766 622 31 0 0 0 18 4 4 0 5 0 0 116013 7 0 0 752406
		\t\t\t\tctxt 826091808
		\t\t\t\tbtime 1611513513
		\t\t\t\tprocesses 288493
		\t\t\t\tprocs_running 1
		\t\t\t\tprocs_blocked 0
		\t\t\t\tsoftirq 175407567 14659158 51739474 28359 5901272 8879590 0 11988166 46104015 0 36107533
		\t\t\tEOF
		        fi
		    fi
		fi
		
		bash \\\$source/$launch
		" > $termux/files/usr/bin/$binary
		chmod +x $termux/files/usr/bin/$binary
	EOF
	
	echo -e "..$distro: /:bin/$binary: fixing shebang"
	termux-fix-shebang $termux/files/usr/bin/$binary
	
	echo -e "..$distro: /:bin/$binary: allow executable"
	chmod +x $termux/files/usr/bin/$binary
	
	echo -e "..$distro: /:bin/$binary: re-wriring\n..\n"
	bash $termux/files/usr/bin/$binary
}

# Array joins.
function joins() {
	echo $(IFS="|" ; echo "$*" )
}

# Empty block.
function pass() {
	return 0
}

# Fakethings builder.
# procFakethingBuilder [version|vmstat|stat] [destination]
function procFakethingBuilder() {
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

# Prints with prefix app name.
function puts() {
	echo -e "\e[1;38;5;112m${appname,,}\e[1;38;5;214m: \e[1;38;5;229m$*\e[0m"
}

# Prints standard input label.
function stdin() {
	echo -e "$(stdio stdin $@)\x20\e[1;38;5;229m\c"
}

# Prints standard input/output label.
function stdio() {
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
function readline() {
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

# Handle  readline input Action.
# readInputAction [distro] [action] [version]
function readInputAction() {

	local inputAction=
	local inputSelect=
	local inputWindow=
	local inputDesktop=
	local inputVersion=

	# Handle readline input selection mode.
	# readInputSelect [distro]
	function readInputSelect() {

		# Handle readline input desktop environment.
		# readInputDesktopEnv [distro]
		function readInputDesktopEnv() {
			while [[ $inputDesktop == "" ]]; do
				readline $1 "desktop" "XFCE"
				inputDesktop=${inputDesktop^^}
				case $inputDesktop in
					1|XFCE)
						inputDesktop=xfce
					;;
					2|LXQT)
						inputDesktop=lxqt
						case ${1,,} in
							alpine|arch)
								inputDesktop=
							;;
						esac
					;;
					3|LXDE)
						inputDesktop=lxde
						case ${1,,} in
							alpine)
								inputDesktop=
							;;
						esac
					;;
					4|MATE)
						inputDesktop=mate
						if [[ ${1,,} != "manjaro" ]]; then
							inputDesktop=
						fi
					;;
					*)
						inputDesktop=
					;;
				esac
			done
		}

		# Handle readline input window manager.
		# readInputWindowManager [distro]
		function readInputWindowManager() {
			while [[ $inputWindow == "" ]]; do
				readline $1 "window" "Awesome"
				inputWindow=${inputWindow,,}
				case $inputWindow in
					1|awesome) inputWindow=awesome ;;
					2|openbox) inputWindow=openbox ;;
					3|i3) inputWindow=i3 ;;
					*) inputDesktop= ;;
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
				3|desktop)
					inputSelect=desktop
					readInputDesktopEnv $1 $3
					desktop=$inputDesktop
				;;
				*) inputSelect= ;;
			esac
			select=${inputSelect,,}
		done
	}

	# Handle readline input selection mode.
	# readInputImport [distro]
	function readInputImport() {
		while [[ $inputImport == "" ]]; do
			readline $1 "import"
			if [[ ! -f $inputImport ]]; then
				inputImport=
			fi
		done
	}
	
	# Handle readline input version.
	# readInputVersion [distro] [default]
	function readInputVersion() {
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
			readInputImport $1
			import=$inputImport
		fi
		readInputSelect $1
		select=$inputSelect
		if [[ $select == "window" ]]; then
			window=$inputWindow
		elif [[ $select == "desktop" ]]; then
			desktop=$inputDesktop
		fi
	fi
}

# Handle VNC Viewer Download.
# vncViewerSetup [source]
function vncViewerSetup() {
	if [[ $1 != "" ]]; then
		if [[ ! -d $1 ]]; then
			echo "vnc: $1: no such file or directory"
			exit 1
		fi
		echo -e "..\n..ubuntu: $version: vnc: downloading"
		wget -q "https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Rootfs/Ubuntu19/vnc" -P $1/usr/local/bin > /dev/null
		echo -e "..ubuntu: $version: vnc: allow executable"
		chmod +x $1/usr/local/bin/vnc
		
		echo -e "..\n..ubuntu: $version: vncpasswd: downloading"
		wget -q "https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Rootfs/Ubuntu19/vncpasswd" -P $1/usr/local/bin > /dev/null
		echo -e "..ubuntu: $version: vncpasswd: allow executable"
		chmod +x $1/usr/local/bin/vncpasswd
		
		echo -e "..\n..ubuntu: $version: vncserver-start: downloading"
		wget -q "https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Rootfs/Ubuntu19/vncserver-start" -P $1/usr/local/bin > /dev/null
		echo -e "..ubuntu: $version: vncserver-start: allow executable"
		chmod +x $1/usr/local/bin/vncserver-start
		
		echo -e "..\n..ubuntu: $version: vncserver-stop: downloading"
		wget -q "https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Rootfs/Ubuntu19/vncserver-stop" -P $1/usr/local/bin > /dev/null
		echo -e "..ubuntu: $version: vncserver-stop: allow executable"
		chmod +x $1/usr/local/bin/vncserver-stop
	fi
}

# Handle Alpine Actions.
function alpine() {

	# Default Alpine Mode for install.
	local select=cli
	
	# Default Import is always empty.
	# Because we don't know where source destination.
	local import=
	
	# Default Alpine Directory.
	local source=$install/alpine
	local folder=alpine-fs
	
	# Default Alpine Executable.
	local binary=alpine
	local launch=alpine-start
	
	# Default Alpine Window Manager.
	local window=Awesome
	
	# Default Alpine Environment for install.
	local desktop=XFCE
	
	# Handle Building Alpine Binary.
	function alpineBinary() {
		binaryBuilder "alpine" $binary $launch $folder $source
	}
	
	# Handle Building Alpine Launcher.
	function alpineLauncher() {
		echo -e "..\n..alpine: $launch: building"
		cat > $target/$launch <<- EOM
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
			command+=" -r $target/$folder"
			
			if [ -n "\$(ls -A $target/alpine-binds)" ]; then
			    for f in $target/alpine-binds/* ;do
			        . \$f
			    done
			fi
			
			command+=" -b /dev"
			command+=" -b /proc"
			command+=" -b $target/$folder/root:/dev/shm"
			
			# Uncomment the following line to have
			# access to the home directory of termux
			#command+=" -b $termux/files/home:/root"
			
			# Uncomment the following line to
			# mount /sdcard directly to /.
			#command+=" -b /sdcard"
			
			command+=" -w /root"
			command+=" /usr/bin/env -i"
			command+=" HOME=/root"
			command+=" PATH=/bin:/usr/bin:/sbin:/usr/sbin"
			command+=" TERM=\$TERM"
			command+=" LANG=en_US.UTF-8"
			command+=" LC_ALL=C"
			command+=" LANGUAGE=en_US"
			command+=" /bin/sh --login"
			com="\$@"
			
			if [ -z "\$1" ];then
			    exec \$command
			else
			    \$command -c "\$com"
			fi
		EOM
		
		echo -e "..alpine: $launch: fixing shebang"
		termux-fix-shebang $target/$launch
		
		echo -e "..alpine: $launch: allow executable"
		chmod +x $target/$launch
	}
	
	# Handle Alpine Import.
	function alpineImport() {
		local target=$
	}
	
	# Handle Alpine Install.
	function alpineInstall() {

		# Resolve Alpine Source Destination.
		case $select in
			cli) local target=$source/cli ;;
			window) local target=$source/window/$window ;;
			desktop) local target=$source/desktop/$desktop ;;
			*)
				echo -e "..alpine: $select: unknown selection mode"
				exit 1
			;;
		esac
		
		# Check if previous file system is exists.
		if [[ -d $target/$folder ]]; then
			echo -e "\n..\n..alpine: remove: remove previous installation [Y/n]"
			local inputRemove=
			while [[ $inputRemove == "" ]]; do
				readline "alpine" "remove" "Y"
				case ${inputRemove,,} in
					y|yes)
						inputRemove=y
						echo -e "\n..alpine: $folder: removing previously installation"
						rm -f $target
					;;
					n|no) inputRemove=n ;;
					*)
						inputRemove=
					;;
				esac
			done
		else
			local inputRemove=y
		fi
		
		# If remove is allowed.
		if [[ ${inputRemove,,} == "y" ]]; then
			
			# Resolve Alpine RootFS archive url.
			case ${architect,,} in
				aarch64) local archurl="aarch64" ;;
				arm) local archurl="armhf" ;;
				amd64) local archurl="x86_64" ;;
				x86_64) local archurl="x86_64" ;;	
				i*86) local archurl="x86" ;;
				x86) local archurl="x86" ;;
				*)
					echo -e "..alpine: $architect: unsupported architecture"
					exit 1
				;;
			esac
			
			# Alpine RootFS name based on architecture.
			local rootfs=alpine-rootfs.${archurl}.tar.gz
			
			# Alpine RootFS source.
			local archive="https://github.com/AndronixApp/AndronixOrigin/raw/master/Rootfs/Alpine/${archurl}/alpine-minirootfs-3.10.3-${archurl}.tar.gz?raw=true"
			
			# Check if previous RootFS doesn't exists.
			if [[ ! -f $images/$rootfs ]]; then
				echo -e "\n..alpine: $rootfs: downloading"
				wget -qO- --tries=0 $archive --show-progress --progress=bar:force:noscroll -O $images/$rootfs
				clear
			fi
			
			echo -e "..alpine: alpine-binds: creating"
			mkdir -p $target/alpine-binds
			
			echo -e "..alpine: $folder: creating"
			mkdir -p $target/$folder
			
			echo -e "..alpine: $rootfs: decompressing"
			proot --link2symlink tar -zxf $images/$rootfs --exclude=dev -C $target/$folder||:
			
			echo -e "..alpine: $rootfs: remove tarball [Y/n]"
			local inputRemove=
			while [[ $inputRemove == "" ]]; do
				readline "alpine" "remove" "Y"
				case ${inputRemove,,} in
					y|yes)
						echo -e "\n..alpine: $rootfs: removing tarball"
						rm -f $images/$rootfs
					;;
					n|no) ;;
					*)
						inputRemove=
					;;
				esac
			done
			clear
			
			# Check if Alpine binary doesn't exists.
			if [[ ! -f $termux/files/usr/bin/$binary ]]; then
				alpineBinary
			fi
			
			# Check if launcher script doesn't exists.
			if [[ ! -f $target/$launch ]]; then
				alpineLauncher
			fi
			
			echo -e "\n..\n..alpine: /:etc/fstab: creating"
			echo "" > $target/$folder/etc/fstab
			
			echo -e "..alpine: /:etc/resolv.conf: removing"
			rm -rf $target/$folder/etc/resolv.conf
			
			echo -e "..alpine: /:etc/resolf.conf: creating"
			echo "nameserver 8.8.8.8" > $target/$folder/etc/resolv.conf
			
			echo -e "\n..\n..alpine: $launch: updating"
			bash $target/$launch apk update
			clear
			
			echo -e "\n..\n..alpine: $launch: installing bash"
			bash $target/$launch apk add --no-cache bash
			clear
			
			echo -e "\n..\n..alpine: /:etc/passwd: seeding"
			sed -i "s/ash/bash/g" $target/$folder/etc/passwd
			
			echo -e "..alpine: $launch: seeding"
			sed -i "s/bin\/sh/bin\/bash/g" $target/$launch
			
			if [[ ${select,,} != "cli" ]]; then
				if [[ ${select,,} == "window" ]]; then
					local params=$window
				elif [[ ${select,,} == "desktop" ]]; then
					local params=$desktop
					case ${desktop,,} in
						xfce) ;;
						*)
							echo -e "alpine: $desktop: unsupported desktop environment"
							exit 1
						;;
					esac
					
					echo -e "\n..\n..alpine: /:root/.bash_profile: removing"
					rm -rf $target/$folder/root/.bash_profile
					
					echo -e "..alpine: /:root/.bash_profile: creating"
					cat <<- EOF > $target/$folder/root/.bash_profile
						#!/usr/bin/env bash
						
						# Downloading Desktop Environment Setup file.
						wget https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Installer/Alpine/alpine-${desktop,,}.sh -O /root/${desktop,,}.sh
						
						# Executing Desktop Environment Setup file..
						bash /root/${desktop,,}.sh
						
						# Removing Desktop Environment Setup file.
						rm -rf /root/${desktop,,}.sh
						
						clear
					EOF
					
					echo -e "..alpine: /:root/.bash_profile: allow executable"
					chmod +x $target/$folder/root/.bash_profile
				fi
			else
				local params=
			fi
			
			sleep 2.4
			clear
			echo -e "\n..\n..alpine: $select: installed"
			echo -e "..alpine: $select: command"
			echo -e "..alpine: $select: alpine $select ${params[@]}\n..\n"
			
			echo -e "..alpine: action: run alpine [Y/n]"
			local inputNext=
			while [[ $inputNext == "" ]]; do
				readline "alpine" "next" "Y"
				case ${inputNext,,} in
					y|yes)
						bash $termux/files/usr/bin/$binary $select ${params[@]}
					;;
					n|no) main ;;
					*) inputNext= ;;
				esac
			done
		else
			alpine
		fi
	}
	
	# Handle Alpine Remove.
	function alpineRemove() {
		echo 0
	}
	
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
		cancel) main ;;
		remove)
			alpineRemove
		;;
		import)
			alpineImport
			alpineInstall
		;;
		install)
			alpineInstall
		;;
	esac
}

# Handle Arch Linux Actions.
function arch() {

	# Default Arch Mode for install.
	local select=cli
	
	# Default Import is always empty.
	# Because we don't know where source destination.
	local import=
	
	# Default Arch Directory.
	local source=$install/arch
	local folder=arch-fs
	
	# Default Arch Executable.
	local binary=arch
	local launch=arch-start
	
	# Default Arch RootFS name.
	local rootfs=arch-rootfs.tar.gz
	
	# Default Arch Window Manager.
	local window=Awesome
	
	# Default Arch Environment for install.
	local desktop=XFCE
	
	# Handle Building Arch Binary.
	function archBinary() {
		binaryBuilder "arch" $binary $launch $folder $source
	}
	
	# Handle Building Arch Launcher.
	function archLauncher() {
		echo -e "..\n..arch: $launch: building"
		cat > $target/$launch <<- EOM
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
			command+=" -r $target/$folder"
			
			if [ -n "\$(ls -A $target/arch-binds)" ]; then
			    for f in $target/arch-binds/* ;do
			        . \$f
			    done
			fi
			
			command+=" -b /dev"
			command+=" -b /proc"
			command+=" -b /sys"
			command+=" -b /data"
			command+=" -b $target/$folder/root:/dev/shm"
			command+=" -b /proc/self/fd/2:/dev/stderr"
			command+=" -b /proc/self/fd/1:/dev/stdout"
			command+=" -b /proc/self/fd/0:/dev/stdin"
			command+=" -b /dev/urandom:/dev/random"
			command+=" -b /proc/self/fd:/dev/fd"
			command+=" -b $target/$folder/proc/fakethings/stat:/proc/stat"
			command+=" -b $target/$folder/proc/fakethings/vmstat:/proc/vmstat"
			command+=" -b $target/$folder/proc/fakethings/version:/proc/version"
			
			# Uncomment the following line to have
			# access to the home directory of termux.
			#command+=" -b $termux/files/home:/root" 
			
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
			
			if [ -z "\$1" ];then
			    exec \$command
			else
			    \$command -c "\$com"
			fi
		EOM
		
		echo -e "..arch: $launch: fixing shebang"
		termux-fix-shebang $target/$launch
		
		echo -e "..arch: $launch: allow executable"
		chmod +x $target/$launch
	}
	
	# Handle Arch Import.
	function archImport() {
		echo 0
	}
	
	# Handle Arch Install.
	function archInstall() {

		# Resolve Arch Source Destination.
		case $select in
			cli) local target=$source/cli ;;
			window) local target=$source/window/$window ;;
			desktop) local target=$source/desktop/$desktop ;;
			*)
				echo -e "..arch: $select: unknown selection mode"
				exit 1
			;;
		esac
		
		# Check if file system does not exists.
		if [[ ! -d $target/$folder ]]; then
			if [[ ! -f $images/$rootfs ]]; then
				case ${architect,,} in
					aarch64) local archurl="aarch64" ;;
					arm) local archurl="armv7" ;;
					*)
						echo -e "..arch: $architect: unsupported architecture"
						exit 1
					;;
				esac
				echo -e "\n..arch: $rootfs: downloading"
				wget --tries=20 "http://os.archlinuxarm.org/os/ArchLinuxARM-${archurl}-latest.tar.gz" -O $images/$rootfs
				clear
			fi
			
			echo -e "\n..arch: $folder: creating"
			mkdir -p $target/$folder
			
			echo -e "..arch: $rootfs: decompressing"
			proot --link2symlink tar -xf $images/$rootfs -C $target/$folder||:
			
			echo -e "..arch: $rootfs: remove [Y/n]"
			local inputRemove=
			while [[ $inputRemove == "" ]]; do
				readline "arch" "remove" "Y"
				case ${inputRemove,,} in
					y|yes)
						echo -e "\n..arch: $rootfs: removing"
						rm -rf $images/$rootfs
					;;
					n|no) ;;
					*)
						inputRemove=
					;;
				esac
			done
			clear
		fi
		
		echo -e "..arch: arch-binds: creating"
		mkdir -p $target/arch-binds
		
		echo -e "\n..arch: resolv.conf: downloading"
		wget "https://raw.githubusercontent.com/Techriz/AndronixOrigin/master/Installer/Arch/armhf/resolv.conf" -P $target/$folder/root
		
		echo -e "..arch: additional.sh: downloading"
		wget "https://raw.githubusercontent.com/Techriz/AndronixOrigin/master/Installer/Arch/armhf/additional.sh" -P $target/$folder/root
		
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
		
		# Check if Arch binary doesn't exists.
		if [[ ! -f $termux/files/usr/bin/$binary ]]; then
			archBinary
		fi
		
		# Check if Arch launcher script doesn't exists.
		if [[ ! -f $target/$launch ]]; then
			archLauncher
		fi
		
		local params=
		if [[ ${select,,} != "cli" ]]; then
			if [[ ${select,,} == "desktop" ]]; then
				local params=$desktop
				case ${desktop,,} in
					xfce)
						local rinku=(
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Pacman/Manjaro/XFCE4"
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Pacman/Manjaro"
							"xfce4_de.sh"
						)
					;;
					lxqt)
						local rinku=(
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Pacman/Manjaro/LXQT"
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Pacman/Manjaro"
							"lxqt_de.sh"
						)
					;;
					lxde)
						local rinku=(
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Pacman/Manjaro/LXDE"
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Pacman/Manjaro"
							"lxde_de.sh"
						)
					;;
				esac
				
				echo -e "\n..arch: desktop: setup of ${desktop^^} VNC"
				echo -e "\n..arch: $desktop: ${desktop}.sh: downloading"
				wget --tries=20 ${rinku[1]}/${rinku[2]} -O $target/$folder/root/${desktop}.sh
				echo -e "..arch: $desktop: ${desktop}.sh: allow executable"
				chmod +x $target/$folder/root/${desktop}.sh
				
				echo -e "\n..\n..arch: /:root/.bash_profile: removing"
				rm -rf $target/$folder/root/.bash_profile
				
				echo -e "..arch: /:root/.bash_profile: creating"
				cat <<- EOF > $target/$folder/root/.bash_profile
					#!/usr/bin/env bash
					
					# Executing additional script.
					bash /root/additional.sh
					clear
					
					echo -e "..arch: additional.sh: removing"
					rm -rf /root/additional.sh
					
					# Installing required packages.
					pacman -Syyuu --noconfirm && pacman -S wget sudo screenfetch --noconfirm 
					clear
					
					if [[ ! -f /root/${desktop}.sh ]]; then
						echo -e "..arch: $desktop: ${desktop}.sh: downloading"
					    wget --tries=20 ${rinku[1]}/${rinku[2]} -O /root/${desktop}.sh
					fi
					
					# Executing Desktop Environment Setup file..
					bash /root/${rinku[1]}.sh
					clear
					
					if [[ ! -f /usr/local/bin/vncserver-start ]]; then
					    echo -e "\n..arch: vncserver-start: downloading"
					    wget --tries=20 ${rinku[0]}/vncserver-start -O /usr/local/bin/vncserver-start
					    
					    echo -e "..arch: vncserver-start: allow executable"
					    chmod +x /usr/local/bin/vncserver-start
					    
					    echo -e "\n..arch: vncserver-stop: downloading"
					    wget --tries=20 ${rinku[0]}/vncserver-stop -O /usr/local/bin/vncserver-stop
					    
					    echo -e "..arch: vncserver-stop: allow executable"
					    chmod +x /usr/local/bin/vncserver-stop
					fi
					if [[ ! -f /usr/bin/vncserver ]]; then
					    pacman -S tigervnc --noconfirm > /dev/null
					fi
					clear
					
					echo -e "..arch: firefox: installing"
					pacman -S firefox --noconfirm
					
					echo -e "..arch: $desktop: ${desktop}.sh: removing"
					rm -rf /root/{desktop}.sh
					
					echo -e "..arch: $desktop: .bash_profile: removing"
					rm -rf /root/.bash_profile
					
					# Displaying screenfetch.
					clear && screenfetch -A "Arch Linux" && echo
					sleep 2.4
				EOF
				
				echo -e "..arch: /:root/.bash_profile: allow executable"
				chmod +x $target/$folder/root/.bash_profile
			elif [[ ${select,,} == "window" ]]; then
				local params=$window
				declare -A rinku=(
					[1]="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Pacman"
					[2]="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/WM/Pacman"
				)
				
				echo -e "\n..arch: window: setup of ${window^} VNC"
				echo -e "\n..arch: $window: ${window}.sh: downloading"
				wget --tries=20 ${rinku[2]}/${window}.sh -O $target/$folder/root/${window}.sh
				echo -e "..arch: $window: ${window}.sh: allow executable"
				chmod +x $target/$folder/root/${window}.sh
				
				cat <<- EOF > $target/$folder/root/.bash_profile
					#!/usr/bin/env bash
					
					# Executing additional script.
					bash /root/additional.sh
					clear
					
					echo -e "..arch: additional.sh: removing"
					rm -rf /root/additional.sh
					
					# Installing required packages.
					pacman -Syyuu --noconfirm && pacman -S wget sudo screenfetch --noconfirm
					clear
					
					if [[ ! -f /root/${window}.sh ]]; then
					    echo -e "..arch: $window: ${window}.sh: downloading"
					    wget --tries=20 ${rinku[2]}/${window}.sh -O /root/${window}.sh
					fi
					
					# Executing Window Manager Setup file..
					bash /root/${window}.sh
					clear
					
					if [[ ! -f /usr/bin/vncserver ]]; then
					    pacman -S tigervnc --noconfirm > /dev/null
					fi
					clear
					
					echo -e "..arch: $window: ${window}.sh: removing"
					rm -rf /root/{window}.sh
					
					echo -e "..arch: $window: .bash_profile: removing"
					rm -rf /root/.bash_profile
					
					# Displaying screenfetch.
					clear && screenfetch -A "Arch Linux" && echo
					sleep 2.4
				EOF
				
				echo -e "..arch: $window: .bash_profile: allow executable"
				chmod +x $target/$folder/root/.bash_profile
			fi
		else
			echo -e "\n..\n..arch: /:root/.bash_profile: removing"
			rm -rf $target/$folder/root/.bash_profile
			
			echo -e "..arch: /:root/.bash_profile: creating"
			cat <<- EOF > $target/$folder/root/.bash_profile
				#!/usr/bin/env bash
				
				# Executing additional script.
				bash /root/additional.sh
				clear
				
				echo -e "..arch: additional.sh: removing"
				rm -rf /root/additional.sh
				
				echo -e "..arch: .bash_profile: removing"
				rm -rf /root/.bash_profile
			EOF
			
			echo -e "..arch: .bash_profile: allow executable"
			chmod +x $target/$folder/root/.bash_profile
		fi
		
		sleep 2.4
		clear
		echo -e "\n..\n..arch: $select: installed"
		echo -e "..arch: $select: command"
		echo -e "..arch: $select: arch $select ${params[@]}\n..\n"
		
		echo -e "..arch: action: run arch [Y/n]"
		local inputNext=
		while [[ $inputNext == "" ]]; do
			readline "arch" "next" "Y"
			case ${inputNext,,} in
				y|yes)
					bash $termux/files/usr/bin/$binary $select ${params[@]}
				;;
				n|no) main ;;
				*) inputNext= ;;
			esac
		done
	}
	
	# Handle Arch Remove.
	function archRemove() {
		echo 0
	}
	
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
	
	# Handle input action for arch linux.
	readInputAction "arch" "install"
	case $action in
		cancel) main ;;
		remove)
			archRemove
		;;
		import)
			archImport
			archInstall
		;;
		install)
			archInstall
		;;
	esac
}

# Handle Debian Actions.
function debian() {

	# Default Debian Mode for install.
	local select=cli
	
	# Default Import is always empty.
	# Because we don't know where source destination.
	local import=
	
	# Default Debian Directory.
	local source=$install/debian
	local folder=debian-fs
	
	# Default Debian Executable.
	local binary=debian
	local launch=debian-start
	
	# Default Debian RootFS name.
	local rootfs=debian-rootfs.tar.xz
	
	# Default Debian Window Manager.
	local window=Awesome
	
	# Default Debian Environment for install.
	local desktop=XFCE
	
	# Handle Building Debian Binary.
	function debianBinary() {
		binaryBuilder "debian" $binary $launch $folder $source
	}
	
	# Handle Building Debian Launcher.
	function debianLauncher() {
		echo -e "..\n..debian: $launch: building"
		cat > $target/$launch <<- EOM
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
			command+=" -r $target/$folder"
			
			if [ -n "\$(ls -A $target/debian-binds)" ]; then
			    for f in $target/debian-binds/* ;do
			        . \$f
			    done
			fi
			
			command+=" -b /data"
			command+=" -b /dev"
			command+=" -b /proc"
			command+=" -b $target/$folder/root:/dev/shm"
			
			# Uncomment the following line to have
			# access to the home directory of termux.
			#command+=" -b $termux/files/home:/root"
			
			# Uncomment the following line to
			# mount /sdcard directly to /.
			#command+=" -b /sdcard"
			
			command+=" -w /root"
			command+=" /usr/bin/env -i"
			command+=" HOME=/root"
			command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
			command+=" TERM=\$TERM"
			command+=" LANG=C.UTF-8"
			command+=" /bin/bash --login"
			
			if [ -z "\$1" ];then
			    exec \$command
			else
			    \$command -c "\$com"
			fi
		EOM
		
		echo -e "..debian: $launch: fixing shebang"
		termux-fix-shebang $target/$launch
		
		echo -e "..debian: $launch: allow executable"
		chmod +x $target/$launch
	}
	
	# Handle Debian Import.
	function debianImport() {
		echo 0
	}
	
	# Handle Debian Install.
	function debianInstall() {

		# Resolve Debian Source Destination.
		case $select in
			cli) local target=$source/cli ;;
			window) local target=$source/window/$window ;;
			desktop) local target=$source/desktop/$desktop ;;
			*)
				echo -e "..debian: $select: unknown selection mode"
				exit 1
			;;
		esac
		
		# Check if file system does not exists.
		if [[ ! -d $target/$folder ]]; then
			if [[ ! -f $images/$rootfs ]]; then
				case ${architect,,} in
					aarch64) local archurl="arm64" ;;
					arm) local archurl="armhf" ;;
					amd64) local archurl="amd64" ;;
					x86_64) local archurl="amd64" ;;	
					i*86) local archurl="i386" ;;
					x86) local archurl="i386" ;;
					*)
						echo -e "..debian: $architect: unsupported architecture"
						exit 1
					;;
				esac
				echo -e "\n..debian: $rootfs: downloading"
				wget --tries=20 "https://github.com/Techriz/AndronixOrigin/blob/master/Rootfs/Debian/${archurl}/debian-rootfs-${archurl}.tar.xz?raw=true" -O $images/$rootfs
				clear
			fi
			
			echo -e "\n..debian: $folder: creating"
			mkdir -p $target/$folder
			
			echo -e "..debian: $rootfs: decompressing"
			proot --link2symlink tar -xJf $images/$rootfs --exclude=dev -C $target/$folder||:
			
			echo -e "..debian: $rootfs: remove [Y/n]"
			local inputRemove=
			while [[ $inputRemove == "" ]]; do
				readline "debian" "remove" "Y"
				case ${inputRemove,,} in
					y|yes)
						echo -e "\n..debian: $rootfs: removing"
						rm -rf $images/$rootfs
					;;
					n|no) ;;
					*)
						inputRemove=
					;;
				esac
			done
			clear
		fi
		
		echo -e "..debian: debian-binds: creating"
		mkdir -p $target/debian-binds
		
		# Check if Debian binary doesn't exists.
		if [[ ! -f $termux/files/usr/bin/$binary ]]; then
			debianBinary
		fi
		
		# Check if Debian launcher script doesn't exists.
		if [[ ! -f $target/$launch ]]; then
			debianLauncher
		fi
		
		local params=
		if [[ ${select,,} != "cli" ]]; then
			if [[ ${select,,} == "desktop" ]]; then
				local params=$desktop
				case ${desktop,,} in
					xfce)
						local rinku=(
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT/XFCE4"
							"xfce4_de.sh"
						)
					;;
					lxqt)
						local rinku=(
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT/LXQT"
							"lxqt_de.sh"
						)
					;;
					lxde)
						local rinku=(
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT/LXDE"
							"lxde_de.sh"
						)
					;;
				esac
				
				echo -e "\n..debian: desktop: setup of ${desktop^^} VNC"
				echo -e "\n..debian: $desktop: $desktop: setup apt retry count"
				echo "APT::Acquire::Retries \"3\";" > $target/$folder/etc/apt/apt.conf.d/80-retries
				
				echo -e "..debian: $desktop: ${desktop}.sh: downloading"
				wget --tries=20 ${rinku[0]}/${rinku[1]} -O $target/$folder/root/${desktop}.sh
				echo -e "..debian: $desktop: ${desktop}.sh: allow executable"
				chmod +x $target/$folder/root/${desktop}.sh
				
				echo -e "..debian: $desktop: /:root/.bash_profile: removing"
				rm -rf $target/$folder/root/.bash_profile
				
				echo -e "..debian: $desktop: /:root/.bash_profile: creating"
				cat <<- EOF > $target/$folder/root/.bash_profile
					#!/usr/bin/env bash
					
					# Updating packages.
					apt update -y
					
					# Installing required packages.
					apt install sudo nano wget bash screenfetch -y
					clear
					
					if [[ ! -f /root/${desktop}.sh ]]; then
						echo -e "..debian: $desktop: ${desktop}.sh: downloading"
					    wget --tries=20 ${rinku[0]}/${rinku[1]} -O /root/${desktop}.sh
					fi
					
					# Executing Desktop Environment Setup file..
					bash /root/${desktop}.sh
					clear
					
					if [[ ! -f /usr/local/bin/vncserver-start ]]; then
					    echo -e "\n..debian: vncserver-start: downloading"
					    wget --tries=20 ${rinku[0]}/vncserver-start -O /usr/local/bin/vncserver-start
					    
					    echo -e "..debian: vncserver-start: allow executable"
					    chmod +x /usr/local/bin/vncserver-start
					fi
					if [[ ! -f /usr/local/bin/vncserver-stop ]]; then
					    echo -e "\n..debian: vncserver-stop: downloading"
					    wget --tries=20 ${rinku[0]}/vncserver-stop -O /usr/local/bin/vncserver-stop
					    
					    echo -e "..debian: vncserver-stop: allow executable"
					    chmod +x /usr/local/bin/vncserver-stop
					fi
					if [[ ! -f /usr/bin/vncserver ]]; then
					    apt install tigervnc-standalone-server -y
					fi
					clear
					
					echo -e "..debian: firefox: installing"
					apt install firefox-esr -y
					
					echo -e "..debian: $desktop: ${desktop}.sh: removing"
					rm -rf /root/{desktop}.sh
					
					echo -e "..debian: $desktop: .bash_profile: removing"
					rm -rf /root/.bash_profile
					
					# Displaying screenfetch.
					clear && screenfetch -A "Debian" && echo
					sleep 2.4
				EOF
				
				echo -e "..debian: $desktop: /:root/.bash_profile: allow executable"
				chmod +x $target/$folder/root/.bash_profile
			elif [[ ${select,,} == "window" ]]; then
				local params=$window
				declare -A rinku=(
					[1]="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT"
					[2]="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/WM/APT"
				)
				
				echo -e "\n..debian: window: setup of ${window^} VNC"
				echo -e "\n..debian: $window: $window: setup apt retry count"
				echo "APT::Acquire::Retries \"3\";" > $target/$folder/etc/apt/apt.conf.d/80-retries
				
				echo -e "..debian: $window: ${window}.sh: downloading"
				wget --tries=20 ${rinku[2]}/${window}.sh -O $target/$folder/root/${window}.sh
				echo -e "..debian: $window: ${window}.sh: allow executable"
				chmod +x $target/$folder/root/${window}.sh
				
				echo -e "..debian: $window: /:root/.bash_profile: removing"
				rm -rf $target/$folder/root/.bash_profile
				
				echo -e "..debian: $window: /:root/.bash_profile: creating"
				cat <<- EOF > $target/$folder/root/.bash_profile
					#!/usr/bin/env bash
					
					# Updating packages.
					apt update -y
					
					# Installing required packages.
					apt install sudo nano bash wget screenfetch -y
					clear
					
					if [[ ! -f /root/${window}.sh ]]; then
					    echo -e "..debian: $window: ${window}.sh: downloading"
					    wget --tries=20 ${rinku[2]}/${window}.sh -O /root/${window}.sh
					fi
					
					# Executing Window Manager Setup file..
					bash /root/${window}.sh
					clear
					
					if [[ ! -f /usr/bin/vncserver ]]; then
					    apt install tigervnc-standalone-server -y
					fi
					clear
					
					echo -e "..debian: $window: ${window}.sh: removing"
					rm -rf /root/{window}.sh
					
					echo -e "..debian: $window: .bash_profile: removing"
					rm -rf /root/.bash_profile
					
					# Displaying screenfetch.
					clear && screenfetch -A "Debian" && echo
					sleep 2.4
				EOF
				
				echo -e "..debian: $window: .bash_profile: allow executable"
				chmod +x $target/$folder/root/.bash_profile
			fi
		fi
		
		sleep 2.4
		clear
		echo -e "\n..\n..debian: $select: installed"
		echo -e "..debian: $select: command"
		echo -e "..debian: $select: debian $select ${params[@]}\n..\n"
		
		echo -e "..debian: action: run debian [Y/n]"
		local inputNext=
		while [[ $inputNext == "" ]]; do
			readline "debian" "next" "Y"
			case ${inputNext,,} in
				y|yes)
					bash $termux/files/usr/bin/$binary $select ${params[@]}
				;;
				n|no) main ;;
				*) inputNext= ;;
			esac
		done
	}
	
	# Handle Debian Remove.
	function debianRemove() {
		echo 0
	}
	
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
	
	# Handle input action for debian.
	readInputAction "debian" "install"
	case $action in
		cancel) main ;;
		remove)
			debianRemove ;;
		import)
			debianImport
			debianInstall
		;;
		install)
			debianInstall
		;;
	esac
}

# Handle Fedora Actions.
function fedora() {

	# Default Fedora Mode for install.
	local select=cli
	
	# Default Import is always empty.
	# Because we don't know where source destination.
	local import=
	
	# Default Fedora Directory.
	local source=$install/fedora
	local folder=fedora-fs
	
	# Default Fedora Executable.
	local binary=fedora
	local launch=fedora-start
	
	# Default Fedora RootFS name.
	local rootfs=fedora-rootfs.tar.xz
	
	# Default Fedora Window Manager.
	local window=Awesome
	
	# Default Fedora Environment for install.
	local desktop=XFCE
	
	# Handle Building Fedora Binary.
	function fedoraBinary() {
		binaryBuilder "fedora" $binary $launch $folder $source
	}
	
	# Handle Building Fedora Launcher.
	function fedoraLauncher() {
		echo -e "..\n..fedora: $launch: building"
		cat > $target/$launch <<- EOM
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
			command+=" -r $target/$folder"
			
			if [ -n "\$(ls -A $target/fedora-binds)" ]; then
			    for f in $target/fedora-binds/* ;do
			        . \$f
			    done
			fi
			
			command+=" -b /dev"
			command+=" -b /proc"
			command+=" -b $target/$folder/root:/dev/shm"
			
			# Uncomment the following line to have access to the home directory of termux
			#command+=" -b $termux/files/home:/root"
			
			# Uncomment the following line to
			# mount /sdcard directly to /.
			#command+=" -b /sdcard"
			
			command+=" -w /root"
			command+=" /usr/bin/env -i"
			command+=" HOME=/root"
			command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
			command+=" TERM=\$TERM"
			command+=" LANG=C.UTF-8"
			command+=" /bin/bash --login"
			com="\$@"
			
			if [ -z "\$1" ];then
			    exec \$command
			else
			    \$command -c "\$com"
			fi
		EOM
		
		echo -e "..fedora: $launch: fixing shebang"
		termux-fix-shebang $target/$launch
		
		echo -e "..fedora: $launch: allow executable"
		chmod +x $target/$launch
	}
	
	# Handle Fedora Import.
	function fedoraImport() {
		echo 0
	}
	
	# Handle Fedora Install.
	function fedoraInstall() {

		# Resolve Fedora Source Destination.
		case $select in
			cli) local target=$source/cli ;;
			window) local target=$source/window/$window ;;
			desktop) local target=$source/desktop/$desktop ;;
			*)
				echo -e "..fedora: $select: unknown selection mode"
				exit 1
			;;
		esac
		
		# Check if file system does not exists.
		if [[ ! -d $target/$folder ]]; then
			if [[ ! -f $images/$rootfs ]]; then
				if [[ ${architect,,} == "aarch64" ]]; then
					
					echo -e "..fedora: /:.rootfs/fedora: creating"
					mkdir -p $images/fedora
					
					if [[ ! -f $images/fedora/fedora.partaa ]]; then
						echo -e "\n..fedora: fedora.partaa: downloading"
						wget --tries=20 "https://github.com/AndronixApp/AndronixOrigin/raw/master/Rootfs/Fedora/arm64/fedora.partaa" -O $images/fedora/fedora.partaa
					fi
					if [[ ! -f $images/fedora/fedora.partab ]]; then
						echo -e "\n..fedora: fedora.partab: downloading"
						wget --tries=20 "https://github.com/AndronixApp/AndronixOrigin/raw/master/Rootfs/Fedora/arm64/fedora.partab" -O $images/fedora/fedora.partab
					fi
					clear
					
					echo -e "\n..fedora: $rootfs: building"
					cat $images/fedora/fedora.parta* > $images/fedora/fedora-rootfs.tar.xz
					
					echo -e "..fedora: fedora.parta[a-b]: remove [Y/n]"
					local inputRemove=
					while [[ $inputRemove == "" ]]; do
						readline "fedora" "remove" "Y"
						case ${inputRemove,,} in
							y|yes)
								echo -e "\n..fedora: fedora.parta[a-b]: removing"
								rm -rf $images/fedora/fedora.parta*
							;;
							n|no) ;;
							*)
								inputRemove=
							;;
						esac
					done
					clear
				else
					case ${architect,,} in
						arm) local archurl="armhf" ;;
						amd64) local archurl="amd64" ;;
						x86_64) local archurl="amd64" ;;
						*)
							echo -e "..fedora: $architect: unsupported architecture"
							exit 1
						;;
					esac
					echo -e "\n..fedora: $rootfs: downloading"
					wget --tries=20 "https://github.com/Techriz/AndronixOrigin/blob/master/Rootfs/Fedora/${archurl}/fedora-rootfs-${archurl}.tar.xz?raw=true" -O $images/$rootfs
					clear
				fi
			fi
			
			echo -e "\n..fedora: $folder: creating"
			mkdir -p $target/$folder
			
			echo -e "..fedora: $rootfs: decompressing"
			proot --link2symlink tar -xJf $images/$rootfs --exclude=dev -C $target/$folder||:
			
			echo -e "..fedora: $rootfs: remove [Y/n]"
			local inputRemove=
			while [[ $inputRemove == "" ]]; do
				readline "fedora" "remove" "Y"
				case ${inputRemove,,} in
					y|yes)
						echo -e "\n..fedora: $rootfs: removing"
						rm -rf $images/$rootfs
					;;
					n|no) ;;
					*)
						inputRemove=
					;;
				esac
			done
			clear
		fi
		
		# Resolve Fedora name server.
		case ${archurl,,} in
			armhf|amd64|amd64)
				echo -e "fedora: setup: Setting up name server"
				
				echo -e "fedora: /:etc/hosts: creating"
				echo "127.0.0.1 localhost" > $target/$folder/etc/hosts
				
				echo -e "fedora: /:etc/resolv.conf: creating"
				echo "nameserver 8.8.8.8" > $target/$folder/etc/resolv.conf
				echo "nameserver 8.8.4.4" >> $target/$folder/etc/resolv.conf
			;;
		esac
		
		echo -e "..fedora: fedora-binds: creating"
		mkdir -p $target/fedora-binds
		
		# Check if Fedora binary doesn't exists.
		if [[ ! -f $termux/files/usr/bin/$binary ]]; then
			fedoraBinary
		fi
		
		# Check if Fedora launcher script doesn't exists.
		if [[ ! -f $target/$launch ]]; then
			fedoraLauncher
		fi
		
		local params=
		if [[ ${select,,} != "cli" ]]; then
			if [[ ${select,,} == "desktop" ]]; then
				local params=$desktop
				case ${desktop,,} in
					xfce)
						local rinku=(
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Fedora/XFCE4"
							"xfce4_de.sh"
						)
					;;
					lxqt)
						local rinku=(
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Fedora/LXQT"
							"lxqt_de.sh"
						)
					;;
					lxde)
						local rinku=(
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Fedora/LXDE"
							"lxde_de.sh"
						)
					;;
				esac
				
				echo -e "\n..fedora: desktop: setup of ${desktop^^} VNC"
				echo -e "\n..fedora: $desktop: ${desktop}.sh: downloading"
				wget --tries=20 ${rinku[0]}/${rinku[1]} -O $target/$folder/root/${desktop}.sh
				echo -e "..fedora: $desktop: ${desktop}.sh: allow executable"
				chmod +x $target/$folder/root/${desktop}.sh
				
				echo -e "\n..\n..fedora: /:root/.bash_profile: removing"
				rm -rf $target/$folder/root/.bash_profile
				
				echo -e "..fedora: /:root/.bash_profile: creating"
				cat <<- EOF > $target/$folder/root/.bash_profile
					#!/usr/bin/env bash
					
					# Installing required packages.
					yum install wget screenfetch -y
					clear
					
					if [[ ! -f /root/${desktop}.sh ]]; then
						echo -e "..fedora: $desktop: ${desktop}.sh: downloading"
					    wget --tries=20 ${rinku[0]}/${rinku[1]} -O /root/${desktop}.sh
					fi
					
					# Executing Desktop Environment Setup file..
					bash /root/${desktop}.sh
					clear
					
					if [[ ! -f /usr/local/bin/vncserver-start ]]; then
					    echo -e "\n..fedora: vncserver-start: downloading"
					    wget --tries=20 ${rinku[0]}/vncserver-start -O /usr/local/bin/vncserver-start
					    
					    echo -e "..fedora: vncserver-start: allow executable"
					    chmod +x /usr/local/bin/vncserver-start
					    
					    echo -e "\n..fedora: vncserver-stop: downloading"
					    wget --tries=20 ${rinku[0]}/vncserver-stop -O /usr/local/bin/vncserver-stop
					    
					    echo -e "..fedora: vncserver-stop: allow executable"
					    chmod +x /usr/local/bin/vncserver-stop
					fi
					if [[ ! -f /usr/bin/vncserver ]]; then
					    yum install tigervnc-server -y
					fi
					clear
					
					echo -e "..fedora: firefox: installing"
					yum install firefox -y
					
					echo -e "..fedora: $desktop: ${desktop}.sh: removing"
					rm -rf /root/{desktop}.sh
					
					echo -e "..fedora: $desktop: .bash_profile: removing"
					rm -rf /root/.bash_profile
					
					# Displaying screenfetch.
					clear && screenfetch -A "Fedora" && echo
					sleep 2.4
				EOF
				
				echo -e "..fedora: /:root/.bash_profile: allow executable"
				chmod +x $target/$folder/root/.bash_profile
			elif [[ ${select,,} == "window" ]]; then
				local params=$window
				declare -A rinku=(
					[1]="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/DNF"
					[2]="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/WM/DNF"
				)
				
				echo -e "\n..fedora: window: setup of ${window^} VNC"
				echo -e "\n..fedora: $window: ${window}.sh: downloading"
				wget --tries=20 ${rinku[2]}/${window}.sh -O $target/$folder/root/${window}.sh
				echo -e "..fedora: $window: ${window}.sh: allow executable"
				chmod +x $target/$folder/root/${window}.sh
				
				cat <<- EOF > $target/$folder/root/.bash_profile
					#!/usr/bin/env bash
					
					# Installing required packages.
					dnf install wget nano screenfetch -y
					clear
					
					if [[ ! -f /root/${window}.sh ]]; then
					    echo -e "..fedora: $window: ${window}.sh: downloading"
					    wget --tries=20 ${rinku[2]}/${window}.sh -O /root/${window}.sh
					fi
					
					# Executing Window Manager Setup file..
					bash /root/${window}.sh
					clear
					
					if [[ ! -f /usr/bin/vncserver ]]; then
					    dnf install tigervnc-server -y
					fi
					clear
					
					echo -e "..fedora: $window: ${window}.sh: removing"
					rm -rf /root/{window}.sh
					
					echo -e "..fedora: $window: .bash_profile: removing"
					rm -rf /root/.bash_profile
					
					# Displaying screenfetch.
					clear && screenfetch -A "Fedora" && echo
					sleep 2.4
				EOF
				
				echo -e "..fedora: $window: .bash_profile: allow executable"
				chmod +x $target/$folder/root/.bash_profile
			fi
		fi
		
		sleep 2.4
		clear
		echo -e "\n..\n..fedora: $select: installed"
		echo -e "..fedora: $select: command"
		echo -e "..fedora: $select: fedora $select ${params[@]}\n..\n"
		
		echo -e "..fedora: action: run fedora [Y/n]"
		local inputNext=
		while [[ $inputNext == "" ]]; do
			readline "fedora" "next" "Y"
			case ${inputNext,,} in
				y|yes)
					bash $termux/files/usr/bin/$binary $select ${params[@]}
				;;
				n|no) main ;;
				*) inputNext= ;;
			esac
		done
	}
	
	# Handle Fedora Remove.
	function fedoraRemove() {
		echo 0
	}
	
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
	
	# Handle input action for Fedora.
	readInputAction "fedora" "install"
	
	case $action in
		cancel) main ;;
		remove)
			fedoraRemove
		;;
		import)
			fedoraImport
			fedoraInstall
		;;
		install)
			fedoraInstall
		;;
	esac
}

# Handle Kali Actions.
function kali() {

	# Default Kali Mode for install.
	local select=cli
	
	# Default Import is always empty.
	# Because we don't know where source destination.
	local import=
	
	# Default Kali Directory.
	local source=$install/kali
	local folder=kali-fs
	
	# Default Kali Executable.
	local binary=kali
	local launch=kali-start
	
	# Default Kali RootFS name.
	local rootfs=kali-rootfs.tar.xz
	
	# Default Kali Window Manager.
	local window=Awesome
	
	# Default Kali Environment for install.
	local desktop=XFCE
	
	# Handle Building Kali Binary.
	function kaliBinary() {
		binaryBuilder "kali" $binary $launch $folder $source
	}
	
	# Handle Building Kali Launcher.
	function kaliLauncher() {
		echo -e "..\n..kali: $launch: building"
		cat > $target/$launch <<- EOM
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
			command+=" -r $target/$folder"
			
			if [ -n "\$(ls -A $target/kali-binds)" ]; then
			    for f in $target/kali-binds/* ;do
			        . \$f
			    done
			fi
			
			command+=" -b /data"
			command+=" -b /dev"
			command+=" -b /proc"
			command+=" -b $target/$folder/root:/dev/shm"
			
			# Uncomment the following line to have
			# access to the home directory of termux.
			#command+=" -b $termux/files/home:/root"
			
			# Uncomment the following line to
			# mount /sdcard directly to /.
			#command+=" -b /sdcard"
			
			command+=" -w /root"
			command+=" /usr/bin/env -i"
			command+=" HOME=/root"
			command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
			command+=" TERM=\$TERM"
			command+=" LANG=C.UTF-8"
			command+=" /bin/bash --login"
			
			if [ -z "\$1" ];then
			    exec \$command
			else
			    \$command -c "\$com"
			fi
		EOM
		
		echo -e "..kali: $launch: fixing shebang"
		termux-fix-shebang $target/$launch
		
		echo -e "..kali: $launch: allow executable"
		chmod +x $target/$launch
	}
	
	# Handle Kali Import.
	function kaliImport() {
		echo 0
	}
	
	# Handle Kali Install.
	function kaliInstall() {

		# Resolve Kali Source Destination.
		case $select in
			cli) local target=$source/cli ;;
			window) local target=$source/window/$window ;;
			desktop) local target=$source/desktop/$desktop ;;
			*)
				echo -e "..kali: $select: unknown selection mode"
				exit 1
			;;
		esac
		
		# Check if file system does not exists.
		if [[ ! -d $target/$folder ]]; then
			if [[ ! -f $images/$rootfs ]]; then
				case ${architect,,} in
					aarch64) local archurl="arm64" ;;
					arm) local archurl="armhf" ;;
					amd64) local archurl="amd64" ;;
					x86_64) local archurl="amd64" ;;	
					i*86) local archurl="i386" ;;
					x86) local archurl="i386" ;;
					*)
						echo -e "..kali: $architect: unsupported architecture"
						exit 1
					;;
				esac
				echo -e "\n..kali: $rootfs: downloading"
				if [[ $archurl == "arm64" ]]; then
					wget --tries=20 "https://github.com/AndronixApp/AndronixOrigin/releases/download/kali-arm64-tarball/kali-rootfs-arm64.tar.xz" -O $images/$rootfs
				else
					wget --tries=20 "https://github.com/Techriz/AndronixOrigin/blob/master/Rootfs/Kali/${archurl}/kali-rootfs-${archurl}.tar.xz?raw=true" -O $images/$rootfs
				fi
				clear
			fi
			
			echo -e "\n..kali: $folder: creating"
			mkdir -p $target/$folder
			
			echo -e "..kali: $rootfs: decompressing"
			proot --link2symlink tar -xJf $images/$rootfs --exclude=dev -C $target/$folder||:
			
			echo -e "..kali: $rootfs: remove [Y/n]"
			local inputRemove=
			while [[ $inputRemove == "" ]]; do
				readline "kali" "remove" "Y"
				case ${inputRemove,,} in
					y|yes)
						echo -e "\n..kali: $rootfs: removing"
						rm -rf $images/$rootfs
					;;
					n|no) ;;
					*)
						inputRemove=
					;;
				esac
			done
			clear
		fi
		
		echo -e "..kali: kali-binds: creating"
		mkdir -p $target/kali-binds
		
		echo -e "..kali: /:etc/apt/sources.list: patching mirroslist"
		echo "deb [trusted=yes] http://http.kali.org/kali kali-rolling main contrib non-free" > $target/$folder/etc/apt/sources.list
		
		echo -e "..kali: kali-archive-keyring.asc: downloading"
		wget --tries=20 "https://archive.kali.org/archive-key.asc" -O $target/$folder/etc/apt/trusted.gpg.d/kali-archive-keyring.asc
		
		# Check if Kali binary doesn't exists.
		if [[ ! -f $termux/files/usr/bin/$binary ]]; then
			kaliBinary
		fi
		
		# Check if Kali launcher script doesn't exists.
		if [[ ! -f $target/$launch ]]; then
			kaliLauncher
		fi
		
		local params=
		if [[ ${select,,} != "cli" ]]; then
			if [[ ${select,,} == "desktop" ]]; then
				local params=$desktop
				case ${desktop,,} in
					xfce)
						local rinku=(
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT/XFCE4"
							"xfce4_de.sh"
						)
					;;
					lxqt)
						local rinku=(
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT/LXQT"
							"lxqt_de.sh"
						)
					;;
					lxde)
						local rinku=(
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT/LXDE"
							"lxde_de.sh"
						)
					;;
				esac
				
				echo -e "\n..kali: desktop: setup of ${desktop^^} VNC"
				echo -e "\n..kali: $desktop: $desktop: setup apt retry count"
				echo "APT::Acquire::Retries \"3\";" > $target/$folder/etc/apt/apt.conf.d/80-retries
				
				echo -e "..kali: $desktop: ${desktop}.sh: downloading"
				wget --tries=20 ${rinku[0]}/${rinku[1]} -O $target/$folder/root/${desktop}.sh
				echo -e "..kali: $desktop: ${desktop}.sh: allow executable"
				chmod +x $target/$folder/root/${desktop}.sh
				
				echo -e "..kali: $desktop: /:root/.bash_profile: removing"
				rm -rf $target/$folder/root/.bash_profile
				
				echo -e "..kali: $desktop: /:root/.bash_profile: creating"
				cat <<- EOF > $target/$folder/root/.bash_profile
					#!/usr/bin/env bash
					
					# Add key for avoid outdated GPG Key alert.
					echo -e "..kali: kali-archive-keyring.asc: adding gpg key"
					apt-key add /etc/apt/trusted.gpg.d/kali-archive-keyring.asc
					
					# Updating packages.
					apt update -y
					
					# Installing required packages.
					apt install sudo nano wget bash screenfetch dbus-x11 -y
					clear
					
					if [[ ! -f /root/${desktop}.sh ]]; then
						echo -e "..kali: $desktop: ${desktop}.sh: downloading"
					    wget --tries=20 ${rinku[0]}/${rinku[1]} -O /root/${desktop}.sh
					fi
					
					# Executing Desktop Environment Setup file..
					bash /root/${desktop}.sh
					clear
					
					if [[ ! -f /usr/local/bin/vncserver-start ]]; then
					    echo -e "\n..kali: vncserver-start: downloading"
					    wget --tries=20 ${rinku[0]}/vncserver-start -O /usr/local/bin/vncserver-start
					    
					    echo -e "..kali: vncserver-start: allow executable"
					    chmod +x /usr/local/bin/vncserver-start
					    
					    echo -e "\n..kali: vncserver-stop: downloading"
					    wget --tries=20 ${rinku[0]}/vncserver-stop -O /usr/local/bin/vncserver-stop
					    
					    echo -e "..kali: vncserver-stop: allow executable"
					    chmod +x /usr/local/bin/vncserver-stop
					fi
					if [[ ! -f /usr/bin/vncserver ]]; then
					    apt install tigervnc-standalone-server -y
					fi
					clear
					
					echo -e "..kali: firefox: installing"
					apt install firefox-esr -y
					
					echo -e "..kali: $desktop: ${desktop}.sh: removing"
					rm -rf /root/{desktop}.sh
					
					echo -e "..kali: $desktop: .bash_profile: removing"
					rm -rf /root/.bash_profile
					
					# Displaying screenfetch.
					clear && screenfetch -A "Kali Linux" && echo
					sleep 2.4
				EOF
				
				echo -e "..kali: $desktop: /:root/.bash_profile: allow executable"
				chmod +x $target/$folder/root/.bash_profile
			elif [[ ${select,,} == "window" ]]; then
				local params=$window
				declare -A rinku=(
					[1]="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT"
					[2]="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/WM/APT"
				)
				
				echo -e "\n..kali: window: setup of ${window^} VNC"
				echo -e "\n..kali: $window: $window: setup apt retry count"
				echo "APT::Acquire::Retries \"3\";" > $target/$folder/etc/apt/apt.conf.d/80-retries
				
				echo -e "..kali: $window: ${window}.sh: downloading"
				wget --tries=20 ${rinku[2]}/${window}.sh -O $target/$folder/root/${window}.sh
				echo -e "..kali: $window: ${window}.sh: allow executable"
				chmod +x $target/$folder/root/${window}.sh
				
				echo -e "..kali: $window: /:root/.bash_profile: removing"
				rm -rf $target/$folder/root/.bash_profile
				
				echo -e "..kali: $window: /:root/.bash_profile: creating"
				cat <<- EOF > $target/$folder/root/.bash_profile
					#!/usr/bin/env bash
					
					# Add key for avoid outdated GPG Key alert.
					echo -e "..kali: kali-archive-keyring.asc: adding gpg key"
					apt-key add /etc/apt/trusted.gpg.d/kali-archive-keyring.asc
					
					# Updating packages.
					apt update -y
					
					# Installing required packages.
					apt install sudo nano bash wget screenfetch -y
					clear
					
					if [[ ! -f /root/${window}.sh ]]; then
					    echo -e "..kali: $window: ${window}.sh: downloading"
					    wget --tries=20 ${rinku[2]}/${window}.sh -O /root/${window}.sh
					fi
					
					# Executing Window Manager Setup file..
					bash /root/${window}.sh
					clear
					
					if [[ ! -f /usr/bin/vncserver ]]; then
					    apt install tigervnc-standalone-server -y
					fi
					clear
					
					echo -e "..kali: $window: ${window}.sh: removing"
					rm -rf /root/{window}.sh
					
					echo -e "..kali: $window: .bash_profile: removing"
					rm -rf /root/.bash_profile
					
					# Displaying screenfetch.
					clear && screenfetch -A "Kali Linux" && echo
					sleep 2.4
				EOF
				
				echo -e "..kali: $window: .bash_profile: allow executable"
				chmod +x $target/$folder/root/.bash_profile
			fi
			
			echo -e "..kali: $select: /:root/.bash_logout: creating"
			cat <<- EOF > $target/$folder/root/.bash_logout
				#!/usr/bin/env bash
				
				# Stopping VNC Server.
				vncserver-stop
				
				# Kill all dbus and ssh process.
				pkill dbus*
				pkill ssh*
			EOF
			
			echo -e "..kali: $select: .bash_logout: allow executable"
			chmod +x $target/$folder/root/.bash_logout
		else
			echo -e "\n..\n..kali: /:root/.bash_profile: removing"
			rm -rf $target/$folder/root/.bash_profile
			
			echo -e "..kali: /:root/.bash_profile: creating"
			cat <<- EOF > $target/$folder/root/.bash_profile
				#!/usr/bin/env bash
				
				# Add key for avoid outdated GPG Key alert.
				echo -e "..kali: kali-archive-keyring.asc: adding gpg key"
				apt-key add /etc/apt/trusted.gpg.d/kali-archive-keyring.asc
				
				echo -e "..kali: .bash_profile: removing"
				rm -rf /root/.bash_profile
			EOF
			
			echo -e "..kali: .bash_profile: allow executable"
			chmod +x $target/$folder/root/.bash_profile
		fi
		
		sleep 2.4
		clear
		echo -e "\n..\n..kali: $select: installed"
		echo -e "..kali: $select: command"
		echo -e "..kali: $select: kali $select ${params[@]}\n..\n"
		
		echo -e "..kali: action: run kali [Y/n]"
		local inputNext=
		while [[ $inputNext == "" ]]; do
			readline "kali" "next" "Y"
			case ${inputNext,,} in
				y|yes)
					bash $termux/files/usr/bin/$binary $select ${params[@]}
				;;
				n|no) main ;;
				*) inputNext= ;;
			esac
		done
	}
	
	# Handle Kali Remove.
	function kaliRemove() {
		echo 0
	}
	
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
	
	# Handle input action for kali linux.
	readInputAction "kali" "install"
	case $action in
		cancel) main ;;
		remove)
			kaliRemove
		;;
		import)
			kaliImport
			kaliInstall
		;;
		install)
			kaliInstall
		;;
	esac
}

# Handle Manjaro Actions.
function manjaro() {

	# Default Manjaro Mode for install.
	local select=cli
	
	# Default Import is always empty.
	# Because we don't know where source destination.
	local import=
	
	# Default Manjaro Directory.
	local source=$install/manjaro
	local folder=manjaro-fs
	
	# Default Manjaro Executable.
	local binary=manjaro
	local launch=manjaro-start
	
	# Default Manjaro RootFS name.
	local rootfs=manjaro-rootfs.tar.xz
	
	# Default Manjaro Window Manager.
	local window=Awesome
	
	# Default Manjaro Environment for install.
	local desktop=XFCE
	
	# Handle Building Manjaro Binary.
	function manjaroBinary() {
		binaryBuilder "manjaro" $binary $launch $folder $source
	}
	
	# Handle Building Manjaro Launcher.
	function manjaroLauncher() {
		echo -e "..\n..manjaro: $launch: building"
		cat > $target/$launch <<- EOM
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
			command+=" -r $target/$folder"
			
			if [ -n "\$(ls -A $target/manjaro-binds)" ]; then
			    for f in $target/manjaro-binds/* ;do
			        . \$f
			    done
			fi
			
			command+=" -b /data"
			command+=" -b /dev"
			command+=" -b /proc"
			command+=" -b $target/$folder/root:/dev/shm"
			
			# Uncomment the following line to have
			# access to the home directory of termux.
			#command+=" -b $termux/files/home:/root"
			
			# Uncomment the following line to
			# mount /sdcard directly to /.
			#command+=" -b /sdcard"
			
			command+=" -w /root"
			command+=" /usr/bin/env -i"
			command+=" HOME=/root"
			command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
			command+=" TERM=\$TERM"
			command+=" LANG=en_US.UTF-8"
			command+=" LC_ALL=C"
			command+=" LANGUAGE=en_US"
			command+=" /bin/bash --login"
			
			if [ -z "\$1" ];then
			    exec \$command
			else
			    \$command -c "\$com"
			fi
		EOM
		
		echo -e "..manjaro: $launch: fixing shebang"
		termux-fix-shebang $target/$launch
		
		echo -e "..manjaro: $launch: allow executable"
		chmod +x $target/$launch
	}
	
	# Handle Manjaro Import.
	function manjaroImport() {
		echo 0
	}
	
	# Handle Manjaro Install.
	function manjaroInstall() {

		# Resolve Manjaro Source Destination.
		case $select in
			cli) local target=$source/cli ;;
			window) local target=$source/window/$window ;;
			desktop) local target=$source/desktop/$desktop ;;
			*)
				echo -e "..manjaro: $select: unknown selection mode"
				exit 1
			;;
		esac
		
		# Check if file system does not exists.
		if [[ ! -d $target/$folder ]]; then
			if [[ ! -f $images/$rootfs ]]; then
				
				echo -e "..manjaro: /:.rootfs/manjaro: creating"
				mkdir -p $images/manjaro
				
				if [[ ! -f $images/manjaro/manjaro.partaa ]]; then
					echo -e "\n..manjaro: manjaro.partaa: downloading"
					wget --tries=20 https://github.com/AndronixApp/AndronixOrigin/raw/master/Rootfs/Manjaro/manjaro.partaa -O $images/manjaro/manjaro.partaa
				fi
				if [[ ! -f $images/manjaro/manjaro.partab ]]; then
					echo -e "\n..manjaro: manjaro.partab: downloading"
					wget --tries=20 https://github.com/AndronixApp/AndronixOrigin/raw/master/Rootfs/Manjaro/manjaro.partab -O $images/manjaro/manjaro.partab
				fi
					if [[ ! -f $images/manjaro/manjaro.partac ]]; then
				echo -e "\n..manjaro: manjaro.partac: downloading"
					wget --tries=20 https://github.com/AndronixApp/AndronixOrigin/raw/master/Rootfs/Manjaro/manjaro.partac -O $images/manjaro/manjaro.partac
				fi
				clear
				
				echo -e "\n..manjaro: $rootfs: building"
				cat $images/manjaro/manjaro.parta* > $images/$rootfs
				
				echo -e "..manjaro: manjaro.parta[a-c]: remove [Y/n]"
				local inputRemove=
				while [[ $inputRemove == "" ]]; do
					readline "manjaro" "remove" "Y"
					case ${inputRemove,,} in
						y|yes)
							echo -e "\n..manjaro: manjaro.parta[a-b]: removing"
							rm -rf $images/manjaro/manjaro.parta*
						;;
						n|no) ;;
						*)
							inputRemove=
						;;
					esac
				done
				clear
			fi
			
			echo -e "\n..manjaro: $folder: creating"
			mkdir -p $target/$folder
			
			echo -e "..manjaro: $rootfs: decompressing"
			proot --link2symlink tar -xf $images/$rootfs -C $target/$folder||:
			
			echo -e "..manjaro: $folder: fixing permissions"
			chmod 755 -R $target/$folder
			
			echo -e "..manjaro: $rootfs: remove [Y/n]"
			local inputRemove=
			while [[ $inputRemove == "" ]]; do
				readline "manjaro" "remove" "Y"
				case ${inputRemove,,} in
					y|yes)
						echo -e "\n..manjaro: $rootfs: removing"
						rm -rf $images/$rootfs
					;;
					n|no) ;;
					*)
						inputRemove=
					;;
				esac
			done
			clear
		fi
		
		echo -e "..manjaro: manjaro-binds: creating"
		mkdir -p $target/manjaro-binds
		
		echo -e "..manjaro: /:etc/resolv.conf: removing"
		rm -rf $target/$folder/etc/resolv.conf
		
		echo -e "..manjaro: /:etc/resolv.conf: creating"
		echo "nameserver 1.1.1.1" > $target/$folder/etc/resolv.conf
		
		echo -e "..manjaro: /:bin/fix-repo: creating"
		echo "pacman -Syyuu --noconfirm && pacman-key --init && pacman-key --populate && pacman -Syu --noconfirm" > $target/$folder/usr/local/bin/fix-repo
		
		echo -e "..manjaro: /:bin/fix-repo: allow executable"
		chmod +x $target/$folder/usr/local/bin/fix-repo
		
		echo -e "..manjaro: mirrorlist: creating"
		cat <<- EOL > $target/$folder/etc/pacman.d/mirrorlist
			##
			## Manjaro Linux repository mirrorlist
			## Generated on 02 May 2020 14:22
			##
			## Use pacman-mirrors to modify
			##
			
			## Location  : Germany
			## Time      : 99.99
			## Last Sync :
			Server = https://mirrors.dotsrc.org/manjaro-arm/stable/$repo/$arch
		EOL
		
		# Check if Manjaro binary doesn't exists.
		if [[ ! -f $termux/files/usr/bin/$binary ]]; then
			manjaroBinary
		fi
		
		# Check if Manjaro launcher script doesn't exists.
		if [[ ! -f $target/$launch ]]; then
			manjaroLauncher
		fi
		
		local params=
		if [[ ${select,,} != "cli" ]]; then
			if [[ ${select,,} == "desktop" ]]; then
				local params=$desktop
				case ${desktop,,} in
					xfce)
						local rinku=(
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Pacman/Manjaro/XFCE"
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Pacman/Manjaro"
							"xfce4_de.sh"
						)
					;;
					lxqt)
						local rinku=(
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Pacman/Manjaro/LXQT"
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Pacman/Manjaro"
							"lxqt_de.sh"
						)
					;;
					lxde)
						local rinku=(
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Pacman/Manjaro/LXDE"
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Pacman/Manjaro"
							"lxde_de.sh"
						)
					;;
					mate)
						local rinku=(
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Pacman/Manjaro/MATE"
							"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Pacman/Manjaro"
							"mate_de.sh"
						)
					;;
				esac
				
				echo -e "\n..manjaro: desktop: setup of ${desktop^^} VNC"
				echo -e "..manjaro: /:root/.vnc: creating"
				mkdir -p $target/$folder/root/.vnc
				
				echo -e "\n..manjaro: vncserver-start: downloading"
				wget --tries=20 ${rinku[0]}/vncserver-start -O $target/$folder/usr/local/bin/vncserver-start
				echo -e "..manjaro: vncserver-start: allow executable"
				chmod +x $target/$folder/usr/local/bin/vncserver-start
				
				echo -e "\n..manjaro: vncserver-stop: downloading"
				wget --tries=20 ${rinku[0]}/vncserver-stop -O $target/$folder/usr/local/bin/vncserver-stop
				echo -e "..manjaro: vncserver-stop: allow executable"
				chmod +x $target/$folder/usr/local/bin/vncserver-stop
				
				echo -e "\n..manjaro: $desktop: ${desktop}.sh: downloading"
				wget --tries=20 ${rinku[1]}/${rinku[2]} -O $target/$folder/root/${desktop}.sh
				echo -e "..manjaro: $desktop: ${desktop}.sh: allow executable"
				chmod +x $target/$folder/root/${desktop}.sh
				
				echo -e "\n..manjaro: xstartup: downloading"
				wget --tries=20 "https://raw.githubusercontent.com/Techriz/AndronixOrigin/master/Pacman/Manjaro/${desktop^^}/xstartup" -O $target/$folder/root/.vnc/xstartup
				
				echo -e "\n..\n..manjaro: /:root/.bash_profile: removing"
				rm -rf $target/$folder/root/.bash_profile
				
				echo -e "..manjaro: /:root/.bash_profile: creating"
				cat <<- EOF > $target/$folder/root/.bash_profile
					#!/usr/bin/env bash
					
					# Fixing repository.
					fix-repo
					clear
					
					if [[ ! -f /root/${desktop}.sh ]]; then
						echo -e "..manjaro: $desktop: ${desktop}.sh: downloading"
					    wget --tries=20 ${rinku[1]}/${rinku[2]} -O /root/${desktop}.sh
					fi
					
					# Executing Desktop Environment Setup file..
					bash /root/${desktop}.sh
					clear
					
					if [[ ! -f /usr/local/bin/vncserver-start ]]; then
					    echo -e "\n..manjaro: vncserver-start: downloading"
					    wget --tries=20 ${rinku[0]}/vncserver-start -O /usr/local/bin/vncserver-start
					    
					    echo -e "..manjaro: vncserver-start: allow executable"
					    chmod +x /usr/local/bin/vncserver-start
					    
					    echo -e "\n..manjaro: vncserver-stop: downloading"
					    wget --tries=20 ${rinku[0]}/vncserver-stop -O /usr/local/bin/vncserver-stop
					    
					    echo -e "..manjaro: vncserver-stop: allow executable"
					    chmod +x /usr/local/bin/vncserver-stop
					fi
					if [[ ! -f /usr/bin/vncserver ]]; then
					    pacman -S tigervnc --noconfirm > /dev/null
					fi
					clear
					
					echo -e "..manjaro: $desktop: ${desktop}.sh: removing"
					rm -rf /root/{desktop}.sh
					
					echo -e "..manjaro: $desktop: .bash_profile: removing"
					rm -rf /root/.bash_profile
					
					# Clear terminal screen.
					clear && echo
					sleep 2.4
				EOF
				
				echo -e "..manjaro: /:root/.bash_profile: allow executable"
				chmod +x $target/$folder/root/.bash_profile
			elif [[ ${select,,} == "window" ]]; then
				local params=$window
				declare -A rinku=(
					[1]="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Pacman/Manjaro"
					[2]="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/WM/Pacman"
				)
				
				echo -e "\n..manjaro: window: setup of ${window^} VNC"
				echo -e "\n..manjaro: $window: ${window}.sh: downloading"
				wget --tries=20 ${rinku[2]}/${window}.sh -O $target/$folder/root/${window}.sh
				echo -e "..manjaro: $window: ${window}.sh: allow executable"
				chmod +x $target/$folder/root/${window}.sh
				
				cat <<- EOF > $target/$folder/root/.bash_profile
					#!/usr/bin/env bash
					
					# Fixing repository.
					fix-repo
					clear
					
					if [[ ! -f /root/${window}.sh ]]; then
					    echo -e "..manjaro: $window: ${window}.sh: downloading"
					    wget --tries=20 ${rinku[2]}/${window}.sh -O /root/${window}.sh
					fi
					
					# Executing Window Manager Setup file..
					bash /root/${window}.sh
					clear
					
					if [[ ! -f /usr/bin/vncserver ]]; then
					    pacman -S tigervnc --noconfirm > /dev/null
					fi
					clear
					
					echo -e "..manjaro: $window: ${window}.sh: removing"
					rm -rf /root/{window}.sh
					
					echo -e "..manjaro: $window: .bash_profile: removing"
					rm -rf /root/.bash_profile
					
					# Clear terminal screen.
					clear && echo
					sleep 2.4
				EOF
				
				echo -e "..manjaro: $window: .bash_profile: allow executable"
				chmod +x $target/$folder/root/.bash_profile
			fi
		else
			echo -e "\n..\n..manjaro: /:root/.bash_profile: removing"
			rm -rf $target/$folder/root/.bash_profile
			
			echo -e "..manjaro: /:root/.bash_profile: creating"
			cat <<- EOF > $target/$folder/root/.bash_profile
				#!/usr/bin/env bash
				
				# ...
				pacman-key --init && pacman-key --populate && pacman -Syu --noconfirm
				
				echo -e "..manjaro: .bash_profile: removing"
				rm -rf /root/.bash_profile
			EOF
			
			echo -e "..manjaro: .bash_profile: allow executable"
			chmod +x $target/$folder/root/.bash_profile
		fi
		
		sleep 2.4
		clear
		echo -e "\n..\n..manjaro: $select: installed"
		echo -e "..manjaro: $select: command"
		echo -e "..manjaro: $select: manjaro $select ${params[@]}\n..\n"
		
		echo -e "..manjaro: action: run manjaro [Y/n]"
		local inputNext=
		while [[ $inputNext == "" ]]; do
			readline "manjaro" "next" "Y"
			case ${inputNext,,} in
				y|yes)
					bash $termux/files/usr/bin/$binary $select ${params[@]}
				;;
				n|no) main ;;
				*) inputNext= ;;
			esac
		done
	}
	
	# Handle Manjaro Remove.
	function manjaroRemove() {
		echo 0
	}
	
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
	echo -e "          [+] MATE"
	echo -e "  $sint Actions"
	echo -e "      [1] Install"
	echo -e "      [2] Import"
	echo -e "      [3] Remove"
	echo -e "      [4] Cancel"
	echo -e
	
	# Handle input action for manjaro.
	readInputAction "manjaro" "install"
	case $action in
		cancel) main ;;
		remove)
			manjaroRemove
		;;
		import)
			manjaroImport
			manjaroInstall
		;;
		install)
			manjaroInstall
		;;
	esac
}

# Handle Nethunter Actions.
function nethunter() {

	# This functionality does not implemented at this time.
	echo 0
}

# Handle Parrot Actions.
function parrot() {

	# This functionality does not implemented at this time.
	echo 0
}

# Handle Ubuntu Actions.
function ubuntu() {

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
	local launch=ubuntu-start
	
	# Default Ubuntu Environment for install.
	local desktop=XFCE
	
	# Default Ubuntu Window Manager for install.
	local window=Awesome
	
	# Default Ubuntu Version for install.
	local version=22.04
	
	# Handle Building Ubuntu Binary.
	function ubuntuBinary() {
		echo -e "..\n..ubuntu: /:bin/$binary: building"
		cat <<- EOF > $termux/files/usr/bin/${binary}
			#!/usr/bin/env bash
			echo -e "#!/usr/bin/env bash
			
			# Default Ubuntu Version.
			version=$version
			
			# Default Ubuntu Selection.
			select=cli
			window=awesome
			desktop=xfce
			
			if [[ \\\$1 != \"\" ]]; then
			    case \\\$1 in
			        22|22.04) ;;
			        20|20.04) ;;
			        18|18.04) ;;
			        *)
			            echo -e \"ubuntu: \\\$1: unsupported version\"
			            exit 1
			        ;;
			    esac
			    if [[ \\\$2 != \"\" ]]; then
			        case \\\${2,,} in
			            cli) select=cli ;;
			            window)
			                select=window
			                if [[ \\\$3 != \"\" ]]; then
			                    case \\\${3,,} in
			                        awesome) window=awesome ;;
			                        openbox) window=openbox ;;
			                        i3) window=i3 ;;
			                        *)
			                            echo -e \"ubuntu: \\\$3: unsupported window manager\"
			                            exit 1
			                        ;;
			                    esac
			                fi
			            ;;
			            desktop)
			                select=desktop
			                if [[ \\\$3 != \"\" ]]; then
			                    case \\\${3^^} in
			                        XFCE) desktop=xfce ;;
			                        LXQT) desktop=lxqt ;;
			                        LXDE) desktop=lxde ;;
			                        *)
			                            echo -e \"ubuntu: \\\$3: unsupported desktop environment\"
			                            exit 1
			                    esac
			                fi
			            ;;
			            *)
			                echo -e \"ubuntu: \\\$2: unsupported selection mode\"
			                exit 1
			            ;;
			        esac
			    fi
			fi
			
			# Default Ubuntu Source.
			source=$target/\\\$version/\\\$select
			
			# Resolve Ubuntu Source.
			case \\\$select in
			    window) source+=/\\\$window ;;
			    desktop) source+=/\\\$desktop ;;
			esac
			
			if [[ ! -d \\\$source/ubuntu-fs ]]; then
			    case \\\$select in
			        cli) echo -e \"ubuntu: \\\$version: \\\$select: is not installed\" ;;
			        window) echo -e \"ubuntu: \\\$version: \\\$select: \\\$window: is not installed\" ;;
			        desktop) echo -e \"ubuntu: \\\$version: \\\$select: \\\$desktop: is not installed\" ;;
			    esac
			    exit 1
			else
			    if [[ -d \\\$source/ubuntu-fs/proc ]]; then
			        chmod 755 \\\$source/ubuntu-fs/proc
			        mkdir -p \\\$source/ubuntu-fs/proc/fakethings
			        if [[ ! -d \\\$source/ubuntu-fs/proc/fakethings ]]; then
			            mkdir -p \\\$source/ubuntu-fs/proc/fakethings
			            cat <<- EOF > \\\$source/ubuntu-fs/proc/fakethings/version
			\t\t\t\tLinux version 5.4.0-faked (andronix@fakeandroid) (gcc version 4.9.x (Andronix fake /proc/version) ) #1 SMP PREEMPT Sun Sep 13 00:00:00 IST 2020
			\t\t\tEOF
			            cat <<- EOF > \\\$source/ubuntu-fs/proc/fakethings/vmstat
			\t\t\t\tnr_free_pages 15717
			\t\t\t\tnr_zone_inactive_anon 87325
			\t\t\t\tnr_zone_active_anon 259521
			\t\t\t\tnr_zone_inactive_file 95508
			\t\t\t\tnr_zone_active_file 57839
			\t\t\t\tnr_zone_unevictable 58867
			\t\t\t\tnr_zone_write_pending 0
			\t\t\t\tnr_mlock 58867
			\t\t\t\tnr_page_table_pages 24569
			\t\t\t\tnr_kernel_stack 49552
			\t\t\t\tnr_bounce 0
			\t\t\t\tnr_zspages 80896
			\t\t\t\tnr_free_cma 0
			\t\t\t\tnr_inactive_anon 87325
			\t\t\t\tnr_active_anon 259521
			\t\t\t\tnr_inactive_file 95508
			\t\t\t\tnr_active_file 57839
			\t\t\t\tnr_unevictable 58867
			\t\t\t\tnr_slab_reclaimable 17709
			\t\t\t\tnr_slab_unreclaimable 47418
			\t\t\t\tnr_isolated_anon 0
			\t\t\t\tnr_isolated_file 0
			\t\t\t\tworkingset_refault 33002180
			\t\t\t\tworkingset_activate 5498395
			\t\t\t\tworkingset_restore 2354202
			\t\t\t\tworkingset_nodereclaim 140006
			\t\t\t\tnr_anon_pages 344014
			\t\t\t\tnr_mapped 193745
			\t\t\t\tnr_file_pages 218441
			\t\t\t\tnr_dirty 0
			\t\t\t\tnr_writeback 0
			\t\t\t\tnr_writeback_temp 0
			\t\t\t\tnr_shmem 1880
			\t\t\t\tnr_shmem_hugepages 0
			\t\t\t\tnr_shmem_pmdmapped 0
			\t\t\t\tnr_anon_transparent_hugepages 0
			\t\t\t\tnr_unstable 0
			\t\t\t\tnr_vmscan_write 8904094
			\t\t\t\tnr_vmscan_immediate_reclaim 139732
			\t\t\t\tnr_dirtied 8470080
			\t\t\t\tnr_written 16835370
			\t\t\t\tnr_indirectly_reclaimable 8273152
			\t\t\t\tnr_unreclaimable_pages 130861
			\t\t\t\tnr_dirty_threshold 31217
			\t\t\t\tnr_dirty_background_threshold 15589
			\t\t\t\tpgpgin 198399484
			\t\t\t\tpgpgout 31742368
			\t\t\t\tpgpgoutclean 45542744
			\t\t\t\tpswpin 3843200
			\t\t\t\tpswpout 8903884
			\t\t\t\tpgalloc_dma 192884869
			\t\t\t\tpgalloc_normal 190990320
			\t\t\t\tpgalloc_movable 0
			\t\t\t\tallocstall_dma 0
			\t\t\t\tallocstall_normal 3197
			\t\t\t\tallocstall_movable 1493
			\t\t\t\tpgskip_dma 0
			\t\t\t\tpgskip_normal 0
			\t\t\t\tpgskip_movable 0
			\t\t\t\tpgfree 384653565
			\t\t\t\tpgactivate 34249517
			\t\t\t\tpgdeactivate 44271435
			\t\t\t\tpglazyfree 192
			\t\t\t\tpgfault 46133667
			\t\t\t\tpgmajfault 5568301
			\t\t\t\tpglazyfreed 0
			\t\t\t\tpgrefill 55909145
			\t\t\t\tpgsteal_kswapd 58467386
			\t\t\t\tpgsteal_direct 255950
			\t\t\t\tpgscan_kswapd 86628315
			\t\t\t\tpgscan_direct 415889
			\t\t\t\tpgscan_direct_throttle 0
			\t\t\t\tpginodesteal 18
			\t\t\t\tslabs_scanned 31242197
			\t\t\t\tkswapd_inodesteal 1238474
			\t\t\t\tkswapd_low_wmark_hit_quickly 11637
			\t\t\t\tkswapd_high_wmark_hit_quickly 5411
			\t\t\t\tpageoutrun 32167
			\t\t\t\tpgrotated 213328
			\t\t\t\tdrop_pagecache 0
			\t\t\t\tdrop_slab 0
			\t\t\t\toom_kill 0
			\t\t\t\tpgmigrate_success 729722
			\t\t\t\tpgmigrate_fail 450
			\t\t\t\tcompact_migrate_scanned 43510584
			\t\t\t\tcompact_free_scanned 248175096
			\t\t\t\tcompact_isolated 1494774
			\t\t\t\tcompact_stall 6
			\t\t\t\tcompact_fail 3
			\t\t\t\tcompact_success 3
			\t\t\t\tcompact_daemon_wake 9438
			\t\t\t\tcompact_daemon_migrate_scanned 43502436
			\t\t\t\tcompact_daemon_free_scanned 248107303
			\t\t\t\tunevictable_pgs_culled 66418
			\t\t\t\tunevictable_pgs_scanned 0
			\t\t\t\tunevictable_pgs_rescued 8484
			\t\t\t\tunevictable_pgs_mlocked 78830
			\t\t\t\tunevictable_pgs_munlocked 8508
			\t\t\t\tunevictable_pgs_cleared 11455
			\t\t\t\tunevictable_pgs_stranded 11455
			\t\t\t\tswap_ra 0
			\t\t\t\tswap_ra_hit 7
			\t\t\t\tspeculative_pgfault 221449963
			\t\t\tEOF
			            cat <<- EOF > \\\$source/ubuntu-fs/proc/fakethings/stat
			\t\t\t\tcpu  5502487 1417100 4379831 62829678 354709 539972 363929 0 0 0
			\t\t\t\tcpu0 611411 171363 667442 7404799 61301 253898 205544 0 0 0
			\t\t\t\tcpu1 660993 192673 571402 7853047 39647 49434 29179 0 0 0
			\t\t\t\tcpu2 666965 186509 576296 7853110 39012 48973 26407 0 0 0
			\t\t\t\tcpu3 657630 183343 573805 7863627 38895 48768 26636 0 0 0
			\t\t\t\tcpu4 620516 161440 594973 7899146 39438 47605 26467 0 0 0
			\t\t\t\tcpu5 610849 155665 594684 7912479 40258 46870 26044 0 0 0
			\t\t\t\tcpu6 857685 92294 387182 8096756 46609 22110 12364 0 0 0
			\t\t\t\tcpu7 816434 273809 414043 7946709 49546 22311 11284 0 0 0
			\t\t\t\tintr 601715486 0 0 0 0 70612466 0 2949552 0 93228 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 12862684 625329 10382717 16209 55315 8510 0 0 0 0 11 11 13 270 192 40694 95 7 0 0 0 36850 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 286 6378 0 0 0 54 0 3239423 2575191 82725 0 0 127 0 0 0 1791277 850609 20 9076504 0 301 0 0 0 0 0 3834621 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 806645 0 0 0 0 0 7243 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2445850 52 1783 0 0 5091520 0 0 0 3 0 0 0 0 0 5475 0 198001 0 2 42 1289224 0 2 202483 4 0 8390 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3563336 4202122 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 1 0 0 1 0 1 0 17948 0 0 612 0 0 0 0 2103 0 0 20 0 0 0 0 0 0 0 0 0 0 0 0 0 10 0 0 0 0 0 0 0 11 11 12 0 12 0 52 752 0 0 0 0 0 0 0 743 0 14 0 0 12 0 0 1863 229 0 464 0 0 0 0 0 0 8588 97 7236426 92766 622 31 0 0 0 18 4 4 0 5 0 0 116013 7 0 0 752406
			\t\t\t\tctxt 826091808
			\t\t\t\tbtime 1611513513
			\t\t\t\tprocesses 288493
			\t\t\t\tprocs_running 1
			\t\t\t\tprocs_blocked 0
			\t\t\t\tsoftirq 175407567 14659158 51739474 28359 5901272 8879590 0 11988166 46104015 0 36107533
			\t\t\tEOF
			        fi
			    fi
			fi
			
			bash \\\$source/$launch
			" > $termux/files/usr/bin/$binary
			chmod +x $termux/files/usr/bin/$binary
		EOF
		echo -e "..ubuntu: /:bin/$binary: fixing shebang"
		termux-fix-shebang $termux/files/usr/bin/$binary
		echo -e "..ubuntu: /:bin/$binary: allow executable\n..\n"
		chmod +x $termux/files/usr/bin/$binary
		bash $termux/files/usr/bin/$binary
	}
	
	# Handle Building Ubuntu Launcher.
	function ubuntuLauncher() {
		if [[ $1 != "" ]]; then
			if [[ ! -d $1 ]]; then
				echo -e "\n..ubuntu: $1: no such file or directory"
				exit 1
			fi
			
			echo -e "..\n..ubuntu: $version: $launch: building"
			case $version in
				22.04)
					cat > $source/$launch <<- EOM
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
						
						if [[ -n "\$(ls -A $source/ubuntu-binds)" ]]; then
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
						#command+=" -b $termux/files/home:/root"
						
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
						
						if [[ -z "\$1" ]]; then
						    exec \$command
						else
						    \$command -c "\$com"
						fi
					EOM
				;;
				20.04)
					cat > $source/$launch <<- EOM
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
						
						if [[ -n "\$(ls -A $source/ubuntu-binds)" ]]; then
						    for f in $source/ubuntu-binds/* ;do
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
						#command+=" -b $termux/files/home:/root"
						
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
						
						if [[ -z "\$1" ]];then
						    exec \$command
						else
						    \$command -c "\$com"
						fi
					EOM
				;;
				18.04)
					cat > $source/$launch <<- EOM
						#!/usr/bin/env bash
						
						# Change current working directory.
						cd \$(dirname \$0)
						
						# Avoid termux-exec, execve() conflicts with PRoot.
						unset LD_PRELOAD
						
						# Arrange command.
						command="proot"
						command+=" --link2symlink"
						command+=" -0"
						command+=" -r $source/$folder"
						
						if [[ -n "\$(ls -A $source/ubuntu-binds)" ]]; then
						    for f in $source/ubuntu-binds/* ;do
						      . \$f
						    done
						fi
						
						command+=" -b /dev"
						command+=" -b /proc"
						command+=" -b $source/$folder/root:/dev/shm"
						
						# Uncomment the following line to have
						# access to the home directory of termux.
						#command+=" -b $termux/files/home:/root"
						
						# Uncomment the following line to
						# mount /sdcard directly to /.
						#command+=" -b /sdcard"
						
						command+=" -w /root"
						command+=" /usr/bin/env -i"
						command+=" HOME=/root"
						command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
						command+=" TERM=\$TERM"
						command+=" LANG=C.UTF-8"
						command+=" /bin/bash --login"
						com="\$@"
						
						if [[ -z "\$1" ]];then
						    exec \$command
						else
						    \$command -c "\$com"
						fi
					EOM
				;;
			esac
			
			echo -e "..ubuntu: $version: $launch: fixing shebang"
			termux-fix-shebang $source/$launch
			
			echo -e "..ubuntu: $version: $launch: allow executable"
			chmod +x $source/$launch
		else
			echo -e "\n..ubuntu: source destination required"
			exit 1
		fi
	}
	
	# Handle Ubuntu Import.
	function ubuntuImport() {

		# Ubuntu Install Source Destination.
		local source=$target/$version
	}
	
	# Handle Ubuntu Install.
	function ubuntuInstall() {

		# Default Ubuntu Install Source Destination.
		local source=$target/$version
		
		# Default Ubuntu RootFS name based on version number.
		local rootfs=ubuntu-rootfs.$version.tar.gz
		
		# Resolve Ubuntu RootFS name and archive url.
		if [[ $version == 22.04 ]]; then
			case ${architect,,} in
				aarch64) local archurl="arm64" ;;
				*)
					echo -e "..ubuntu: $version: $architect: unsupported architecture"
					exit 1
				;;
			esac
			local archive="https://github.com/AndronixApp/AndronixOrigin/raw/master/Rootfs/Ubuntu22/jammy-${archurl}.tar.gz"
		elif [[ $version == 20.03 ]]; then
			case ${architect,,} in
				aarch64) local archurl="arm64" ;;
				arm) local archurl="armhf" ;;
				amd64) local archurl="amd64" ;;
				x86_64) local archurl="amd64" ;;
				*)
					echo -e "..ubuntu: $version: $architect: unsupported architecture"
					exit 1
				;;
			esac
			local archive="https://github.com/AndronixApp/AndronixOrigin/raw/master/Rootfs/Ubuntu20/focal-${archurl}.tar.gz"
		elif [[ $version == 18.04 ]]; then
			case ${architect,,} in
				aarch64) local archurl="arm64" ;;
				arm) local archurl="armhf" ;;
				amd64) local archurl="amd64" ;;
				x86_64) local archurl="amd64" ;;
				i*86) local archurl="i386" ;;
				x86) local archurl="i386" ;;
				*)
					echo -e "..ubuntu: $version: $architect: unsupported architecture"
					exit 1
				;;
			esac
			local archive="https://github.com/Techriz/AndronixOrigin/blob/master/Rootfs/Ubuntu/${archurl}/ubuntu-rootfs-${archurl}.tar.xz?raw=true"
			local rootfs=ubuntu-rootfs.$version.tar.xz
		else
			echo -e "..ubuntu: $version: unsupported version"
			exit 1
		fi
		
		# Resolve Ubuntu Source Destination.
		case $select in
			cli) source+=/cli ;;
			window) source+=/window/$window ;;
			desktop) source+=/desktop/$desktop ;;
			*)
				echo -e "..ubuntu: $version: $select: unknown selection mode"
				exit 1
			;;
		esac
		
		# Check if file system does not exists.
		if [[ ! -d $source/$folder ]]; then
			if [[ ! -f $images/$rootfs ]]; then
				echo -e "\n..ubuntu: $version: $rootfs: downloading"
				wget $archive -O $images/$rootfs
				clear
			fi
			
			echo -e "\n..ubuntu: $version: $folder: creating"
			mkdir -p $source/$folder
			
			echo -e "..ubuntu: $version: $rootfs: decompressing"
			if [[ $version == 18.04 ]]; then
				proot --link2symlink tar -xJf $images/$rootfs -C $source/$folder||:
			else
				proot --link2symlink tar -xf $images/$rootfs --exclude=dev -C $source/$folder||:
			fi
			
			echo -e "..ubuntu: $rootfs: remove tarball [Y/n]"
			local inputRemove=
			while [[ $inputRemove == "" ]]; do
				readline "ubuntu" "remove" "Y"
				case ${inputRemove,,} in
					y|yes)
						echo -e "..ubuntu: $version: $rootfs: removing tarball"
						rm -f $images/$rootfs
					;;
					n|no) ;;
					*)
						inputRemove=
					;;
				esac
			done
			clear
		fi
		
		echo -e "..ubuntu: ubuntu-binds: creating"
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
		
		local params=
		case $version in
			22.04)
				if [[ ${select,,} != "cli" ]]; then
					if [[ ${select,,} == "desktop" ]]; then
						local params=$desktop
						case ${desktop,,} in
							xfce) local rinku="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT/XFCE4" ;;
							lxqt) local rinku="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT/LXQT" ;;
							lxde) local rinku="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT/LXDE" ;;
						esac
						
						echo -e "\n..ubuntu: $version: desktop: setup of ${desktop^^} VNC"
						mkdir -p $source/$folder/var/tmp
						rm -rf $source/$folder/usr/local/bin/*
						
						# Create new hostname.
						echo "127.0.0.1 localhost localhost" > $source/$folder/etc/hosts
						
						# Setup VNC Viewer
						vncViewerSetup $source/$folder
						
						echo -e "\n..ubuntu: $version: $desktop: setup apt retry count"
						echo "APT::Acquire::Retries \"3\";" > $source/$folder/etc/apt/apt.conf.d/80-retries
						
						echo -e "..ubuntu: $version: $desktop: .hushlogin: creating"
						touch $source/$folder/root/.hushlogin
						
						echo -e "\n..ubuntu: $version: $desktop: ${desktop}.sh: downloading"
						wget --tries=20 $rinku/${desktop}22.sh -O $source/$folder/root/${desktop}.sh
						echo -e "..ubuntu: $version: $desktop: ${desktop}.sh: allow executable"
						chmod +x $source/$folder/root/${desktop}.sh
						
						echo -e "\n..ubuntu: $version: $desktop: .bash_profile: removing"
						rm -rf $source/$folder/root/.bash_profile
						
						echo -e "..ubuntu: $version: $desktop: .bash_profile: building"
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
							
							if [[ ! -f /root/${desktop}.sh ]]; then
							    echo -e "..ubuntu: $version: $desktop: ${desktop}.sh: downloading"
							    wget --tries=20 $rinku/${desktop}22.sh -O /root/${desktop}.sh
							fi
							bash /root/${desktop}.sh
							clear
							
							if [[ ! -f /usr/local/bin/vncserver-start ]]; then
							    echo -e "\n..ubuntu: $version: vncserver-start: downloading"
							    wget --tries=20 $rinku/vncserver-start -O /usr/local/bin/vncserver-start
							    echo -e "..ubuntu: $version: vncserver-start: removing"
							    chmod +x /usr/local/bin/vncserver-start
							    
							    echo -e "\n..ubuntu: $version: vncserver-stop: downloading"
							    wget --tries=20 $rinku/vncserver-stop -O /usr/local/bin/vncserver-stop
							    echo -e "..ubuntu: $version: vncserver-stop: removing"
							    chmod +x /usr/local/bin/vncserver-stop
							fi
							clear
							
							if [[ ! -f /usr/bin/vncserver ]]; then
							    apt install tigervnc-standalone-server -y
							fi
							clear
							
							echo -e "..ubuntu: $version: $desktop: ${desktop}.sh: removing"
							rm -rf /root/{desktop}.sh
							
							echo -e "..ubuntu: $version: $desktop: .bash_profile: removing"
							rm -rf /root/.bash_profile
							
							# Displaying screenfetch.
							clear && screenfetch -A "Ubuntu" && echo
							sleep 2.4
						EOF
						
						echo -e "..ubuntu: $version: $desktop: .bash_profile: allow executable"
						chmod +x $source/$folder/root/.bash_profile
					elif [[ ${select,,} == "window" ]]; then
						local params=$window
						declare -A rinku=(
							[1]="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT"
							[2]="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/WM/APT"
						)
						
						echo -e "\n..ubuntu: $version: window: setup of ${window^} VNC"
						mkdir -p $source/$folder/var/tmp
						rm -rf $source/$folder/usr/local/bin/*
						
						# Remove old resolve configuration.
						rm -rf $source/$folder/etc/resolv.conf
						
						# Create new resolve configuration.
						echo "nameserver 1.1.1.1" > $source/$folder/etc/resolv.conf
						
						# Setup VNC Viewer
						vncViewerSetup $source/$folder
						
						echo -e "\n..ubuntu: $version: $window: setup apt retry count"
						echo "APT::Acquire::Retries \"3\";" > $source/$folder/etc/apt/apt.conf.d/80-retries
						
						echo -e "\n..ubuntu: $version: $window: ${window}.sh: downloading"
						wget --tries=20 ${rinku[2]}/${window}.sh -O $source/$folder/root/${window}.sh
						echo -e "..ubuntu: $version: $window: ${window}.sh: allow executable"
						chmod +x $source/$folder/root/${window}.sh
						
						echo -e "..ubuntu: $version: $window: .bash_profile: building"
						cat <<- EOF > $source/$folder/root/.bash_profile
							#!/usr/bin/env bash
							
							# Installing required packages.
							apt update -y && apt install wget sudo nano screenfetch -y && clear
							
							if [[ ! -f /root/${window}.sh ]]; then
							    echo -e "..ubuntu: $version: $window: ${window}.sh: downloading"
							    wget --tries=20 ${rinku[2]}/${window}.sh -O /root/${window}.sh
							fi
							bash /root/${window}.sh
							clear
							
							if [[ ! -f /usr/bin/vncserver ]]; then
							    apt install tigervnc-standalone-server -y
							fi
							clear
							
							echo -e "..ubuntu: $version: $window: ${window}.sh: removing"
							rm -rf /root/{window}.sh
							
							echo -e "..ubuntu: $version: $window: .bash_profile: removing"
							rm -rf /root/.bash_profile
							
							# Displaying screenfetch.
							clear && screenfetch -A "Ubuntu" && echo
							sleep 2.4
						EOF
						
						echo -e "..ubuntu: $version: $window: .bash_profile: allow executable"
						chmod +x $source/$folder/root/.bash_profile
					fi
				fi
			;;
			20.04)
				if [[ ${select,,} != "cli" ]]; then
					if [[ ${select,,} == "desktop" ]]; then
						local params=$desktop
						case ${desktop,,} in
							xfce) local rinku="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT/XFCE4" ;;
							lxqt) local rinku="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT/LXQT" ;;
							lxde) local rinku="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT/LXDE" ;;
						esac
						
						echo -e "\n..ubuntu: $version: desktop: setup of ${desktop^^} VNC"
						mkdir -p $source/$folder/var/tmp
						rm -rf $source/$folder/usr/local/bin/*
						
						# Create new hostname.
						echo "127.0.0.1 localhost localhost" > $source/$folder/etc/hosts
						
						# Setup VNC Viewer
						vncViewerSetup $source/$folder
						
						echo -e "\n..ubuntu: $version: $desktop: setup apt retry count"
						echo "APT::Acquire::Retries \"3\";" > $source/$folder/etc/apt/apt.conf.d/80-retries
						
						echo -e "..ubuntu: $version: $desktop: .hushlogin: creating"
						touch $source/$folder/root/.hushlogin
						
						echo -e "\n..ubuntu: $version: $desktop: ${desktop}.sh: downloading"
						wget --tries=20 $rinku/${desktop}19.sh -O $source/$folder/root/${desktop}.sh
						echo -e "..ubuntu: $version: $desktop: ${desktop}.sh: allow executable"
						chmod +x $source/$folder/root/${desktop}.sh
						
						echo -e "\n..ubuntu: $version: $desktop: .profile.1: downloading"
						wget -q https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Rootfs/Ubuntu19/.profile -O $source/$folder/root/.profile.1 > /dev/null
						echo -e "\n..ubuntu: $version: $desktop: .profile: writing"
						cat $source/$folder/root/.profile.1 >> $source/$folder/root/.profile
						echo -e "\n..ubuntu: $version: $desktop: .profile: allow executable"
						chmod +x $source/$folder/root/.profile
						echo -e "\n..ubuntu: $version: $desktop: .profile.1: removing"
						rm -rf $source/$folder/root/.profile.1
						
						echo -e "\n..ubuntu: $version: $desktop: .bash_profile: removing"
						rm -rf $source/$folder/root/.bash_profile
						
						echo -e "..ubuntu: $version: $desktop: .bash_profile: building"
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
							
							if [[ ! -f /root/${desktop}.sh ]]; then
							    echo -e "..ubuntu: $version: $desktop: ${desktop}.sh: downloading"
							    wget --tries=20 $rinku/${desktop}19.sh -O /root/${desktop}.sh
							fi
							bash /root/${desktop}.sh
							clear
							
							if [[ ! -f /usr/local/bin/vncserver-start ]]; then
							    echo -e "\n..ubuntu: $version: vncserver-start: downloading"
							    wget --tries=20 $rinku/vncserver-start -O /usr/local/bin/vncserver-start
							    echo -e "..ubuntu: $version: vncserver-start: removing"
							    chmod +x /usr/local/bin/vncserver-start
							    
							    echo -e "\n..ubuntu: $version: vncserver-stop: downloading"
							    wget --tries=20 $rinku/vncserver-stop -O /usr/local/bin/vncserver-stop
							    echo -e "..ubuntu: $version: vncserver-stop: removing"
							    chmod +x /usr/local/bin/vncserver-stop
							fi
							clear
							
							if [[ ! -f /usr/bin/vncserver ]]; then
							    apt install tigervnc-standalone-server -y
							fi
							clear
							
							echo -e "..ubuntu: $version: $desktop: ${desktop}.sh: removing"
							rm -rf /root/{desktop}.sh
							
							echo -e "..ubuntu: $version: $desktop: .bash_profile: removing"
							rm -rf /root/.bash_profile
							
							# Displaying screenfetch.
							clear && screenfetch -A "Ubuntu" && echo
							sleep 2.4
						EOF
						
						echo -e "..ubuntu: $version: $desktop: .bash_profile: allow executable"
						chmod +x $source/$folder/root/.bash_profile
					elif [[ ${select,,} == "window" ]]; then
						local params=$window
						declare -A rinku=(
							[1]="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT"
							[2]="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/WM/APT"
						)
						
						echo -e "\n..ubuntu: $version: window: setup of ${window^} VNC"
						mkdir -p $source/$folder/var/tmp
						rm -rf $source/$folder/usr/local/bin/*
						
						# Remove old resolve configuration.
						rm -rf $source/$folder/etc/resolv.conf
						
						# Create new resolve configuration.
						echo "nameserver 1.1.1.1" > $source/$folder/etc/resolv.conf
						
						# Setup VNC Viewer
						vncViewerSetup $source/$folder
						
						echo -e "\n..ubuntu: $version: $window: setup apt retry count"
						echo "APT::Acquire::Retries \"3\";" > $source/$folder/etc/apt/apt.conf.d/80-retries
						
						echo -e "\n..ubuntu: $version: $window: ${window}.sh: downloading"
						wget --tries=20 ${rinku[2]}/${window}.sh -O $source/$folder/root/${window}.sh
						echo -e "..ubuntu: $version: $window: ${window}.sh: allow executable"
						chmod +x $source/$folder/root/${window}.sh
						
						echo -e "..ubuntu: $version: $window: .bash_profile: building"
						cat <<- EOF > $source/$folder/root/.bash_profile
							#!/usr/bin/env bash
							
							# Installing required packages.
							apt update -y && apt install wget sudo nano screenfetch -y && clear
							
							if [[ ! -f /root/${window}.sh ]]; then
							    echo -e "..ubuntu: $version: $window: ${window}.sh: downloading"
							    wget --tries=20 ${rinku[2]}/${window}.sh -O /root/${window}.sh
							fi
							bash /root/${window}.sh
							clear
							
							if [[ ! -f /usr/bin/vncserver ]]; then
							    apt install tigervnc-standalone-server -y
							fi
							clear
							
							echo -e "..ubuntu: $version: $window: ${window}.sh: removing"
							rm -rf /root/{window}.sh
							
							echo -e "..ubuntu: $version: $window: .bash_profile: removing"
							rm -rf /root/.bash_profile
							
							# Displaying screenfetch.
							clear && screenfetch -A "Ubuntu" && echo
							sleep 2.4
						EOF
						
						echo -e "..ubuntu: $version: $window: .bash_profile: allow executable"
						chmod +x $source/$folder/root/.bash_profile
					fi
				fi
			;;
			18.04)
				if [[ ${select,,} != "cli" ]]; then
					if [[ ${select,,} == "desktop" ]]; then
						local params=$desktop
						case ${desktop,,} in
							xfce)
								local rinku=(
									"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT/XFCE4"
									"xfce4_de.sh"
								)
							;;
							lxqt)
								local rinku=(
									"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT/LXQT"
									"lxqt_de.sh"
								)
							;;
							lxde)
								local rinku=(
									"https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT/LXDE"
									"lxde_de.sh"
								)
							;;
						esac
						
						# Setup VNC Viewer
						vncViewerSetup $source/$folder
						
						echo -e "\n..ubuntu: $version: $desktop: setup apt retry count"
						echo "APT::Acquire::Retries \"3\";" > $source/$folder/etc/apt/apt.conf.d/80-retries
						
						echo -e "..ubuntu: $version: $desktop: .hushlogin: creating"
						touch $source/$folder/root/.hushlogin
						
						echo -e "\n..ubuntu: $version: $desktop: ${desktop}.sh: downloading"
						wget --tries=20 ${rinku[0]}/${rinku[1]}.sh -O $source/$folder/root/${desktop}.sh
						echo -e "..ubuntu: $version: $desktop: ${desktop}.sh: allow executable"
						chmod +x $source/$folder/root/${desktop}.sh
						
						echo -e "\n..ubuntu: $version: $desktop: .bash_profile: removing"
						rm -rf $source/$folder/root/.bash_profile
						
						echo -e "..ubuntu: $version: $desktop: .bash_profile: building"
						cat <<- EOF > $source/$folder/root/.bash_profile
							#!/usr/bin/env bash
							
							# Installing required packages.
							apt update -y && apt install sudo wget nano screenfetch -y > /dev/null
							clear
							
							if [[ ! -f /root/${desktop}.sh ]]; then
							    echo -e "..ubuntu: $version: $desktop: ${desktop}.sh: downloading"
							    wget --tries=20 ${rinku[0]}/${rinku[1]}.sh -O /root/${desktop}.sh
							fi
							bash /root/${desktop}.sh
							clear
							
							if [[ ! -f /usr/local/bin/vncserver-start ]]; then
							    echo -e "\n..ubuntu: $version: vncserver-start: downloading"
							    wget --tries=20 ${rinku[0]}/vncserver-start -O /usr/local/bin/vncserver-start
							    echo -e "..ubuntu: $version: vncserver-start: removing"
							    chmod +x /usr/local/bin/vncserver-start
							    
							    echo -e "\n..ubuntu: $version: vncserver-stop: downloading"
							    wget --tries=20 ${rinku[0]}/vncserver-stop -O /usr/local/bin/vncserver-stop
							    echo -e "..ubuntu: $version: vncserver-stop: removing"
							    chmod +x /usr/local/bin/vncserver-stop
							fi
							clear
							
							if [[ ! -f /usr/bin/vncserver ]]; then
							    apt install tigervnc-standalone-server -y
							fi
							clear
							
							echo -e "..ubuntu: $version: $desktop: ${desktop}.sh: removing"
							rm -rf /root/{desktop}.sh
							
							echo -e "..ubuntu: $version: $desktop: .bash_profile: removing"
							rm -rf /root/.bash_profile
							
							# Displaying screenfetch.
							clear && screenfetch -A "Ubuntu" && echo
							sleep 2.4
						EOF
						
						echo -e "..ubuntu: $version: $desktop: .bash_profile: allow executable"
						chmod +x $source/$folder/root/.bash_profile
					elif [[ ${select,,} == "window" ]]; then
						local params=$window
						declare -A rinku=(
							[1]="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/APT"
							[2]="https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/WM/APT"
						)
						
						# Setup VNC Viewer
						vncViewerSetup $source/$folder
						
						echo -e "\n..ubuntu: $version: $window: setup apt retry count"
						echo "APT::Acquire::Retries \"3\";" > $source/$folder/etc/apt/apt.conf.d/80-retries
						
						echo -e "\n..ubuntu: $version: $window: ${window}.sh: downloading"
						wget --tries=20 ${rinku[2]}/${window}.sh -O $source/$folder/root/${window}.sh
						echo -e "..ubuntu: $version: $window: ${window}.sh: allow executable"
						chmod +x $source/$folder/root/${window}.sh
						
						echo -e "..ubuntu: $version: $window: .bash_profile: building"
						cat <<- EOF > $source/$folder/root/.bash_profile
							#!/usr/bin/env bash
							
							# Installing required packages.
							apt update -y && apt install wget sudo nano screenfetch -y && clear
							
							if [[ ! -f /root/${window}.sh ]]; then
							    echo -e "..ubuntu: $version: $window: ${window}.sh: downloading"
							    wget --tries=20 ${rinku[2]}/${window}.sh -O /root/${window}.sh
							fi
							bash /root/${window}.sh
							clear
							
							if [[ ! -f /usr/bin/vncserver ]]; then
							    apt install tigervnc-standalone-server -y
							fi
							clear
							
							echo -e "..ubuntu: $version: $window: ${window}.sh: removing"
							rm -rf /root/{window}.sh
							
							echo -e "..ubuntu: $version: $window: .bash_profile: removing"
							rm -rf /root/.bash_profile
							
							# Displaying screenfetch.
							clear && screenfetch -A "Ubuntu" && echo
							sleep 2.4
						EOF
						
						echo -e "..ubuntu: $version: $window: .bash_profile: allow executable"
						chmod +x $source/$folder/root/.bash_profile
					fi
				fi
			;;
		esac
		
		# Check if Ubuntu binary doesn't exists.
		if [[ ! -f $termux/files/usr/bin/$binary ]]; then
			ubuntuBinary
		fi
		
		# Check if Ubuntu launcher script doesn't exists.
		if [[ ! -f $source/$launch ]]; then
			ubuntuLauncher $source
		fi
		
		sleep 2.4
		clear
		echo -e "\n..\n..ubuntu: $select: installed"
		echo -e "..ubuntu: $version: $select: command"
		echo -e "..ubuntu: $version: $select: ubuntu $version $select ${params[@]}\n..\n"
		
		echo -e "..ubuntu: $version: $select: action: run ubuntu [Y/n]"
		local inputNext=
		while [[ $inputNext == "" ]]; do
			readline "ubuntu" "next" "Y"
			case ${inputNext,,} in
				y|yes)
					bash $termux/files/usr/bin/$binary $version $select ${params[@]}
				;;
				n|no) main ;;
				*) inputNext= ;;
			esac
		done
	}
	
	# Handle Ubuntu Remove.
	function ubuntuRemove() {

		# Default Ubuntu Install Source Destination.
		local source=$target/$version
		local params=
		
		case $select in
			cli)
				source+=/cli
				params=cli
			;;
			window)
				source+=/window/$window
				params=$window
			;;
			desktop)
				source+=/desktop/$desktop
				params=$desktop
			;;
			*)
				echo -e "\n..\n..ubuntu: $version: $select: unknown selection mode"
				exit 1
			;;
		esac
		
		echo -e "\n..\n..ubuntu: $version: $select: $params: removing"
		rm -rf $source
		
		readline "ubuntu" "next"
		ubuntu
	}
	
	clear

	# Prints Ubuntu informations.
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
	
	# Get input action for Ubuntu.
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
function voidx() {
	clear

	# Prints informations.
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
	
	# Handle input action for void linux.
	readInputAction "void" "install"
	case $action in
		cancel) main ;;
		remove)
			voidRemove
		;;
		import)
			voidImport
			voidInstall
		;;
		install)
			voidInstall
		;;
	esac
}

# Main Program.
function main() {

	clear
	
	# Prints informations.
	echo -e
	echo -e "$(stdio stdout main)"
	echo -e "  $sint $appname v$version"
	echo -e "  [i] Architect ${architect^^}"
	echo -e "  [i] Author $author"
	echo -e "  [i] E-Mail $author_email"
	echo -e "  [i] Github $github"
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
	
	local inputDistro=
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

# Check if program doest not run in termux.
if [[ -d $termux ]]; then

	# Trying make directory for save downloaded rootfs.
	mkdir -p $images

	# Starting main program.
	main
else

	clear

	echo -e
	echo -e "$(stdio stdout penguin)"
	echo -e "  $sint $appname v$version"
	echo -e "      No such file or directory ${termux}"
	echo -e "      Do you want to change the main directoy [Y/n]"
	echo -e

	inputChange=
	inputChange=/self/personal/temporary
	while [[ $inputChange == "" ]]; do
		readline "directory" "change"
		if [[ ${inputChange,,} == "y" ]]; then
			inputDirectory=
			while [[ $inputDirectory == "" ]]; do
				readline "source" "directory"
				if [[ $inputDirectory == "" ]]; then
					continue
				elif [[ -d $inputDirectory ]]; then

					# Update Termux directory.
					termux=$inputDirectory

					# Update Installation directory.
					install=$termux/linux

					# Update Rootfs Images stored.
					images=$install/.rootfs

					break
				fi
				inputDirectory=
			done
			break
		elif [[ ${inputChange,,} == "n" ]]; then
			echo && exit 0
		else
			inputChange=
		fi
	done
	
	# Trying make directory for save downloaded rootfs.
	mkdir -p $images

	# Starting main program.
	main
fi
