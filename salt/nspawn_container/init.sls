{% from "salt/nspawn_container/map.jinja" import container_dir, container_name with context %}

include:
  - salt.nspawn_server
  - salt.nspawn_container.network
  - salt.nspawn_container.tools
  - salt.nspawn_container.user

# Ensure the container root directory exists before bootstrap
create_container_root_dir:
  file.directory:
    - name: {{ container_dir }}
    - makedirs: True

# Initialize the openSUSE Tumbleweed OSS repository
repo_tumbleweed_container:
  pkgrepo.managed:
    - humanname: repo-oss
    - baseurl: https://cdn.opensuse.org/tumbleweed/repo/oss/
    - root: {{ container_dir }}
    # - gpgcheck: 1
    # - gpgautoimport: True
    - gpgcheck: 0
    - gpgkey: https://cdn.opensuse.org/tumbleweed/repo/oss/repodata/repomd.xml.key
    - require:
      - file: create_container_root_dir
      - service: ensure_container_is_stopped

# Bootstrap the necessary packages to have a bootable/functional system
bootstrap_minimal_container:
  pkg.installed:
    - pkgs: [
      openSUSE-release, shadow,
      systemd, systemd-networkd, systemd-resolved,
      rpm, zypper,
      neovim, ripgrep,
      iproute2, iputils, procps, hostname, curl, ca-certificates,
      coreutils, terminfo, glibc-locale, glibc-i18ndata
    ]
    # - refresh: True
    - root: {{ container_dir }}
    - require:
      - service: ensure_container_is_stopped
      - pkgrepo: repo_tumbleweed_container

/etc/systemd/nspawn/{{ container_name }}.nspawn:
  file.managed:
    - source: salt://salt/nspawn_container/files/tumbleweed.nspawn
    - user: root
    - group: root
    - mode: "0644"
    - template: jinja
    - require:
      - pkg: bootstrap_minimal_container

# =============================================================================
# CONTROL STATES
# =============================================================================

# Ensure the container is stopped before any post-bootstrap configurations
# attempt to safely modify its filesystem.
ensure_container_is_stopped:
  service.dead:
    - name: systemd-nspawn@{{ container_name }}
    - require:
      - pkg: install_nspawn_requirements
