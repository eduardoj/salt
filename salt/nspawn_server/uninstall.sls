# Stop and disable the main service
systemd-networkd_stop:
  service.dead:
    - name: systemd-networkd
    - enable: False

# Remove the created network configuration file
/etc/systemd/network/80-containers-nat.network:
  file.absent

# Uninstall the packages
remove_nspawn_requirements:
  pkg.removed:
    - pkgs:
      - systemd-container
      - systemd-networkd
    - require:
      - service: systemd-networkd_stop
      - file: /etc/systemd/network/80-containers-nat.network
