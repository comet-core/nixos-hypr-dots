# 🌌 Fedora 44 Hyprland + Noctalia Shell 
**Hardware Profile:** HP Omen 16 | Intel i7-13700HX | NVIDIA RTX 4070 Max-Q

A ground-up, systemd-optimized Wayland rice transitioning away from Artix/s6. This setup relies on proprietary NVIDIA drivers, a dynamically generated Wallust color scheme, and the Noctalia modular UI shell.

---

### 1. Enable NVIDIA Repositories and Drivers
Fedora ships with open-source Nouveau drivers. To prevent Wayland from crashing on the RTX 4070, the proprietary drivers and RPM Fusion repositories are strictly required before launching the compositor.

```bash
sudo dnf install [https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$](https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$)(rpm -E %fedora).noarch.rpm [https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$](https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$)(rpm -E %fedora).noarch.rpm
sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda -y
```

### 2. Install Core System Dependencies
This stack provides the Wayland compositor, terminal utilities, screenshot pipeline, and build tools.

```bash
sudo dnf copr enable ashbuk/Hyprland-Fedora -y
sudo dnf install hyprland kitty zsh starship zsh-autosuggestions zsh-syntax-highlighting grim slurp wl-clipboard wofi polkit-gnome playerctl brightnessctl cargo -y
```

### 3. Build and Link Wallust
Wallust dynamically extracts colors from the active wallpaper to theme the entire desktop. It is not currently in the Fedora DNF repositories and must be compiled via Rust/Cargo.

```bash
cargo install wallust
sudo ln -s ~/.cargo/bin/wallust /usr/local/bin/wallust
```

### 4. Rebuild the File Structure & Restore Dotfiles
Ensure the wallpaper directory exists so Noctalia has a target to read from, then restore all configurations from this repository.

```bash
# 1. Create the target wallpaper directory
mkdir -p ~/Pictures/Wallpapers

# 2. Copy core configurations into .config
cp -r hypr kitty noctalia wallust ~/.config/

# 3. Copy shell and prompt configs
cp starship.toml ~/.config/
cp .zshrc ~/
```

### 5. Enable Services and Set Defaults
Wake up the systemd background daemons for audio and Bluetooth, force GTK to respect dark mode, and switch the default shell to Zsh.

```bash
systemctl --user enable --now pipewire pipewire-pulse wireplumber
sudo systemctl enable --now bluetooth
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
chsh -s $(which zsh)
```

> **⚠️ CRITICAL REMINDER (Quickshell):** > The UI shell relies on `exec-once = qs -c noctalia-shell` in `hyprland.conf`. The `qs` (Quickshell) binary must be manually installed or compiled, as it is not available via standard DNF packages.
