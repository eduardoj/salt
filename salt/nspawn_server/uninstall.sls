# Stop and disable the main service
systemd-networkd_stop:
  service.dead:
    - name: systemd-networkd
    - enable: False

remove_networkd_global_override:
  file.absent:
    - name: /etc/systemd/networkd.conf.d/systemd-nspawn-override.conf
    - require:
      - service: systemd-networkd_stop

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
