# lib/utils.nix
# This file is used to define utility functions
{ inputs, lib, ... }: {
  # Function to retrieve all Nix files in a given path
  # It filters out 'default.nix' and returns the names without the '.nix' suffix
  # If the path does not exist, it throws an error
  # Example usage: discoverNixFiles ./modules
  discoverNixFiles = path:
    if builtins.pathExists path then
      let
        nixFiles = builtins.filter
          (name: lib.hasSuffix ".nix" name && name != "default.nix")
          (lib.attrNames (builtins.readDir path));
      in if nixFiles == [ ] then
        throw "No Nix files found in: ${toString path}"
      else
        map (lib.removeSuffix ".nix") nixFiles
    else
      throw "Path does not exist: ${toString path}";

  # Function to retrieve all folders in a given path
  # It filters out non-directory entries and returns the names
  # If the path does not exist, it throws an error
  # Example usage: discoverFolders ./hosts
  discoverFolders = path:
    if builtins.pathExists path then
      let
        dirContents = builtins.readDir path;
        folders = builtins.filter (name: dirContents.${name} == "directory")
          (builtins.attrNames dirContents);
      in if folders == [ ] then
        throw "No folders found in: ${toString path}"
      else
        folders
    else
      throw "Path does not exist: ${toString path}";

  # Function to make a Nixpkgs package set for a given system
  # It imports the Nixpkgs flake with the specified system and allows unfree
  # packages. It returns a function that can be used to access packages.
  # Example usage: mkPkgsWithSystem "x86_64-linux"
  mkPkgsWithSystem = system:
    import inputs.nixpkgs {
      inherit system;
      overlays = import ../overlays { inherit inputs; };
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };

  mkSystem = { system ? "x86_64-linux", hostname, profiles ? [ "base" ]
    , users ? [ ], extraModules ? [ ], enableValidation ? true }:

    # Validate the hostname and profiles if enableValidation is true
    assert !enableValidation || lib.myLib.validations.validateHostname hostname;
    assert !enableValidation
      || lib.myLib.validations.validatePackageProfiles profiles;
    assert !enableValidation || lib.myLib.validations.validateUsers users;

    # Returns a NixOS system configuration
    lib.nixosSystem {
      inherit system;
      pkgs = lib.myLib.utils.mkPkgsWithSystem system;
      specialArgs = { inherit inputs hostname; };
      modules = [
        (lib.myLib.hosts.hostsPath + "/${hostname}/configuration.nix")
        (lib.myLib.profiles.packages.packageProfilesPath)
        inputs.home-manager.nixosModules.home-manager
        (lib.myLib.users.usersPath)
        {
          packageProfiles.enable = profiles;
          myUsers.enable = users;
        }
      ] ++ extraModules;
    };

    mkHome = { user, system ? "x86_64-linux", extraModules ? [ ] }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit lib;
        pkgs = lib.myLib.utils.mkPkgsWithSystem system;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          # Import base profile (always included)
          (import (lib.myLib.profiles.user.userProfilesPath + "/base.nix") {
            inherit lib;
            pkgs = lib.myLib.utils.mkPkgsWithSystem system;
            userConfig = user;
          })
          
          # Import additional user profiles
        ] ++ (map (profile:
          if profile != "base" then
            import (lib.myLib.profiles.user.userProfilesPath + "/${profile}.nix") {
              inherit lib;
              pkgs = lib.myLib.utils.mkPkgsWithSystem system;
              userConfig = user;
            }
          else
            { }) user.profiles) ++ [
          
          # Import individual user configuration
          (lib.myLib.users.usersPath + "/${user.name}")
        ] ++ extraModules;
      };

}
