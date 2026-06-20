{ config, pkgs, inputs, ... }:

{
  home.username = "subhro";
  home.homeDirectory = "/home/subhro";

  # Import Noctalia's custom commands so Home Manager understands them
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.packages = [
  	inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # --- THE MAGIC SYMLINKS ---
  # This grabs the folders from your current Git repo directory 
  # and securely links them into your ~/.config/ folder
  home.file = {
    ".config/hypr".source = ./hypr;
    ".config/kitty".source = ./kitty;
    ".config/wallust".source = ./wallust;
   # ".config/noctalia".source = ./noctalia;
   # ".config/starship.toml".source = ./starship.toml;
    ".zshrc".source = ./.zshrc;
  };

  # Enables the Noctalia Shell background service
  programs.noctalia-shell.enable = true;

  # Required for Home Manager to function
  programs.home-manager.enable = true;

  home.stateVersion = "26.05"; 
}
