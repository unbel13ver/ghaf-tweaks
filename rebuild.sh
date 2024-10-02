#!/bin/bash

echo "Update flake.lock file..."
nix flake update ghaf

echo "Building..."
# Replace default ghaf-host-my hostname with the actual IP or hostname !here
nixos-rebuild --flake .#x1custom-ghaf-debug --target-host root@ghaf-host-my --fast switch

# End of script
