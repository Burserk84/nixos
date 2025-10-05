# /etc/nixos/home.nix
{ config, pkgs, ... }:

{
  # پکیج‌هایی که در سطح کاربر نصب می‌شوند
  home.packages = with pkgs; [
    vscode 
    obsidian
    nerdfonts 
  ];
  
  # --- TERMINAL: ZSH & POWERLEVEL10K CONFIGURATION (Home Manager) ---
  programs.zsh = {
    enable = true;
    # 🟢 اکنون این گزینه‌ها در Home Manager کار می‌کنند
    plugins = [
      "zsh-syntax-highlighting"
      "zsh-autosuggestions"
    ];

    initExtra = ''
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
    '';
  };
  
  # 🟢 اکنون این ماژول در Home Manager کار می‌کند
  programs.powerlevel10k = {
    enable = true;
    # نیازی به نصب zsh-powerlevel10k در home.packages یا systemPackages نیست.
  };

  home.stateVersion = "23.11"; # این ورژن باید با system.stateVersion یکی باشد
}
