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
      hostAvailable = lib.elem hostname lib.myLib.hosts.available;
      configPath = "${lib.myLib.hosts.path}/${hostname}/configuration.nix";
      configExists = builtins.pathExists configPath;
    in if !hostAvailable then
      throw
      "Hostname '${hostname}' is not available in hosts module. Available hostnames: ${
        lib.concatStringsSep ", " lib.myLib.hosts.available
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
      availableProfiles = lib.myLib.profiles.packages.available;
      # Helper function to check if a profile exists
      profileExists = profile:
        builtins.pathExists ''
          ${lib.myLib.profiles.packages.path}/${profile}.nix
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
}
