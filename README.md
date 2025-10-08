# 🧊 NixOS Configuration — amiralidev

This repository contains the full declarative configuration for my **NixOS 25.05 (Warbler)** system running **GNOME on Wayland**.
It defines everything — from packages and services to users, networking, and desktop environment — so I can rebuild my entire system from scratch with one command.

---

## 📘 Overview

This setup is built for **reproducibility** and **clarity**.
By version-controlling my NixOS configuration, I can:

* Reinstall or migrate my system in minutes
* Keep track of every change via Git
* Roll back instantly to previous configurations
* Maintain a clean, consistent development environment

> ⚠️ Note: This configuration is tailored for my personal machine (`amiralidev`).
> Others may need to adjust settings (especially hardware-related parts) before use.

---

## 🧱 System Details

| Component                 | Description                               |
| ------------------------- | ----------------------------------------- |
| **OS**                    | NixOS 25.05.810767 (Warbler)              |
| **Desktop Environment**   | GNOME (Wayland)                           |
| **Hostname**              | `amiralidev`                              |
| **Package Manager**       | Nix                                       |
| **Configuration Manager** | NixOS modules + (optionally) Home Manager |

---

## 📂 Repository Structure

| File                         | Description                                              |
| ---------------------------- | -------------------------------------------------------- |
| `configuration.nix`          | Main system configuration (packages, services, settings) |
| `hardware-configuration.nix` | Auto-generated hardware config (disks, drivers, etc.)    |
| `home.nix`                   | User configuration (dotfiles, environment, shell, etc.)  |
| `configuration.nix.save`     | Backup of previous system configuration                  |

---

## ⚙️ Installation & Usage

1. Clone this repository into `/etc/nixos`:

   ```bash
   sudo rm -rf /etc/nixos
   sudo git clone https://github.com/Burserk84/nixos.git /etc/nixos
   cd /etc/nixos
   ```

2. (Optional) Adjust configuration values — e.g. username, packages, or host-specific settings.

3. Apply the configuration:

   ```bash
   sudo nixos-rebuild switch
   ```

4. Reboot if necessary:

   ```bash
   sudo reboot
   ```

5. If using Home Manager, apply user configs with:

   ```bash
   home-manager switch
   ```

---

## 🔧 Common Commands

| Command                               | Purpose                                         |
| ------------------------------------- | ----------------------------------------------- |
| `sudo nixos-rebuild switch`           | Apply configuration immediately                 |
| `sudo nixos-rebuild boot`             | Build configuration for next boot only          |
| `sudo nixos-rebuild test`             | Test config without committing it               |
| `sudo nixos-rebuild switch --upgrade` | Update system and switch                        |
| `sudo nix-channel --update`           | Update NixOS channels                           |
| `sudo nix-collect-garbage -d`         | Clean old generations and free space            |
| `home-manager switch`                 | Update user environment (if using Home Manager) |

---

## 🧩 Customization

You can easily customize:

* **Packages** → via `environment.systemPackages`
* **Services** → `services.<name>.enable = true;`
* **Networking** → `networking.interfaces` and `networkmanager.enable`
* **Desktop tweaks** → via GNOME and Wayland options
* **User configs** → add dotfiles, aliases, and shells in `home.nix`

---

## ♻️ Rollbacks & Recovery

One of NixOS’s best features: instant rollbacks.
You can revert to a previous working generation anytime:

```bash
sudo nixos-rebuild switch --rollback
```

Or simply pick an older generation from the **bootloader menu** at startup.

---

## 🩵 Troubleshooting

* **See detailed rebuild logs:**

  ```bash
  sudo nixos-rebuild switch --show-trace
  ```
* **View recent system logs:**

  ```bash
  journalctl -xb
  ```
* **Check services:**

  ```bash
  systemctl status <service-name>
  ```
* **Hardware issues:** verify entries in `hardware-configuration.nix`

---

## 📜 License

You can license this configuration under [MIT](https://opensource.org/licenses/MIT) or any other license you prefer.
If not specified, it’s assumed to be **personal use only**.

---

## 💡 Credits

* [NixOS](https://nixos.org/) — for the declarative, reliable system architecture
* [Home Manager](https://github.com/nix-community/home-manager) — for user environment management
* The NixOS community — for extensive documentation and helpful modules

---

Would you like me to add a **“Features”** section (listing your enabled services and key packages, like ExpressVPN, Docker, etc.)?
I can extract that from your `configuration.nix` to make the README more descriptive.
