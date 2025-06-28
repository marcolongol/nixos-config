# Overlays - modify nixpkgs with custom packages and overrides
# These overlays have access to flake inputs for advanced compositions
{ inputs, ... }:

let
  # Helper function to create overlays that can access flake inputs
  mkOverlay = path: import path { inherit inputs; };

  # Automatically discover all .nix files in this directory except default.nix
  overlayFiles = let
    # Get all files in the current directory
    dirContents = builtins.readDir ./.;
    # Filter to only .nix files, excluding default.nix
    nixFiles = builtins.filter
      (name: (builtins.match ".*.nix$" name != null) && (name != "default.nix"))
      (builtins.attrNames dirContents);
  in nixFiles;

  # Convert file names to overlay functions
  fileOverlays = map (file: mkOverlay (./. + "/${file}")) overlayFiles;

  # External overlays from flake inputs
  externalOverlays = [
    # Nixvim overlay - provides nixvim packages
    inputs.nixvim.overlays.default
  ];
  # Combine external overlays with automatically discovered file overlays
in externalOverlays ++ fileOverlays
