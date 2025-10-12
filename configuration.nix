{ config, pkgs, ... }:

{
  imports = [
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

  # Audio (PipeWire / Pulse)
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

  # --- Home Manager user config (GNOME keybinding: Super+L = Lock) ---
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

  # --- ZSH + P10K ---
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 10000;
    shellAliases = { };
    setOptions = [ "AUTO_CD" ];
    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "dirhistory" "history" ];
    };
  };

  # --- SERVICES ---
  virtualisation.docker.enable = true;

  services.expressvpn.enable = true;
  services.dbus.packages = with pkgs; [ expressvpn ];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    dataDir = "/var/lib/postgresql/17";
  };

  # SSH: configuration to connect with client to server
  # services.openssh.enable = true;

  # --- Nix / Nixpkgs ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;

  # --- SYSTEM PACKAGES ---
  environment.systemPackages = with pkgs; [
    # zsh visual
    zsh-powerlevel10k

    # Dev packages
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
    gnome-tweaks
    steam-run
    libreoffice-fresh
    spotify-player
    libGL
    electron

    # Wine
    wineWowPackages.stable
    winetricks
    bottles

    # --- CLI ---
    vim
    gzip unzip zip p7zip
    curl wget rsync openssh gnupg
    jq yq tree ripgrep fd bat eza fzf
    htop ncdu duf tmux which file

    # Dev extras
    docker-compose
    pkg-config gcc

    # GStreamer codecs (for video/audio in GNOME)
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav

  ];

  # fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome
    roboto
    fira-code
  ];

  # --- nix-ld configuration ---
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Core system
    stdenv.cc.cc
    glib atk at-spi2-atk cairo gtk3 pango nspr nss dbus cups alsa-lib expat udev
    # X11
    xorg.libX11 xorg.libXcomposite xorg.libXdamage xorg.libXext xorg.libXfixes
    xorg.libXrandr xorg.libxcb libxkbcommon
    # Mesa / OpenGL
    mesa libgbm
    # Optional
    zlib libuuid
  ];

  system.stateVersion = "23.11";
}
