{% from "salt/nspawn_container/map.jinja" import username with context %}

create_container_user:
  user.present:
    - name: {{ username }}

ensure_ssh_dir_permissions:
  file.directory:
    - name: /home/{{ username }}/.ssh
    - user: {{ username }}
    - group: {{ username }}
    - mode: 700
    - makedirs: True
    - require:
      - user: create_container_user

# Copy public keys
{% set external_users = salt['pillar.get']('external_users', {}) %}
{% set authorized_users = salt['pillar.get']('authorized_external_users', []) %}

{% for authorized_user in authorized_users %}
  {% if authorized_user in external_users %}
    {% for key in external_users[authorized_user] %}
      {% set key_type = key.split(' ')[0] %}

configure_ssh_key_{{ authorized_user }}_{{ loop.index }}:
  ssh_auth.present:
    - name: {{ key }}
    - user: {{ username }}
    - enc: {{ key_type }}
    - config: /home/{{ username }}/.ssh/authorized_keys
    - require:
      - file: ensure_ssh_dir_permissions
    {% endfor %}
  {% endif %}
{% endfor %}
