# Standalone salt states to run minimal systemd-nspawn containers

## How to run salt standalone

### Test

```bash
sudo salt-call -c config state.apply test=True
```

### Nspawn server

Install:

```bash
sudo salt-call -c config state.apply salt.nspawn_server
```

Uninstall:

```bash
sudo salt-call -c config state.apply salt.nspawn_server.uninstall
```

### Nspawn container

Install:

```bash
sudo salt-call -c config state.apply salt.nspawn_container
```

Purge:

```bash
sudo salt-call -c config state.apply salt.nspawn_container.purge
```
