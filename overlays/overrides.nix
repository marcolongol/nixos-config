{ inputs, ... }:

final: prev: {
  catppuccin-sddm = prev.catppuccin-sddm.override {
    flavor = "mocha";
    font = "JetBrainsMono Nerd Font";
    fontSize = "9";
    background = "${../assets/sddm/a_great_wave.jpg}";
    loginBackground = true;
  };
}
