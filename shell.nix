{
  config ? null,
  pkgs ? import <nixpkgs> {},
  ...
}:
pkgs.mkShell {
  inputsFrom =
    if config != null
    then [
      config.mission-control.devShell
      config.flake-root.devShell
    ]
    else [];
  buildInputs = with pkgs; [];
}
