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
            ({pkgs, ...} :
              {
                # Add your packages !here
                environment.systemPackages = [
                  pkgs.vim
                  pkgs.strace
                ];
              })
            {
              users.users.root.openssh.authorizedKeys.keys = [
                # Add your SSH public key !here
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEa7sgJ6XQ58B5bHAc8dahWhCRVOFZ2z5pOCk4g+RLfw ivan.nikolaenko@unikie.com"
              ];
              users.users."ghaf".openssh.authorizedKeys.keys = [
                # Add your SSH public key !here
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEa7sgJ6XQ58B5bHAc8dahWhCRVOFZ2z5pOCk4g+RLfw ivan.nikolaenko@unikie.com"
              ];
            }
          ];
        };
        packages.x86_64-linux.default = self.nixosConfigurations.x1custom-ghaf-debug.config.system.build.diskoImages;
      }
    ];
}
