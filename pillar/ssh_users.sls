# /srv/pillar/ssh_users.sls

# Global catalog of external users and their respective public keys
# external_users:
#   user_with_public_key:
#     - "ssh-ed25519 AAAA123456789012345678901234567890123456789012345678901234567890 user@machine.com

# Selection list: Only these users will be granted access to this specific container
# authorized_external_users:
#   - user_with_public_key
