{% from "salt/nspawn_container/map.jinja" import container_dir, username with context %}

apply_states_with_chroot:
  module.run:
    - chroot.apply:
      - root: {{ container_dir }}
      - mods: [ salt.nspawn_container.user_chroot ]
    - require:
      - pkg: bootstrap_minimal_container
