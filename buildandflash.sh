#!/bin/bash

# Check if the script is run with an argument
if [ $# -gt 1 ]; then
    echo "Usage: $0 <device>"
    exit 1
elif [ $# -gt 1 ]; then
    sudo -v
fi

# Store the input argument in a variable
device=$1

echo "Update flake.lock file..."
nix flake lock --update-input ghaf

echo "Building..."
nix build .# --impure

if [ $? -eq 0 ] && [[ -n "$device" ]]; then
    echo "Flashing..."
    sync; umount /media/$USER/*; sudo dd if=result/disk1.raw of=$device bs=1M status=progress conv=fsync
fi

# End of script
