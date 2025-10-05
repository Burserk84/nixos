{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "amiralidev";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Tehran";
  i18n.defaultLocale = "en_US.UTF-8";

  services.libinput.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # --- USER CONFIGURATION ---
  users.users.user = {
    isNormalUser = true;
    description = "Amirali Sharifi Asl";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh; # Zsh is set as the user shell
    packages = with pkgs; [ ];
  };

  # --- ZSH MODULE & POWERLEVEL10K CONFIGURATION ---
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 10000;
    shellAliases = {
      # ... Your aliases go here
    };
    setOptions = [
      "AUTO_CD"
    ];
    # The Powerlevel10k theme initialization
    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "dirhistory" "history" ];
    };
  };

  # --- SERVICES CONFIGURATION (Moved out of systemPackages) ---
  virtualisation.docker.enable = true; # <-- FIX: Moved here
  
  services.expressvpn.enable = true;
  services.dbus.packages = with pkgs; [ expressvpn ];
  services.postgresql.enable = true;

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  # --- SYSTEM PACKAGES ---
  environment.systemPackages = with pkgs; [
    # Packages from Powerlevel10k snippet
    zsh-powerlevel10k

    # Your existing packages
    git
    nodejs_20
    yarn
    postgresql
    # virtualisation.docker.enable = true; <-- REMOVED FROM HERE

    expressvpn
    google-chrome
    tor-browser

    telegram-desktop

    vscode
    obsidian

    qbittorrent
    evince
    pkgs.gnome-tweaks
    steam-run

    zsh # Explicitly include zsh package (Note: This is often not strictly needed when programs.zsh.enable = true)
  ];
  
  system.stateVersion = "23.11"; # Note: Corrected from "25.05"
}
