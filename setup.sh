#!/usr/bin/env bash

#
# @author Ari Setiawan
# @create 11.07-2023
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

installs=()
requires=(
	"curl"
	"proot"
	"tar"
	"wget"
)

for package in ${requires[@]}; do
	if [[ ! -f /data/data/com.termux/files/usr/bin/$package ]]; then
		installs+=( $package )
	fi
done

if [[ ${#installs[@]} > 0 ]]; then
	pkg update -y
	pkg install -y ${installs[@]}
fi

mkdir -p /data/data/com.termux/linux
mkdir -p /data/data/com.termux/linux/.rootfs
