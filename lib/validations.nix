# lib/validations.nix
# This file is used to define validation functions
{ lib, ... }:

{
  # Function to validate that a given hostname is available
  # It checks if the hostname exists in the hosts folder AND
  # if there is a configuration.nix file in the expected path
  # If either check fails, it throws an error
  # Example usage: validateHostname "my-hostname"
  validateHostname = hostname:
    let
      hostAvailable = lib.elem hostname lib.myLib.hosts.availableHosts;
      configPath = "${lib.myLib.hosts.hostsPath}/${hostname}/configuration.nix";
      configExists = builtins.pathExists configPath;
    in if !hostAvailable then
      throw
      "Hostname '${hostname}' is not available in hosts module. Available hostnames: ${
        lib.concatStringsSep ", " lib.myLib.hosts.availableHosts
      }"
    else if !configExists then
      throw
      "Configuration file not found at '${configPath}' for hostname '${hostname}'"
    else
      true;

  # Function to validate that the provided package profiles are valid
  # It checks if each profile exists in the available profiles list
  # If any profile is invalid, it throws an error
  # Example usage: validatePackageProfiles [ "common" "web" ]
  validatePackageProfiles = profiles:
    let
      # Get the list of available profiles from the library
      availableProfiles = lib.myLib.profiles.packages.availablePackageProfiles;
      # Helper function to check if a profile exists
      profileExists = profile:
        builtins.pathExists ''
          ${lib.myLib.profiles.packages.packagesProfilesPath}/${profile}.nix
        '';
      # Filter out invalid profiles
      invalidProfiles =
        builtins.filter (profile: !lib.elem profile availableProfiles) profiles;
      # Check for profiles that do not have corresponding profile.nix files
      invalidProfileFiles =
        builtins.filter (profile: !profileExists profile) invalidProfiles;
    in if invalidProfiles != [ ] then
    # Throw an error if there are invalid profiles
      throw "Invalid package profiles: ${
        lib.concatStringsSep ", " invalidProfiles
      }. Available profiles: ${lib.concatStringsSep ", " availableProfiles}"
    else if invalidProfileFiles != [ ] then
    # Throw an error if there are profiles without corresponding profile.nix files
      throw "Profile files not found for: ${
        lib.concatStringsSep ", " invalidProfileFiles
      }. Available profiles: ${lib.concatStringsSep ", " availableProfiles}"
    else
      true;

  # Function to validate that the provided user profiles are valid
  # It checks if each profile exists in the available user profiles list
  # If any profile is invalid, it throws an error
  # Example usage: validateUserProfiles [ "base" "developer" ]
  validateUserProfiles = profiles:
    let
      # Get the list of available user profiles from the library
      availableUserProfiles = lib.myLib.profiles.user.availableUserProfiles;
      # Helper function to check if a profile exists
      profileExists = profile:
        builtins.pathExists ''
          ${lib.myLib.profiles.user.userProfilesPath}/${profile}.nix
        '';
      # Filter out invalid profiles
      invalidProfiles =
        builtins.filter (profile: !lib.elem profile availableUserProfiles)
        profiles;
      # Check for profiles that do not have corresponding profile.nix files
      invalidProfileFiles =
        builtins.filter (profile: !profileExists profile) invalidProfiles;
    in if invalidProfiles != [ ] then
      throw "Invalid user profiles: ${
        lib.concatStringsSep ", " invalidProfiles
      }. Available profiles: ${lib.concatStringsSep ", " availableUserProfiles}"
    else if invalidProfileFiles != [ ] then
      throw "Profile files not found for: ${
        lib.concatStringsSep ", " invalidProfileFiles
      }. Available profiles: ${lib.concatStringsSep ", " availableUserProfiles}"
    else
      true;

  # Function to validate that the provided users are valid
  # It checks if each user exists in the available users list
  # It also checks if each user has valid profiles
  # and if the user configuration file exists
  # If any user is invalid, it throws an error
  # Example usage: validateUsers [{ name = "lucas"; profiles = [ "base" ]; } { name = "alice"; profiles = [ "base" "developer" ]; }]
  validateUsers = users:
    let
      # Get the list of available users from the library
      availableUsers = lib.myLib.users.availableUsers;
      # Helper function to check if a user exists
      userExists = user: lib.elem user.name availableUsers;
      # Helper function to check if a profile exists for a user
      profileExists = profile:
        lib.myLib.validations.validateUserProfiles [ profile ];
      # Check for invalid users and profiles
      invalidUsers = builtins.filter (user: !userExists user) users;
      invalidProfiles =
        builtins.filter (user: !lib.all (profileExists) user.profiles) users;
      # Check if user configuration files exist
      userConfigExists = user:
        builtins.pathExists "${lib.myLib.users.usersPath}/${user.name}";
      invalidUserConfigs = builtins.filter (user: !userConfigExists user) users;
    in if invalidUsers != [ ] then
      throw "Invalid users: ${
        lib.concatStringsSep ", " (map (user: user.name) invalidUsers)
      }. Available users: ${lib.concatStringsSep ", " availableUsers}"
    else if invalidProfiles != [ ] then
      throw "Invalid profiles for users: ${
        lib.concatStringsSep ", " (map (user:
          user.name + " (" + lib.concatStringsSep ", " user.profiles + ")")
          invalidProfiles)
      }. Available profiles: ${
        lib.concatStringsSep ", " lib.myLib.users.availableUserProfiles
      }"
    else if invalidUserConfigs != [ ] then
      throw "User configuration files not found for: ${
        lib.concatStringsSep ", " (map (user: user.name) invalidUserConfigs)
      }. Available users: ${lib.concatStringsSep ", " availableUsers}"
    else
      true;

}
