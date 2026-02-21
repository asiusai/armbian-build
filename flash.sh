#!/bin/bash
set -e

IMAGE=$(ls -t output/images/*.img 2>/dev/null | head -1)

if [[ -z "$IMAGE" ]]; then
	echo "Error: no image found in output/images/"
	exit 1
fi

echo "Image: $IMAGE"

# List available block devices
echo ""
echo "Available devices:"
lsblk -dpno NAME,SIZE,MODEL | grep -v "loop\|sr"
echo ""

read -rp "Target device (e.g. /dev/sda): " DEVICE

if [[ -z "$DEVICE" ]]; then
	echo "Error: no device specified"
	exit 1
fi

if [[ ! -b "$DEVICE" ]]; then
	echo "Error: $DEVICE is not a block device"
	exit 1
fi

echo ""
echo "WARNING: This will erase ALL data on $DEVICE"
read -rp "Are you sure? [y/N] " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
	echo "Aborted."
	exit 0
fi

echo ""
echo "Flashing $IMAGE -> $DEVICE ..."
sudo dd if="$IMAGE" of="$DEVICE" bs=4M status=progress conv=fsync
echo ""
echo "Done. You can now safely remove the device."
