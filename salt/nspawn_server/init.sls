install_nspawn_requirements:
  pkg.installed:
    - pkgs:
      - systemd-container
      - systemd-networkd

/etc/systemd/network/80-containers-nat.network:
  file.managed:
    - source: salt://salt/nspawn_server/files/80-containers-nat.network
    - user: root
    - group: root
    - mode: "0644"
    - require:
      - pkg: install_nspawn_requirements

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
