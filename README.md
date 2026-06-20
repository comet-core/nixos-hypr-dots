# ❄️ NixOS Dynamic Wayland Setup

A purely declarative, Flake-based NixOS configuration featuring a fully dynamic Wayland environment. 

### 💻 Hardware Target
* **Chassis:** HP Omen 16" (165Hz Display)
* **CPU:** Intel Core i7-13700HX (24 Threads)
* **GPU:** NVIDIA RTX 4070 Ada Lovelace Max-Q [Discrete]
* **RAM:** 32 GB Hynix DDR5
* **Storage:** 1 TB Samsung NVMe

### 🛠️ The Core Stack
* **OS:** NixOS (Flake + Home Manager)
* **Window Manager:** Hyprland
* **Shell Environment:** Zsh + Starship Prompt
* **Terminal:** Kitty

### 🎨 UI & Theming Engine
This setup uses a dynamic color-generation pipeline that automatically syncs the entire system UI to the current wallpaper.
* **Noctalia:** Handles the Wayland top bar, application launcher, and IPC hooks.
* **Wallust:** The core templating engine. Reads the wallpaper, generates hex codes, and injects them into Hyprland, Kitty, and Starship.
* **Screenshot Utility:** `grim` + `slurp` + `wl-clipboard`

### ⚙️ System Quirks & Fixes Applied
* **Dynamic File Generation:** Specific UI configuration files (like `.config/starship.toml` and `.config/noctalia/`) are intentionally excluded from Home Manager's read-only symlinking to allow Wallust to dynamically overwrite them on the fly.
* **Audio:** Handled via Pipewire with KDE Plasma packages acting as a reliable fallback/GUI mixer.
