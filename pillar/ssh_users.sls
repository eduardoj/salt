# /srv/pillar/ssh_users.sls

# Global catalog of external users and their respective public keys
external_users:
  eduardoj:
    - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTK/oa48rszHZowz0/kPgZKEWi9mOsm8Cfn+orMd8R8 eduardo@linux-jtiv.suse.de"

# Selection list: Only these users will be granted access to this specific container
authorized_external_users:
  - eduardoj
