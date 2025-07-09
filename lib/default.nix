# lib/default.nix
# This file is the main entry point for the lib module.
{ inputs, ... }:
let
  # SECTION: IMPORTS
  # ----------------------------------------------------------------------
  # Importing the necessary modules and utilities.
  lib = inputs.nixpkgs.lib.extend (final: prev: {
    myLib = import ./. {
      lib = final;
      inherit inputs;
    };
  });

  hostsPath = ../hosts;
  hosts = {
    hostsPath = hostsPath;
    availableHosts = utils.discoverFolders hostsPath;
  };

  usersPath = ../users;
  users = {
    usersPath = usersPath;
    availableUsers = utils.discoverFolders usersPath;
  };

  profilesPath = ../profiles;
  profiles = {
    user = {
      userProfilesPath = "${profilesPath}/user";
      availableUserProfiles = utils.discoverNixFiles "${profilesPath}/user";
    };
    packages = {
      packageProfilesPath = "${profilesPath}/packages";
      availablePackageProfiles =
        utils.discoverNixFiles "${profilesPath}/packages";
    };
  };

  # Assets directory for shared resources
  assetsDir = ../assets;

  utils = import ./utils.nix { inherit inputs lib; };
  validations = import ./validations.nix { inherit lib; };

in { inherit hosts users profiles assetsDir utils validations; }
