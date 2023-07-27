#!/usr/bin/env bash

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
