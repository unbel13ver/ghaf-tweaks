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
nix flake update ghaf

echo "Building..."
time nix build .# --impure

if [ $? -eq 0 ] && [[ -n "$device" ]]; then
    echo "Wiping filesystem..."
    SECTOR=512
    # 10 MiB in 512-byte sectors
    MIB_TO_SECTORS=20480
    # Disk size in 512-byte sectors
    SECTORS=$(sudo blockdev --getsz "$device")
    # Unmount possible mounted filesystems
    sync; sudo umount -q "$device"* || true;
    # Wipe first 10MiB of disk
    echo "Wiping first 10 MiB, bs=$SECTOR, count=$MIB_TO_SECTORS"
    sudo dd if=/dev/zero of="$device" bs="$SECTOR" count="$MIB_TO_SECTORS" conv=fsync status=none
    # Wipe last 10MiB of disk
    echo "Wiping last 10 MiB, bs=$SECTOR, seek=$((SECTORS - MIB_TO_SECTORS))"
    sudo dd if=/dev/zero of="$device" bs="$SECTOR" count="$MIB_TO_SECTORS" seek="$((SECTORS - MIB_TO_SECTORS))" conv=fsync status=none
    echo "Flashing..."
    zstdcat result/disk1.raw.zst | sudo dd of=$device bs=32M status=progress conv=fsync
fi

# End of script
