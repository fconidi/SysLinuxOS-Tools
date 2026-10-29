# SysLinuxOS-Tools

Official **SysLinuxOS** APT repository, hosted on GitHub Pages and GPG-signed.
It distributes the SysLinuxOS packages, installable and upgradable via `apt`.

- **Repo URL:** <https://fconidi.github.io/SysLinuxOS-Tools>
- **Suite:** `tirreno` · **Component:** `main` · **Architecture:** `amd64`
- **Signing key:** `SysLinuxOS Repository Signing Key <fconidi@gmail.com>`
  (fingerprint `15FF 1461 FF03 E670 01C8  AE8C 5FAD CAF4 5BC3 FA1D`)

## Installation (client side)

Quick method:

```bash
curl -fsSL https://fconidi.github.io/SysLinuxOS-Tools/client/install-repo.sh | sudo bash
```

Or manually:

```bash
# key
curl -fsSL https://fconidi.github.io/SysLinuxOS-Tools/syslinuxos-archive-keyring.asc \
  | sudo gpg --dearmor -o /usr/share/keyrings/syslinuxos-archive-keyring.gpg

# apt source (deb822)
sudo tee /etc/apt/sources.list.d/syslinuxos-tools.sources >/dev/null <<'EOF'
Types: deb
URIs: https://fconidi.github.io/SysLinuxOS-Tools
Suites: tirreno
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/syslinuxos-archive-keyring.gpg
EOF

sudo apt update
```

## Packages

| Package | Description |
|---|---|
| [`syslinuxos-conky-window`](https://github.com/fconidi/syslinuxos-conky-window) | Standard Conky window theme for SysLinuxOS (formerly `conky-window`, kept as transitional package) |
| `distroclone` | Universal Live ISO Builder |
| `distroclone-backup` | Snapper backup for distroClone |
| `distroflash` | Create Linux and Windows bootable USB media |
| [`distromove`](https://github.com/fconidi/DistroMove) | Migrate an installed Linux system to a new partition with boot setup and checks |
| [`distroclone-usb`](https://github.com/fconidi/distroClone-usb) | Persistent live USB creator with a shared folder and optional encryption |
| [`file-collector`](https://github.com/fconidi/file-collector) | Gather files scattered across many subfolders into one destination |
| `grub-btrfs` | Btrfs snapshots in the GRUB menu (SysLinuxOS build) |
| [`librepods`](https://github.com/librepods-org/librepods) | AirPods control application for Linux |
| [`syslinuxos-boot`](https://github.com/fconidi/syslinuxos/tree/master/boot-options) | Graphical GRUB menu settings and Plymouth splash configuration for installed SysLinuxOS systems |
| `syslinuxos-boot-repair` | Graphical GRUB boot repair from a SysLinuxOS Live session |
| [`syslinuxos-care`](https://github.com/fconidi/syslinuxos-care) | Desktop system monitoring, cleanup and maintenance |
| [`syslinuxos-anonimo`](https://github.com/fconidi/syslinuxos-anonimo) | Routes all TCP and DNS traffic through Tor with one click (own nftables table and Tor instance) |
| `syslinuxos-job-scheduler` | Graphical editor for user and system cron jobs |
| `syslinuxos-samba-config` | Graphical management of Samba users, shares and service |
| `syslinuxos-service-manager` | Graphical management of system and user services and startup |
| [`syslinuxos-ring-conky`](https://github.com/fconidi/syslinuxos-ring-conky) | Ring-style Conky theme with auto-scaling |
| [`syslinuxos-wifi-analyzer`](https://github.com/fconidi/syslinuxos-wifi-analyzer) | WiFi access point discovery, signal tracking and audible proximity feedback |
| `syslinuxos-snapshots` | Btrfs snapshots and rollback: snapper, snapshots in the GRUB menu and the `syslinuxos-rollback` helper (distributed only through this repository) |
| [`syslinuxos-nvidia-setup`](https://github.com/fconidi/syslinuxos-nvidia-setup) | NVIDIA driver setup with optional CUDA for SysLinuxOS 13 and Debian 13 amd64 |
| `terminal-router` | tmux session recorder for AI-assisted router work |
| [`terminal-system`](https://github.com/fconidi/terminal-system) | AI-assisted two-panel terminal (natural language -> shell commands) |

Wifi Analyzer guides: [English](https://syslinuxos.com/syslinuxos-wifi-analyzer-installation-usage-guide/) | [Italiano](https://francoconidi.it/syslinuxos-wifi-analyzer-guida-installazione-utilizzo/).

Anonimo guides: [English](https://syslinuxos.com/syslinuxos-anonimo-installation-usage-guide/) | [Italiano](https://francoconidi.it/syslinuxos-anonimo-guida-installazione-utilizzo/).

> **Note on `grub-btrfs`**: it is an override of the Debian version. To prevent
> a Debian update (numerically higher version) from replacing it,
> `install-repo.sh` installs a pin in `/etc/apt/preferences.d/99-syslinuxos-tools.pref`
> (`Pin: release o=SysLinuxOS`, `Pin-Priority: 1001`) that always forces the
> SysLinuxOS build. Only `grub-btrfs` is pinned; the other packages keep normal
> priority. Reference file: `client/syslinuxos-tools.pref`.

## Maintenance (maintainer side)

Managed with **reprepro** (automatic signing with the key above):

```
conf/distributions   repo configuration + SignWith
db/                  reprepro internal state
dists/tirreno/       signed indices (InRelease, Release, Release.gpg, Packages)
pool/main/           the .deb files
```

Add/update packages:

```bash
./add-package.sh ../repository/new-package_X.Y_all.deb
git add -A && git commit -m "repo: update packages" && git push
```

reprepro keeps a single version per package: including a newer version replaces
the previous one.

## License

The repository metadata belongs to SysLinuxOS / Franco Conidi (edmond).
Each package keeps its own license.
