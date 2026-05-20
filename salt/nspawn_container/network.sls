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
