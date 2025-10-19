---

# 🧊 NixOS Configuration — amiralidev

This repository contains the complete declarative setup for my **NixOS 25.05 (Warbler)** system running **GNOME on Wayland**.
It defines everything — from packages and kernel parameters to gaming, thermals, Docker, and Chrome GPU acceleration — allowing me to rebuild my full development + gaming environment from scratch with one command.

---

## 📘 Overview

This configuration is built for **clarity**, **performance**, and **reproducibility**.
By version-controlling my NixOS setup, I can:

* Reinstall or migrate my laptop in minutes
* Track every system change through Git
* Roll back instantly to previous generations
* Keep a clean, stable, and consistent development environment

> ⚠️ **Note:**
> This setup is tailored for my laptop (`amiralidev`, Intel i5-1335U + Iris Xe).
> Others may need to adjust hardware-specific or driver options before use.

---

## 🧱 System Details

| Component            | Description                                    |
| -------------------- | ---------------------------------------------- |
| **OS**               | NixOS 25.05 (Warbler)                          |
| **Desktop**          | GNOME on Wayland                               |
| **Hostname**         | `amiralidev`                                   |
| **CPU**              | Intel® Core™ i5-1335U (10C / 12T)              |
| **GPU**              | Intel Iris Xe Graphics (VAAPI + ANGLE)         |
| **Display Stack**    | Wayland + EGL + Mesa 25                        |
| **Package Manager**  | Nix + Flakes                                   |
| **Power Management** | TLP (balanced) + thermald + irqbalance         |
| **Memory**           | zramSwap (50 %) + systemd-oomd                 |
| **Shell**            | Zsh + Oh My Zsh + Powerlevel10k                |
| **Browser**          | Google Chrome (Wayland + full GPU accel)       |
| **Dev Stack**        | Docker + PostgreSQL 17 + NodeJS 20             |
| **Gaming Stack**     | Steam + Proton GE + GameMode + Lutris + Heroic |

---

## 📂 Repository Structure

| File                         | Description                                |
| ---------------------------- | ------------------------------------------ |
| `flake.nix`                  | Flake entrypoint — defines inputs + system |
| `configuration.nix`          | Main system configuration                  |
| `hardware-configuration.nix` | Auto-generated hardware setup              |
| `home.nix`                   | Home Manager config (imported inline)      |
| `configuration.nix.save`     | Previous backup configuration              |

---

## ⚙️ Installation & Usage

1. Clone this repo into `/etc/nixos`:

   ```bash
   sudo rm -rf /etc/nixos
   sudo git clone https://github.com/Burserk84/nixos.git /etc/nixos
   cd /etc/nixos
   ```

2. (Optional) Edit values like username, hostname, or GPU driver if needed.

3. Rebuild your system:

   ```bash
   sudo nixos-rebuild switch --flake '.#amiralidev'
   ```

4. Reboot to apply everything cleanly:

   ```bash
   sudo reboot
   ```

5. (Optional) Re-apply user configs:

   ```bash
   home-manager switch
   ```

---

## 🧩 Key Features

✅ **Wayland-native GNOME** — smooth, low-latency desktop
✅ **Intel Xe acceleration** — `intel-media-driver` + Mesa 25
✅ **Chrome GPU acceleration** — ANGLE / EGL + VAAPI decoding
✅ **Balanced thermals** — TLP + thermald + irqbalance
✅ **ExpressVPN integration** — system-level service
✅ **PostgreSQL 17** — ready-to-run local database
✅ **Docker & Compose** — dev containers out of the box
✅ **Full gaming stack** — Steam, Proton GE, Lutris, Heroic, MangoHud
✅ **Zsh + Powerlevel10k** — beautiful, fast shell
✅ **zramSwap + OOMD** — smart memory compression + protection
✅ **PipeWire audio** — modern low-latency sound stack
✅ **Weekly fstrim** — SSD health maintenance

---

## 🔧 Common Commands

| Command                                          | Description                 |
| ------------------------------------------------ | --------------------------- |
| `sudo nixos-rebuild switch`                      | Apply config immediately    |
| `sudo nixos-rebuild switch --flake .#amiralidev` | Apply flake-based config    |
| `sudo nixos-rebuild boot`                        | Build config for next boot  |
| `sudo nixos-rebuild test`                        | Test temporarily            |
| `sudo nixos-rebuild switch --upgrade`            | Update & apply              |
| `sudo nix-collect-garbage -d`                    | Remove old generations      |
| `home-manager switch`                            | Apply Home Manager settings |

---

## ♻️ Rollbacks & Recovery

Rollback instantly:

```bash
sudo nixos-rebuild switch --rollback
```

Or choose an older generation from the **boot menu**.

---

## ⚙️ Performance & Thermal Tuning

| Tool             | Purpose                                      |
| ---------------- | -------------------------------------------- |
| **TLP**          | CPU + power governor management              |
| **thermald**     | Dynamic CPU thermal control                  |
| **irqbalance**   | Balanced IRQ distribution                    |
| **zramSwap**     | 50 % RAM compression for smooth multitasking |
| **systemd-oomd** | Prevent hard OOM crashes                     |
| **auto-trim**    | Weekly SSD TRIM                              |
| **Chrome VAAPI** | Hardware decode via Intel iHD driver         |

> 🧠 Typical temps under load: **55–65 °C** (brief spikes normal)

---

## 🩵 Troubleshooting

**Show trace on build error:**

```bash
sudo nixos-rebuild switch --show-trace
```

**View system logs:**

```bash
journalctl -xb
```

**Check service status:**

```bash
systemctl status <service>
```

**Verify GPU acceleration:**

```bash
chrome://gpu
vainfo | grep -E 'H264|HEVC|AV1'
```

---

## 📜 License

Licensed under the [MIT License](https://opensource.org/licenses/MIT).
You’re free to reuse or adapt any part of this configuration.

---

## 💡 Credits

* [NixOS](https://nixos.org/) — declarative OS magic
* [Home Manager](https://github.com/nix-community/home-manager) — per-user config management
* [TLP](https://linrunner.de/tlp/) — power optimization for Linux
* [Mesa + VAAPI](https://mesa3d.org/) — open-source graphics stack
* The NixOS community ❤️ for docs & support

---

> **Built with love, Zsh, and flakes — Amirali Sharifi Asl**

---

