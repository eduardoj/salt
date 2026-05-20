{% from "salt/nspawn_container/map.jinja" import container_dir, username with context %}

# Create the user inside the container using systemd-nspawn without booting it
create_container_user:
  cmd.run:
    - name: systemd-nspawn -D {{ container_dir }} useradd -m -s /bin/bash {{ username }}
    # Idempotency check: Do not run if the user already exists in the container's passwd file
    - unless: grep -q "^{{ username }}:" {{ container_dir }}/etc/passwd
    - require:
      - pkg: bootstrap_minimal_container
