install_nspawn_requirements:
  pkg.installed:
    - pkgs:
      - systemd-container
      - systemd-networkd

configure_networkd_override:
  file.managed:
    - name: /etc/systemd/networkd.conf.d/systemd-nspawn-override.conf
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        [Network]
        Address=172.16.10.1/24
    - require:
      - pkg: install_nspawn_requirements

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
