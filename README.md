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
| `distroclone` | Universal Live ISO Builder |
| `distroclone-backup` | Snapper backup for distroClone |
| `grub-btrfs` | Btrfs snapshots in the GRUB menu (SysLinuxOS build) |
| `syslinuxos-ring-conky` | Ring-style Conky theme with auto-scaling |
| `syslinuxos-snapshots` | Btrfs snapshots + GRUB integration |

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

Package names must be **lowercase** (Debian Policy 5.6.1); if `reprepro` rejects
a `.deb`, fix the `Package:` field in its control.

## License

The repository metadata belongs to SysLinuxOS / Franco Conidi (edmond).
Each package keeps its own license.
