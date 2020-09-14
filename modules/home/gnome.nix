{ pkgs, ... }:
let 
hasGUI = (import <nixpkgs/nixos> { }).config.services.xserver.enable;
in 
if hasGUI then {
  home.packages = with pkgs; [ 
    gnome3.gnome-tweaks
  ];

  qt = {
    enable = true;
    platformTheme = "gnome";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Pop-dark";
      package = pkgs.pop-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
} 
else { }
