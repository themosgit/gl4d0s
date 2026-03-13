{

  description = "NixOS conf for gl4d0s lil bitch";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niks3 = {
      url = "github:Mic92/niks3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      hyprland,
      sops-nix,
      niks3,
      ...
    }@inputs:
    {

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        packages = [
          nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style
        ];
      };

      nixosConfigurations = {
        gl4d0s = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };

          modules = [

            ./modules/hardware-configuration.nix
            ./modules/system

            sops-nix.nixosModules.sops
            { sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ]; }

            niks3.nixosModules.default

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.themos = import ./modules/home;
            }
            hyprland.nixosModules.default
          ];
        };
      };
    };
}
