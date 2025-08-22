{inputs, ...}: final: prev: {
  custom = {
    nixvim = let
      nixvimModule = import ../modules/nixvim {inherit inputs;};
    in
      inputs.nixvim.legacyPackages."${final.stdenv.hostPlatform.system}".makeNixvimWithModule {
        module = nixvimModule;
        pkgs = final;
      };
  };
}
