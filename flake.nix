{
  description = "My Nix flake";

  inputs = {
    # Nix ecosystem inputs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    mission-control.url = "github:Platonic-Systems/mission-control";
    flake-root.url = "github:srid/flake-root";

    # home-manager - home user modules
    # https://github.com/nix-community/home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # impermanence - NixOS module for managing ephemeral systems
    # https://github.com/nix-community/impermanence
    impermanence = { url = "github:nix-community/impermanence"; };

    # disko - Declarative disk partitioning
    # https://github.com/nix-community/disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixvim - Neovim configuration framework
    # https://github.com/nix-community/nixvim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos-generators - Generate images for multiple formats
    # https://github.com/nix-community/nixos-generators
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , flake-parts
    , nixpkgs
    , systems
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      lib = import ./lib { inherit inputs; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;
      imports = [
        inputs.mission-control.flakeModule
        inputs.flake-root.flakeModule
        ./tasks
      ];
      perSystem =
        { system
        , config
        , pkgs
        , ...
        }: {
          _module.args.pkgs = lib.utils.mkPkgsWithSystem system;
          devShells.default = import ./shell.nix { inherit config pkgs; };
          mission-control = { wrapperName = "run"; };
          formatter = pkgs.alejandra;
        };
      flake = {
        inherit outputs;
        # SECTION: Nixos Configurations
        # ----------------------------------------------------------------------
        nixosConfigurations = {
          # nixos-wsl: NixOS configuration for WSL (Windows Subsystem for Linux)
          nixos-wsl = lib.utils.mkSystem {
            hostname = "nixos-wsl";
            profiles = [ "development" "security" ];
            users = [
              {
                name = "lucas";
                profiles = [ "admin" "developer" ];
                extraGroups = [ "wheel" "docker" ];
              }
            ];
            extraModules = [ inputs.nixos-wsl.nixosModules.wsl ];
          };
          # nixos-lt: NixOS configuration for my laptop
          nixos-lt = lib.utils.mkSystem {
            hostname = "nixos-lt";
            profiles = [ "desktop" "development" "security" ];
            users = [
              {
                name = "lucas";
                profiles = [ "admin" "developer" ];
                extraGroups = [ "wheel" "docker" ];
              }
            ];
            extraModules = [ ./modules/nvidia ];
          };
          # nixos-livecd: NixOS configuration for live CD image
          nixos-livecd = lib.utils.mkSystem {
            hostname = "nixos-livecd";
            profiles = [ "livecd" ];
            extraModules = [
              inputs.nixos-generators.nixosModules.all-formats
              ./modules/image-formats.nix
            ];
            enableValidation = false; # Disable validation for image builds
          };
        };
        # SECTION: Home Manager Configurations
        # ----------------------------------------------------------------------
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
