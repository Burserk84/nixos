# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader. Systemd-boot is correctly enabled here (Default for installer).
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- NETWORK & SYSTEM SETTINGS ---

  networking.hostName = "amiralidev"; # Changed hostname for personalization
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tehran";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable touchpad support (recommended for laptops like Asus R1504VA)
  services.libinput.enable = true;
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };
  
  # --- USER CONFIGURATION ---

  # Define a user account.
  # CRITICAL: Using 'user' as the username, based on your 'whoami' output.
  users.users.user = { 
    isNormalUser = true;
    description = "Amirali Sharifi Asl";
    # CRITICAL: Added 'docker' group for rootless Docker access and Zsh shell
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh; # Setting Zsh as default shell
    packages = with pkgs; [
    #  thunderbird
    ];
  };
  
  # Enable Zsh support
  programs.zsh = {
    enable = true;
    # فعال کردن فریم‌ورک محبوب Oh My Zsh
    ohMyZsh = {
      enable = true;
      # انتخاب تم (agnoster)
      theme = "agnoster"; 
      # در این لیست، فقط پلاگین‌های داخلی Oh My Zsh (مثل git) را نگه دارید.
      # پلاگین‌های نصب شده به صورت پکیج (syntax-highlighting و autosuggestions) در NixOS نیازی به ذکر شدن در اینجا ندارند.
      plugins = [ 
        "git"          # مدیریت دستورات Git
        "colored-man-pages" # رنگی کردن صفحات man
      ];
    };
  };
  # programs.zsh.ohMyZsh.enable = true; # Uncomment if you want Nix to manage Oh-My-Zsh


  # --- DEVELOPMENT & PACKAGES ---

  # Enable Docker service for development (AuraSync project)
  virtualisation.docker.enable = true;
  
  # CRITICAL: Enable the ExpressVPN systemd service (expressvpnd daemon)
  services.expressvpn.enable = true;
  services.dbus.packages = with pkgs; [ expressvpn ];

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages (Necessary for Chrome, VSCode, ExpressVPN)
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # Full-stack Development Tools (AuraSync, Next.js, etc.)
    git
    nodejs_20
    yarn
    postgresql
    
    # VPN: Installed directly from Nixpkgs
    expressvpn     
    
    # Browsers
    google-chrome
    tor-browser
    
    # Communication 
    telegram-desktop
    
    # Development/Productivity
    vscode
    obsidian
    
    # Utilities
    qbittorrent
    evince # A lightweight PDF reader

    zsh-autosuggestions
    zsh-syntax-highlighting

    pkgs.gnome-tweaks
    steam-run
    ];
  
  # Removed programs.nix-ld.enable = true;
  # The native ExpressVPN package does not require nix-ld.


  # --- SYSTEM STATUS ---
  system.stateVersion = "25.05"; # Keep this value as is
}
