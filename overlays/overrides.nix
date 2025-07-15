{ inputs, ... }: final: prev: {
  catppuccin-sddm = prev.catppuccin-sddm.override {
    flavor = "mocha";
    font = "MesloLGS Nerd Font";
    fontSize = "9";
    background = "${../assets/wallpapers/wallhaven-0175w1.jpg}";
    loginBackground = true;
  };
}
