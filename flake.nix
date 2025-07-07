{
  description = "My Nix flake";

  inputs = {
    # Nix ecosystem inputs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # home-manager - home user modules
    # https://github.com/nix-community/home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mission-control.url = "github:Platonic-Systems/mission-control";
    flake-root.url = "github:srid/flake-root";

    # nixvim - Neovim configuration framework
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flake-parts, nixpkgs, systems, ... }@inputs:
    let
      inherit (self) outputs;
      lib = import ./lib { inherit inputs; };
    in flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;
      imports = [
        inputs.mission-control.flakeModule
        inputs.flake-root.flakeModule
        ./tasks
      ];
      perSystem = { system, config, self', inputs', pkgs, ... }: {
        _module.args.pkgs = lib.utils.mkPkgsWithSystem system;
        devShells.default = import ./shell.nix { inherit config pkgs; };
        mission-control = { wrapperName = "run"; };
        formatter = pkgs.alejandra;
      };
      flake = {
        inherit outputs;
        nixosConfigurations = {
          nixos-wsl = lib.utils.mkSystem {
            hostname = "nixos-wsl";
            profiles = [ "development" "security" ];
            users = [{
              name = "lucas";
              profiles = [ "admin" "developer" ];
              extraGroups = [ "wheel" "docker" ];
            }];
            extraModules = [ inputs.nixos-wsl.nixosModules.wsl ];
          };
        };
        homeConfigurations = {
          lucas = lib.utils.mkHome {
            user = {
              name = "lucas";
              profiles = [ "admin" "developer" ];
            };
          };
        };
      };
    };
}
