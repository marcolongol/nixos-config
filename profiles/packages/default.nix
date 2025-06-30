{ config, lib, pkgs, ... }:
let
  inherit (lib.myLib.profiles.packages)
    availablePackageProfiles packageProfilesPath;

  cfg = config.packageProfiles;
in {
  options.packageProfiles = {
    enable = lib.mkOption {
      type = lib.types.listOf (lib.types.enum availablePackageProfiles);
      default = [ "base" ];
      description = ''
        List of package profiles to include in the system configuration.
        The 'base' profile is always included by default.
        You can add additional profiles as needed.
        Available profiles: ${
          lib.concatStringsSep ", " availablePackageProfiles
        }
      '';
      example = [ "base" "development" ];
    };
  };

  config = lib.mkMerge ([
    # Ensure 'base' package profile is always included
    (import "${packageProfilesPath}/base.nix" { inherit config lib pkgs; })
  ] ++
    # Include additional profiles based on the configuration
    (map (profile:
      lib.mkIf (lib.elem profile cfg.enable)
      (import "${packageProfilesPath}/${profile}.nix" {
        inherit config lib pkgs;
      })) availablePackageProfiles));
}
