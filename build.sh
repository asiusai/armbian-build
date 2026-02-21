#!/bin/bash

# Remove stale apt lock files left by previous failed/interrupted builds
sudo find .tmp -name "rootfs-*" -maxdepth 1 -type d 2>/dev/null | while read -r rootfs; do
	sudo rm -fv \
		"${rootfs}/var/cache/apt/archives/lock" \
		"${rootfs}/var/lib/apt/lists/lock" \
		"${rootfs}/var/lib/dpkg/lock" \
		"${rootfs}/var/lib/dpkg/lock-frontend"
done
sudo rm -fv cache/aptcache/noble-arm64/lock cache/aptcache/lists/noble-arm64/lock

# Generate firstboot preset config
cat > userpatches/firstboot.conf << 'EOF'
PRESET_ROOT_PASSWORD=12345678
PRESET_USER_NAME=orangepi
PRESET_USER_PASSWORD=12345678
PRESET_DEFAULT_REALNAME=OrangePi
PRESET_USER_SHELL=bash
PRESET_LOCALE=en_US.UTF-8
PRESET_TIMEZONE=Etc/UTC
SET_LANG_BASED_ON_LOCATION=n
PRESET_NET_CHANGE_DEFAULTS=0
PRESET_CONNECT_WIRELESS=n
EOF

./compile.sh \
	BOARD=orangepi5-ultra \
	BRANCH=vendor \
	RELEASE=noble \
	KERNEL_CONFIGURE=no \
	PREFER_DOCKER=no \
	BUILD_DESKTOP=yes \
	DESKTOP_ENVIRONMENT=gnome \
	DESKTOP_ENVIRONMENT_CONFIG_NAME=config_base \
	DESKTOP_APPGROUPS_SELECTED=''
