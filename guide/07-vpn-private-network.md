# 07 — VPN Private Network (WireGuard)

Connect clinic machines into a private mesh so oracles can communicate across nodes.

## Why WireGuard

- Fast (kernel-level, minimal overhead)
- Simple config (one file per peer)
- Secure (modern cryptography, no legacy baggage)
- Works behind NAT with a single public relay node

## Architecture

```
┌─────────────┐     WireGuard      ┌─────────────┐
│  Workstation │◄──────────────────►│   Server     │
│  10.0.0.2    │     encrypted      │  10.0.0.1    │
│  (oracles)   │     tunnel         │  (relay)     │
└─────────────┘                    └──────┬───────┘
                                          │
                                   ┌──────┴───────┐
                                   │  Workstation  │
                                   │  10.0.0.3     │
                                   │  (oracles)    │
                                   └──────────────┘
```

## Setup

### 1. Install WireGuard

```bash
# macOS
brew install wireguard-tools

# Ubuntu/Debian
sudo apt install wireguard
```

### 2. Generate Keys (on each node)

```bash
wg genkey | tee privatekey | wg pubkey > publickey
```

> **Never share or commit private keys.**

### 3. Server Config (relay node)

```ini
# /etc/wireguard/wg0.conf
[Interface]
Address = 10.0.0.1/24
ListenPort = 51820
PrivateKey = <server-private-key>

# Workstation A
[Peer]
PublicKey = <workstation-a-public-key>
AllowedIPs = 10.0.0.2/32

# Workstation B
[Peer]
PublicKey = <workstation-b-public-key>
AllowedIPs = 10.0.0.3/32
```

### 4. Client Config (each workstation)

```ini
# /etc/wireguard/wg0.conf
[Interface]
Address = 10.0.0.2/24
PrivateKey = <workstation-private-key>

[Peer]
PublicKey = <server-public-key>
Endpoint = <server-public-ip>:51820
AllowedIPs = 10.0.0.0/24
PersistentKeepalive = 25
```

### 5. Start

```bash
# Linux
sudo wg-quick up wg0

# macOS (via Homebrew)
sudo wg-quick up wg0

# Or use the WireGuard macOS app
```

## Verify Connectivity

```bash
# Check WireGuard status
sudo wg show

# Ping another node
ping 10.0.0.1

# Test maw federation
maw ping
```

## maw Over VPN

Once WireGuard is up, configure maw to use VPN addresses:

```bash
# In your environment
export MAW_HOST=10.0.0.1
```

Now `maw hey`, `maw peek`, and `maw wire` work across nodes through the encrypted tunnel.

## Security Checklist

- [ ] Private keys never leave the machine that generated them
- [ ] Server firewall allows UDP port 51820 only
- [ ] Use `PersistentKeepalive = 25` for NAT traversal
- [ ] Rotate keys periodically
- [ ] Keep WireGuard updated

---

Next: [08 — Cross-Oracle Sync](./08-cross-oracle-sync.md)
