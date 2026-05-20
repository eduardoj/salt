{% from "salt/nspawn_container/map.jinja" import container_dir, container_name with context %}

# Ensure the container is completely stopped and disabled before purging
ensure_container_is_stopped_for_purge:
  service.dead:
    - name: systemd-nspawn@{{ container_name }}
    - enable: False

# Remove the container's .nspawn configuration file
remove_nspawn_config:
  file.absent:
    - name: {{ container_dir }}.nspawn
    - require:
      - service: ensure_container_is_stopped_for_purge

# Remove the container root directory
# Note: 'file.absent' is recursive. This will wipe out the directory structure
# and any repository metadata created within it.
remove_container_root_dir:
  file.absent:
    - name: {{ container_dir }}
    - require:
      - file: remove_nspawn_config
