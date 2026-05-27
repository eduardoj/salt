{% from "salt/nspawn_container/map.jinja" import container_dir with context %}

# Ensure the network configuration directory exists inside the container layout
{{ container_dir }}/etc/systemd/network:
  file.directory:
    - makedirs: True
    - require:
      - pkg: bootstrap_minimal_container

# Deploy the network configuration file inside the container
{{ container_dir }}/etc/systemd/network/80-container-eth.network:
  file.managed:
    - source: salt://salt/nspawn_container/files/80-container-eth.network
    - user: root
    - group: root
    - mode: "0644"
    - require:
      - file: {{ container_dir }}/etc/systemd/network

container_systemd_networkd_is_enabled:
  cmd.run:
    - name: systemctl --root={{ container_dir }} enable systemd-networkd
    - unless: systemctl --root={{ container_dir }} is-enabled systemd-networkd
    - require:
      - file: {{ container_dir }}/etc/systemd/network/80-container-eth.network

container_systemd_resolved_is_enabled:
  cmd.run:
    - name: systemctl --root={{ container_dir }} enable systemd-resolved
    - unless: systemctl --root={{ container_dir }} is-enabled systemd-resolved
    - require:
      - cmd: container_systemd_networkd_is_enabled

# Openssh server
container_remove_busybox_grep:
  pkg.removed:
    - name: busybox-grep
    - root: {{ container_dir }}
    - require:
      - pkg: bootstrap_minimal_container

container_install_openssh_server:
  pkg.installed:
    - pkgs: [ openssh-server ]
      # - refresh: True
    - root: {{ container_dir }}
    - require:
      - pkg: container_remove_busybox_grep

container_sshd_is_enabled:
  cmd.run:
    - name: systemctl --root={{ container_dir }} enable sshd
    - unless: systemctl --root={{ container_dir }} is-enabled sshd
    - require:
      - pkg: container_install_openssh_server
