{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib.myLib.users) availableUsers usersPath;
  inherit (lib.myLib.profiles.user) availableUserProfiles userProfilesPath;

  cfg = config.myUsers;

  userType = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.enum availableUsers;
        description = ''
          Name of the user to be configured.
          You can create a new user profile under ${userProfilesPath}.
          Available users: ${lib.concatStringsSep ", " availableUsers}
        '';
      };
      profiles = lib.mkOption {
        type = lib.types.listOf (lib.types.enum availableUserProfiles);
        description = ''
          List of user profiles to apply to the user.
          The 'base' profile is always included by default.
          You can create new profiles under ${userProfilesPath}.
          Available profiles: ${lib.concatStringsSep ", " availableUserProfiles}
        '';
        default = ["base"];
      };
      extraGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
          Additional groups to which the user should be added.
          This is useful for granting extra permissions or access.
        '';
        default = [];
      };
      initialPassword = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Initial password for the user. If not set, the user will not have a password.
          You can set this to a secure password or leave it empty for no password.
        '';
      };
      hashedPassword = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Hashed password for the user. Takes precedence over initialPassword.
          Generate with: mkpasswd -m sha-512
          This is the secure way to set passwords that persists with impermanence.
        '';
      };
    };
  };
in {
  options.myUsers = {
    enable = lib.mkOption {
      type = lib.types.listOf userType;
      default = [];
      description = ''
        List of users to be configured in the system.
        Each user can have multiple profiles and extra groups.
        Available users: ${lib.concatStringsSep ", " availableUsers}
        Available profiles: ${lib.concatStringsSep ", " availableUserProfiles}
      '';
      example = [
        {
          name = "lucas";
          profiles = ["base"];
          extraGroups = ["wheel"];
        }
        {
          name = "alice";
          profiles = ["base" "developer"];
          extraGroups = ["docker"];
        }
      ];
    };
  };

  config = lib.mkIf (cfg.enable != []) {
    # system wide
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    # Create system users
    users.users = lib.listToAttrs (map
      (userConfig: {
        name = userConfig.name;
        value = {
          isNormalUser = true;
          description = userConfig.name;
          extraGroups = userConfig.extraGroups;
          hashedPassword = userConfig.hashedPassword;
          initialPassword = lib.mkIf (userConfig.hashedPassword == null) userConfig.initialPassword;
        };
      })
      cfg.enable);

    home-manager.backupFileExtension = "bak";

    # Configure home-manager for each user
    home-manager.users = lib.listToAttrs (map
      (userConfig: {
        name = userConfig.name;
        value = lib.mkMerge [
          # Always import base profile
          (import (userProfilesPath + "/base.nix") {
            inherit pkgs lib inputs;
            inherit userConfig;
            osConfig = config;
          })

          # Import additional user profiles (excluding base to avoid duplication)
          (lib.mkMerge (map
            (profile:
              if profile != "base"
              then
                import (userProfilesPath + "/${profile}.nix")
                {
                  inherit pkgs lib inputs;
                  inherit userConfig;
                  osConfig = config;
                }
              else {})
            userConfig.profiles))

          # Import individual user configuration if it exists
          (import (usersPath + "/${userConfig.name}") {
            inherit pkgs lib inputs;
            inherit userConfig;
            osConfig = config;
          })
        ];
      })
      cfg.enable);
  };
}
