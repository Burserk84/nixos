---

# 🧊 NixOS Configuration — amiralidev

This repository contains the complete declarative setup for my **NixOS 25.05 (Warbler)** system running **GNOME on Wayland**.  
It defines everything — from packages and kernel parameters to TLP, thermals, and Chrome GPU acceleration — allowing me to rebuild my full dev environment from scratch with one command.

---

## 📘 Overview

This configuration is designed for **clarity**, **performance**, and **reproducibility**.  
By version-controlling my NixOS setup, I can:

* Reinstall or migrate my system in minutes
* Track all system changes via Git
* Roll back to any previous configuration instantly
* Keep a clean and predictable development environment

> ⚠️ Note:  
> This setup is tailored to my personal laptop (`amiralidev`, Intel i5-1335U + Iris Xe).  
> Others may need to adjust hardware-specific or driver settings before using.

---

## 🧱 System Details

| Component | Description |
| ---------- | ----------- |
| **OS** | NixOS 25.05 (Warbler) |
| **Desktop Environment** | GNOME (Wayland) |
| **Hostname** | `amiralidev` |
| **CPU** | Intel® Core™ i5-1335U (10C / 12T) |
| **GPU** | Intel Iris Xe Graphics (VAAPI + ANGLE) |
| **Display Stack** | Wayland + EGL + Mesa 25 |
| **Package Manager** | Nix |
| **Power Management** | TLP (balanced) + thermald + irqbalance |
| **Shell** | Zsh + Oh-My-Zsh + Powerlevel10k |
| **Browser** | Google Chrome (Wayland, full GPU acceleration) |

---

## 📂 Repository Structure

| File | Description |
| ---- | ------------ |
| `flake.nix` | Flake entrypoint — defines system + inputs |
| `configuration.nix` | Main system configuration |
| `hardware-configuration.nix` | Auto-generated hardware setup |
| `home.nix` | User environment (via Home Manager) |
| `configuration.nix.save` | Backup of previous configuration |

---

## ⚙️ Installation & Usage

1. Clone this repo into `/etc/nixos`:

   ```bash
   sudo rm -rf /etc/nixos
   sudo git clone https://github.com/Burserk84/nixos.git /etc/nixos
   cd /etc/nixos
   ```

2. (Optional) Adjust values such as username, hostname, or GPU driver.

3. Rebuild the system:

   ```bash
   sudo nixos-rebuild switch --flake '.#amiralidev'
   ```

4. Reboot if needed:

   ```bash
   sudo reboot
   ```

5. (Optional) Apply Home Manager configs:

   ```bash
   home-manager switch
   ```

---

## 🧩 Key Features

✅ **Wayland-native GNOME** — smooth, low-latency experience
✅ **Intel Xe acceleration** — via `intel-media-driver` + `mesa`
✅ **Chrome GPU acceleration** — ANGLE over EGL + VAAPI decoding
✅ **Balanced thermals** — TLP tuned for performance/cool operation
✅ **Zsh + Powerlevel10k** — modern, fast shell experience
✅ **Docker + PostgreSQL + NodeJS** — ready for full-stack dev
✅ **zramSwap** — improved memory compression
✅ **PipeWire audio** — clean audio stack with low latency
✅ **Weekly fstrim** — SSD health maintenance

---

## 🔧 Common Commands

| Command                                          | Description                |
| ------------------------------------------------ | -------------------------- |
| `sudo nixos-rebuild switch`                      | Apply config immediately   |
| `sudo nixos-rebuild switch --flake .#amiralidev` | Apply via flake            |
| `sudo nixos-rebuild boot`                        | Build config for next boot |
| `sudo nixos-rebuild test`                        | Test config temporarily    |
| `sudo nixos-rebuild switch --upgrade`            | Update & apply             |
| `sudo nix-collect-garbage -d`                    | Remove old generations     |
| `home-manager switch`                            | Apply user configs         |

---

## ♻️ Rollbacks & Recovery

NixOS allows instant rollbacks to previous generations:

```bash
sudo nixos-rebuild switch --rollback
```

Or select an older generation from the **boot menu** at startup.

---

## 🧊 Performance & Thermal Tuning

| Tool             | Role                                  |
| ---------------- | ------------------------------------- |
| **TLP**          | Power and governor management         |
| **thermald**     | Dynamic CPU thermal tuning            |
| **irqbalance**   | Evenly distribute interrupts          |
| **zramSwap**     | Compress memory to avoid swap lag     |
| **auto-trim**    | Weekly SSD TRIM                       |
| **Chrome VAAPI** | Hardware video decoding via Intel iHD |

> Typical temps during dev use: **55–65 °C**, short spikes under load are normal.

---

## 🩵 Troubleshooting

**Rebuild with detailed trace:**

```bash
sudo nixos-rebuild switch --show-trace
```

**View system logs:**

```bash
journalctl -xb
```

**Check running services:**

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
You may reuse or adapt parts of this configuration at your own discretion.

---

## 💡 Credits

* [NixOS](https://nixos.org/) — declarative OS magic
* [Home Manager](https://github.com/nix-community/home-manager) — per-user config management
* [TLP](https://linrunner.de/tlp/) — power optimization for Linux
* [Mesa + Intel VAAPI](https://mesa3d.org/) — open-source graphics stack
* The NixOS community ❤️ for documentation and guidance

---
> **Built with love, Zsh, and flakes — Amirali Sharifi Asl**
---
