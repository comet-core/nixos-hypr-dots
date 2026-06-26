{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # --- 1. BOOTLOADER & KERNEL ---
 # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # --- SECURE BOOT (LANZABOOTE) ---
  boot.loader.systemd-boot.enable = pkgs.lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  # --- 2. NETWORKING & LOCALE ---
  networking.hostName = "nixos"; 
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Kolkata";
  time.hardwareClockInLocalTime = true;
  i18n.defaultLocale = "en_IN";

  # --- 3. NIX CORE & FLAKES ---
  # This officially unlocks modern NixOS Flake commands
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # --- 4. GRAPHICS & NVIDIA (RTX 4070 Setup) ---
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true; # Mandatory for Hyprland/Wayland
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false; # Forces proprietary drivers
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # --- 5. DESKTOP ENVIRONMENTS & COMPOSITORS ---
  # Keeps your KDE Plasma 6 backup safe and sound
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Explicitly enables Hyprland at the OS level
  # This is crucial because it automatically configures PAM, XWayland, and Wayland Portals
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # --- 6. AUDIO (PIPEWIRE) ---
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # --- 7. USER ACCOUNT & SHELL ---
  # We must enable zsh system-wide before setting it as a default shell
  programs.zsh.enable = true; 

  users.users.subhro = {
    isNormalUser = true;
    description = "Subhro";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    shell = pkgs.zsh; # Automatically drops you into Zsh instead of Bash
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # --- GAMING SETUP ---
     programs.steam = {
       enable = true;
       remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
       dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
     };
     
     # Enables gamemode for background optimization
     programs.gamemode.enable = true;

  # --- 8. SYSTEM PACKAGES ---
  # I pulled these directly from the structure of your GitHub repo
  environment.systemPackages = with pkgs; [
    # System Utilities
    git
    micro
    fastfetch
    wget
    sbctl
    grim slurp wl-clipboard
    brave
    vscode
    vesktop
    
    # Your Rice Dependencies
    kitty         # GPU-accelerated terminal
    starship      # Cross-shell prompt
    wallust       # Dynamic color scheme generator
    
    # Zsh Plugins (required for your .zshrc)
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
  services.flatpak.enable = true;

  # --- 9. STATE VERSION ---
  system.stateVersion = "26.05";
}
