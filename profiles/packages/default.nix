{ config, lib, pkgs, ... }:
let
  inherit (lib.myLib.profiles.packages) available path;

  cfg = config.packageProfiles;
in {
  options.packageProfiles = {
    enable = lib.mkOption {
      type = lib.types.listOf (lib.types.enum available);
      default = [ "base" ];
      description = ''
        List of package profiles to include in the system configuration.
        The 'base' profile is always included by default.
        You can add additional profiles as needed.
        Available profiles: ${lib.concatStringsSep ", " available}
      '';
      example = [ "base" "development" ];
    };
  };

  config = lib.mkMerge ([
    # Ensure 'base' package profile is always included
    (import "${path}/base.nix" { inherit config lib pkgs; })
  ] ++
    # Include additional profiles based on the configuration
    (map (profile:
      lib.mkIf (lib.elem profile cfg.enable)
      (import "${path}/${profile}.nix" { inherit config lib pkgs; }))
      available));
}
