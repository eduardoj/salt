# Stop and disable the main service
systemd-networkd_stop:
  service.dead:
    - name: systemd-networkd
    - enable: False

# Remove the override.conf file if it exists to restore defaults
remove_network_interface_override:
  file.absent:
    - name: /etc/systemd/network/80-container-ve.network.d/override.conf
    - require:
      - service: systemd-networkd_stop

# Clean up and remove the override directory as well
remove_network_override_directory:
  file.absent:
    - name: /etc/systemd/network/80-container-ve.network.d
    - require:
      - file: remove_network_interface_override

remove_container_interfaces_from_trusted:
  cmd.run:
    - name: |
        firewall-cmd --permanent --zone=trusted --remove-interface=ve-+
        firewall-cmd --reload
    - require:
      - service: systemd-networkd_stop
    - onlyif:
        - systemctl is-active --quiet firewalld
        - firewall-cmd --zone=trusted --list-interfaces | grep -q "ve-+"

# Uninstall the packages
remove_nspawn_requirements:
  pkg.removed:
    - pkgs:
      - systemd-container
      - systemd-networkd
    - require:
      - service: systemd-networkd_stop
