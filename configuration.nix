{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader (UEFI + systemd-boot)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname & Networking
  networking.hostName = "amiralidev";
  networking.networkmanager.enable = true;

  # Locale & Timezone
  time.timeZone = "Asia/Tehran";
  i18n.defaultLocale = "en_US.UTF-8";

  # Input
  services.libinput.enable = true;

  # Display server + GNOME (Wayland)
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true; # prefer Wayland
  services.xserver.desktopManager.gnome.enable = true;

  # Keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Printing
  services.printing.enable = true;

  # CPU microcode
  hardware.cpu.intel.updateMicrocode = true;

  # Graphics / VA-API (Mesa + Intel iHD)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver   # VA-API iHD
      vaapiVdpau           # VAAPI→VDPAU bridge
      libvdpau-va-gl
      mesa                 # modern Mesa bundle
    ];
  };

  # Kernel parameters
  boot.kernelParams = [
    "i915.enable_psr=0"       # avoid PSR stutter
    "i915.enable_guc=3"       # GuC/HuC scheduling
    "usbcore.autosuspend=-1"  # stable mouse/dongles
  ];

  # Power & thermals (balanced & cooler)
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_HWP_ON_AC = "balance_performance";
      CPU_HWP_ON_BAT = "balance_power";
      CPU_BOOST_ON_AC = "1";   # allow Turbo on AC
      CPU_BOOST_ON_BAT = "0";  # cooler on battery
      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "quiet";
      USB_AUTOSUSPEND = "0";   # avoid input dropouts
    };
  };
  powerManagement.cpuFreqGovernor = "schedutil";
  services.power-profiles-daemon.enable = false; # no conflict with TLP
  services.thermald.enable = true;               # Intel thermal tuning
  services.irqbalance.enable = true;             # spread IRQs
  powerManagement.powertop.enable = false;       # no auto-tune (USB issues)
  services.fstrim.enable = true;                 # weekly SSD TRIM

  # Keep Turbo allowed at boot (safety net)
  systemd.tmpfiles.rules = [
    "w /sys/devices/system/cpu/intel_pstate/no_turbo - - - - 0"
  ];

  # PipeWire audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Wayland + VAAPI hints for Chrome/Chromium
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";  # prefer Wayland for Chromium-based apps
    LIBVA_DRIVER_NAME = "iHD"; # force Intel VAAPI driver
  };

  # Enable setuid sandbox for Chrome (GPU/VAAPI stability)
  security.chromiumSuidSandbox.enable = true;

  # Users
  users.users.user = {
    isNormalUser = true;
    description = "Amirali Sharifi Asl";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };

  # Home Manager (GNOME lock shortcut)
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

  # Zsh + Powerlevel10k
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 10000;
    setOptions = [ "AUTO_CD" ];
    shellAliases = { };
    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "dirhistory" "history" ];
    };
  };

  # Services
  virtualisation.docker.enable = true;

  services.expressvpn.enable = true;
  services.dbus.packages = with pkgs; [ expressvpn ];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    dataDir = "/var/lib/postgresql/17";
  };

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Browser
  programs.firefox.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # shells/themes
    zsh-powerlevel10k

    # dev
    git nodejs_20 yarn postgresql

    # apps
    google-chrome expressvpn tor-browser telegram-desktop vscode obsidian
    qbittorrent evince gnome-tweaks steam-run libreoffice-fresh spotify-player
    libGL electron obs-studio kdePackages.kdenlive ffmpeg-full rar

    # wine
    wineWowPackages.stable winetricks bottles

    # cli
    vim gzip unzip zip p7zip curl wget rsync openssh gnupg
    jq yq tree ripgrep fd bat eza fzf
    htop ncdu duf tmux which file
    lm_sensors monitorets resources mission-center btop s-tui

    # dev extras
    docker-compose pkg-config gcc

    # codecs
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav

    # debug/diagnostics
    libva-utils mesa-demos intel-gpu-tools pciutils
  ];

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts noto-fonts-cjk-sans noto-fonts-emoji
    font-awesome roboto fira-code
  ];

  # Memory: zram + OOMD
  zramSwap = { enable = true; memoryPercent = 50; };
  systemd.oomd.enable = true;

  # nix-ld for non-Nix binaries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    glib atk at-spi2-atk cairo gtk3 pango nspr nss dbus cups alsa-lib expat udev
    xorg.libX11 xorg.libXcomposite xorg.libXdamage xorg.libXext xorg.libXfixes
    xorg.libXrandr xorg.libxcb libxkbcommon mesa libgbm zlib libuuid
  ];

  # NixOS state version
  system.stateVersion = "23.11";
}
