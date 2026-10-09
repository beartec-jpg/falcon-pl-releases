# Falcon PL releases

Public binaries for **Falcon PL**, the post-quantum ledger (Falcon-512 signatures), and the one-command node
installer for the public testnet (network id **2300**).

Website: https://falcon-ledger.com · Validators: https://falcon-ledger.com/validator

## Install a node (Linux x86_64)

```bash
curl -fsSL https://falcon-ledger.com/install.sh | bash
```

This installs an **observer** (non-validator) node: it downloads the latest release from this repo, verifies the
signature and checksums, generates the node key **on your machine** (it is never printed or sent anywhere),
installs a systemd service, peers over the public seed (no VPN) and waits until it is in sync.
Manage it with `falcon-node status | logs | upgrade | uninstall`.

Requirements: Linux x86_64, glibc 2.35+ (Ubuntu 22.04+, Debian 12+), 2 GB+ RAM, 4 GB free disk, outbound TCP.

Validator onboarding (admission by approval, 50,000 FPL minimum bond) opens after the 2.9.62 network upgrade.
See https://falcon-ledger.com/validator.

## What is in a release

| File | |
|---|---|
| `falcon-pl-<ver>-linux-x86_64.tar.gz` | `falcon-pl-node` + `falcon-pl-ctl` |
| `falcon-pl-node`, `falcon-pl-ctl` | the same binaries, uncompressed |
| `install-falcon-node.sh` | the installer |
| `network-2300.env` | public network profile (seeds, genesis set, timing) |
| `BUILDINFO.txt` | source commit, toolchain, build image, glibc floor, AVX-512 count |
| `SHA256SUMS`, `SHA256SUMS.minisig` | checksums and their signature |

Binaries are portable x86_64 builds: no `target-cpu=native`, **zero AVX-512 instructions**. Each release is built
twice in a pinned container (Ubuntu 22.04, Rust 1.85.1) and both builds must be byte-identical.

## Verify by hand

Release signing key (minisign, key id `8ACFFC29EE09FAEC`):

```
RWTs+gnuKfzPik0Xbcf+m1hD/JrCUnWqaD/OAZFZEY2fcNc90D67mZlM
```

```bash
V=2.9.61; B=https://github.com/beartec-jpg/falcon-pl-releases/releases/download/v$V
curl -fsSLO $B/SHA256SUMS -O $B/SHA256SUMS.minisig -O $B/falcon-pl-$V-linux-x86_64.tar.gz
minisign -Vm SHA256SUMS -P RWTs+gnuKfzPik0Xbcf+m1hD/JrCUnWqaD/OAZFZEY2fcNc90D67mZlM
sha256sum -c --ignore-missing SHA256SUMS
```

This is a **testnet**. Testnet FPL has no monetary value.
