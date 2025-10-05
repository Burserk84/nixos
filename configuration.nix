{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      <home-manager/nixos>
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
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };

  # --- Key Binding Setting ---
  home-manager.users.user = { pkgs, ... }: {
  home.stateVersion = "23.11";

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Lock Screen";
        command = "loginctl lock-session";
        binding = "<Super>l";
      };
    };
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
    };
    setOptions = [
      "AUTO_CD"
    ];
    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "dirhistory" "history" ];
    };
  };

  # --- SERVICES CONFIGURATION ---
  virtualisation.docker.enable = true;
  
  services.expressvpn.enable = true;
  services.dbus.packages = with pkgs; [ expressvpn ];
  services.postgresql.enable = true;

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  # --- SYSTEM PACKAGES ---
  environment.systemPackages = with pkgs; [
   
    zsh-powerlevel10k

    
    git
    nodejs_20
    yarn
    postgresql

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

    zsh

    libGL
    electron
  ];

# --- nix-ld configuration ---
programs.nix-ld.enable = true;
programs.nix-ld.libraries = with pkgs; [
  # Core system
  stdenv.cc.cc
  glib
  atk
  at-spi2-atk
  cairo
  gtk3
  pango
  nspr
  nss
  dbus
  cups
  alsa-lib
  expat
  udev

  # X11 libraries
  xorg.libX11
  xorg.libXcomposite
  xorg.libXdamage
  xorg.libXext
  xorg.libXfixes
  xorg.libXrandr
  xorg.libxcb
  libxkbcommon

  # Mesa / OpenGL
  mesa
  libgbm

  # Optional utilities
  zlib
  libuuid
];


  system.stateVersion = "23.11"; # Note: Corrected from "25.05"
}
