{
  description = "x1custom - Ghaf based configuration";

  nixConfig = {
    substituters = [
      "https://cache.vedenemo.dev"
      "https://cache.ssrcdevops.tii.ae"
      "https://ghaf-dev.cachix.org"
      "https://cache.nixos.org/"
    ];
    extra-trusted-substituters = [
      "https://cache.vedenemo.dev"
      "https://cache.ssrcdevops.tii.ae"
      "https://ghaf-dev.cachix.org"
      "https://cache.nixos.org/"
    ];
    extra-trusted-public-keys = [
      "cache.vedenemo.dev:8NhplARANhClUSWJyLVk4WMyy1Wb4rhmWW2u8AejH9E="
      "cache.ssrcdevops.tii.ae:oOrzj9iCppf+me5/3sN/BxEkp5SaFkHfKTPPZ97xXQk="
      "ghaf-dev.cachix.org-1:S3M8x3no8LFQPBfHw1jl6nmP8A7cVWKntoMKN3IsEQY="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    # Adjust this path to point your ghaf local repo !here
    ghaf.url = "path:/home/ivann/devel/NIXOS/ghaf";
  };

  outputs = {
    self,
    ghaf,
    nixpkgs,
    flake-utils,
  }: let
    systems = with flake-utils.lib.system; [
      x86_64-linux
    ];
  in
    nixpkgs.lib.foldr nixpkgs.lib.recursiveUpdate {} [
      (flake-utils.lib.eachSystem systems (system: {
        formatter = nixpkgs.legacyPackages.${system}.alejandra;
      }))

      {
        nixosConfigurations.x1custom-ghaf-debug = ghaf.nixosConfigurations.lenovo-x1-carbon-gen11-debug.extendModules {
          modules = [
            ({pkgs, lib, ...} :
              {
                # Add your packages !here
                environment.systemPackages = with pkgs; [
                  vim
                  strace
                  parted
                  e2fsprogs
                  gptfdisk
                  lsof
                  jq
                ];

	      ghaf.graphics.labwc.autolock.enable = lib.mkOverride 10 false;
              users.users.root.openssh.authorizedKeys.keys = lib.mkForce [
                # Add your SSH public key !here
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEa7sgJ6XQ58B5bHAc8dahWhCRVOFZ2z5pOCk4g+RLfw ivan.nikolaenko@unikie.com"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGi5EE8vbnLUC5zzCCwaI2s+JVHi86jQwUYpPNF3/AJc ivan@ono-sendai"
              ];
              users.users."ghaf".openssh.authorizedKeys.keys = lib.mkForce [
                # Add your SSH public key !here
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEa7sgJ6XQ58B5bHAc8dahWhCRVOFZ2z5pOCk4g+RLfw ivan.nikolaenko@unikie.com"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGi5EE8vbnLUC5zzCCwaI2s+JVHi86jQwUYpPNF3/AJc ivan@ono-sendai"
              ];
            })
          ];
        };
        packages.x86_64-linux.default = self.nixosConfigurations.x1custom-ghaf-debug.config.system.build.diskoImages;
      }
    ];
}
