# SysLinuxOS-Tools

Repository APT ufficiale di **SysLinuxOS**, ospitato su GitHub Pages e firmato GPG.
Distribuisce i pacchetti SysLinuxOS, scaricabili e aggiornabili via `apt`.

- **URL repo:** <https://fconidi.github.io/SysLinuxOS-Tools>
- **Suite:** `tirreno` · **Componente:** `main` · **Architettura:** `amd64`
- **Firma:** `SysLinuxOS Repository Signing Key <fconidi@gmail.com>`
  (fingerprint `15FF 1461 FF03 E670 01C8  AE8C 5FAD CAF4 5BC3 FA1D`)

## Installazione (lato utente)

Metodo rapido:

```bash
curl -fsSL https://fconidi.github.io/SysLinuxOS-Tools/client/install-repo.sh | sudo bash
```

Oppure manuale:

```bash
# chiave
curl -fsSL https://fconidi.github.io/SysLinuxOS-Tools/syslinuxos-archive-keyring.asc \
  | sudo gpg --dearmor -o /usr/share/keyrings/syslinuxos-archive-keyring.gpg

# sorgente apt (deb822)
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

## Pacchetti

| Pacchetto | Descrizione |
|---|---|
| `distroclone` | Universal Live ISO Builder |
| `distroclone-backup` | Backup snapper per distroClone |
| `grub-btrfs` | Snapshot btrfs nel menu GRUB (build SysLinuxOS) |
| `syslinuxos-ring-conky` | Tema Conky ad anelli con auto-scaling |
| `syslinuxos-snapshots` | Snapshot btrfs + integrazione GRUB |

> **Nota su `grub-btrfs`**: e' un override della versione Debian. Per evitare
> che un aggiornamento Debian (versione numericamente piu' alta) lo sostituisca,
> `install-repo.sh` installa un pin in `/etc/apt/preferences.d/99-syslinuxos-tools.pref`
> (`Pin: release o=SysLinuxOS`, `Pin-Priority: 1001`) che forza sempre la build
> SysLinuxOS. Solo `grub-btrfs` e' pinnato; gli altri pacchetti restano a
> priorita' normale. File di riferimento: `client/syslinuxos-tools.pref`.

## Manutenzione (lato maintainer)

Struttura gestita con **reprepro** (firma automatica con la chiave sopra):

```
conf/distributions   configurazione repo + SignWith
db/                  stato interno reprepro
dists/tirreno/       indici firmati (InRelease, Release, Release.gpg, Packages)
pool/main/           i .deb
```

Aggiungere/aggiornare pacchetti:

```bash
./add-package.sh ../repository/nuovo-pacchetto_X.Y_all.deb
git add -A && git commit -m "repo: aggiorno pacchetti" && git push
```

reprepro tiene una sola versione per pacchetto: includere una versione piu'
recente sostituisce la precedente.

I nomi dei pacchetti devono essere **minuscoli** (Debian Policy 5.6.1); se
`reprepro` rifiuta un `.deb`, correggere il campo `Package:` nel suo control.

## Licenza

I metadati del repo sono di SysLinuxOS / Franco Conidi (edmond).
Ogni pacchetto mantiene la propria licenza.
