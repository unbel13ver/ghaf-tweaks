#!/bin/bash

# Check if the script is run with an argument
if [ $# -gt 1 ]; then
    echo "Usage: $0 <device>"
    exit 1
elif [ $# -gt 0 ]; then
    sudo -v
fi

# Store the input argument in a variable
device=$1

echo "Update flake.lock file..."
nix flake lock --update-input ghaf

echo "Building..."
time nix build .# --impure

if [ $? -eq 0 ] && [[ -n "$device" ]]; then
    echo "Wiping filesystem..."
    # Wipe first 100MB of disk
    sudo dd if=/dev/zero of=$device bs=100M count=1 status=progress conv=fsync
    sectors=$(sudo fdisk -l $device | head -n 1 |  awk '{print $7}')
    # Wipe last ~100MB of disk
    sudo dd if=/dev/zero of=$device seek=$((sectors - 204800))
    echo "Flashing..."
    sync; umount /media/$USER/*; zstdcat result/disk1.raw.zst | sudo dd of=$device bs=100M status=progress conv=fsync
fi

# End of script
