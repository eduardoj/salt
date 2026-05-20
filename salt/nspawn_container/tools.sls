{% from "salt/nspawn_container/map.jinja" import container_dir with context %}

# Install user-specific packages inside the container root
install_container_utilities:
  pkg.installed:
    - pkgs:
      - neovim
      - less
      - git
      - tmux
    - root: {{ container_dir }}
    - require:
      - pkg: bootstrap_minimal_container
