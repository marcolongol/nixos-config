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
    path = hostsPath;
    available = utils.discoverFolders hostsPath;
  };

  usersPath = ../users;
  users = {
    path = usersPath;
    available = utils.discoverFolders usersPath;
  };

  profilesPath = ../profiles;
  profiles = {
    user = {
      path = "${profilesPath}/user";
      available = utils.discoverNixFiles "${profilesPath}/user";
    };
    packages = {
      path = "${profilesPath}/packages";
      available = utils.discoverNixFiles "${profilesPath}/packages";
    };
  };

  utils = import ./utils.nix { inherit inputs lib; };
  validations = import ./validations.nix { inherit lib; };

in { inherit hosts users profiles utils validations; }
