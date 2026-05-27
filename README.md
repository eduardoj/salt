# Standalone salt states to run minimal systemd-nspawn containers

Provide a minimal, safe, conteinerized environment to run an AI agent over a codebase.

## Introduction

This repository defines a set of salt states used to:
- create a systemd-nspawn server installation
- create a systemd-networkd configuration that allows every nspawn container to access internet.
- create a systemd-nspawn container with a minimal openSUSE Tumbleweed distribution.


## Requirements

These salt states are meant to be run in a development machine with a default
openSUSE Tumbleweed. That means that no previous `systemd-networkd`
installation/configuration was performed.

List of requirements:
- Base installation of openSUSE Tumbleweed
- Packages: `salt-minion`
- All salt commands must be run inside the copy of this repository.


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

### Nspawn container

Install:

```bash
sudo salt-call -c config state.apply salt.nspawn_container
```


## Install everything

Install both, server and container:

```bash
sudo salt-call -c config state.apply
```


## Use the container

- State:

```bash
machinectl status tumbleweed     # show state
```

- Start:
```bash
machinectl start tumbleweed     # Boot the container
```

- Stop:
```bash
machinectl stop tumbleweed     # Shutdown the container
```

- Open a shell inside the container:
```bash
machinectl shell tumbleweed     # Open a shell inside the container
```


## Delete everything and return to initial state

You may want to leave your system as it initially was.

To remove the container, purge it with:

```bash
sudo salt-call -c config state.apply salt.nspawn_container.purge
```

If you also want to remove the systemd-nspawn and related packages, uninstall them with:

```bash
sudo salt-call -c config state.apply salt.nspawn_server.uninstall
```
