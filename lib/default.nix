# lib/default.nix
# This file is the main entry point for the lib module.
{inputs, ...}: let
  # extend the nixpkgs lib with custom utilities
  lib = inputs.nixpkgs.lib.extend (final: prev: {
    myLib = import ./. {
      lib = final;
      inherit inputs;
    };
  });

  # home-manager library
  hmLib = inputs.home-manager.lib;

  # hosts: directory containing host-specific configurations
  hostsPath = ../hosts;
  hosts = {
    hostsPath = hostsPath;
    availableHosts = utils.discoverFolders hostsPath;
  };

  # users: directory containing user-specific configurations
  usersPath = ../users;
  users = {
    usersPath = usersPath;
    availableUsers = utils.discoverFolders usersPath;
  };

  # profiles: directory containing package and user profiles
  profilesPath = ../profiles;
  profiles = {
    # user profiles
    user = {
      userProfilesPath = "${profilesPath}/user";
      availableUserProfiles = utils.discoverNixFiles "${profilesPath}/user";
    };
    # package profiles
    packages = {
      packageProfilesPath = "${profilesPath}/packages";
      availablePackageProfiles =
        utils.discoverNixFiles "${profilesPath}/packages";
    };
  };

  # assets: directory for shared resources
  assetsDir = ../assets;

  # utilities and validations
  utils = import ./utils.nix {inherit inputs lib;};
  validations = import ./validations.nix {inherit lib;};
in {inherit hmLib hosts users profiles assetsDir utils validations;}
