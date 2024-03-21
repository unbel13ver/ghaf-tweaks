# Ghaf devenv tweaks

### How to
1. Clone Ghaf somewhere.
2. Clone this repo somewhere and `cd` into it's directory.
3. Run `grep -rA 2 "\!here" .` to see what you should change according to your env.
4. Connect a media device to your PC and run `./buildandflash.sh /dev/sdX` to build the Ghaf image containing your tweaks.
5. After booting this image it is possible to run `nixos-rebuild` by `./rebuild.sh` script.
