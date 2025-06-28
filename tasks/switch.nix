{ ... }:

# The SWITCH Task

{
  perSystem = { pkgs, ... }: {
    mission-control.scripts = {
      "switch" = {
        description =
          "Switch the configuration on the current supported system or specified";
        category = "System Management";

        exec = pkgs.writeShellApplication {
          name = "tasks-switch";

          runtimeInputs = [
            pkgs.nixos-install-tools
            pkgs.openssh
            pkgs.nixos-rebuild
            pkgs.gnused
            pkgs.git
          ];

          text = ''
            #!${pkgs.runtimeShell}

            set -euo pipefail

            # Check if the system is supported
            if ! command -v nixos-rebuild &> /dev/null; then
              echo "This script can only be run on NixOS systems."
              exit 1
            fi

            # Check for the first argument
            if [ $# -eq 0 ]; then
              echo "Usage: ${pkgs.nixos-install-tools}/bin/switch <system>"
              exit 1
            fi

            SYSTEM="$1"

            # Switch to the specified system configuration
            echo "Switching to system: $SYSTEM"
            sudo nixos-rebuild switch --flake ".#$SYSTEM"
          '';
        };
      };
    };
  };
}
