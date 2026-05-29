install_nspawn_requirements:
  pkg.installed:
    - pkgs:
      - systemd-container
      - systemd-networkd

# Ensure the interface-specific override directory exists
ensure_network_override_directory:
  file.directory:
    - name: /etc/systemd/network/80-container-ve.network.d
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True
    - require:
      - pkg: install_nspawn_requirements

# Manage the override configuration file inside the directory
configure_network_interface_override:
  file.managed:
    - name: /etc/systemd/network/80-container-ve.network.d/override.conf
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        [Network]
        Address=
        Address=172.16.10.1/24
    - require:
      - file: ensure_network_override_directory

add_container_interfaces_to_trusted:
  firewalld.present:
    - name: trusted
    - interfaces:
      - ve-+
    - prune_interfaces: False
    - require:
      - pkg: install_nspawn_requirements
    - onlyif:
        - systemctl is-active --quiet firewalld

systemd-networkd:
  service.running:
    - enable: True
    - require:
      - pkg: install_nspawn_requirements

disable_networkd_wait_online:
  service.dead:
    - name: systemd-networkd-wait-online.service
    - enable: False
    - require:
      - pkg: install_nspawn_requirements

# Restart systemd-networkd only if the override file changes
restart_networkd_on_change:
  service.running:
    - name: systemd-networkd
    - watch:
      - file: configure_network_interface_override
