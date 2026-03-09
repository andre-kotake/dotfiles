# chezmoi:template:left-delimiter="# {{"
{
  gpg --quiet --import <<'EOF'
# {{ keepassxcAttachment "Git/GPG" "secret-subkeys.asc" }}
EOF
} >/dev/null 2>&1

{
  read -r -d '' _ownertrust <<'EOF'
# {{ keepassxcAttachment "Git/GPG" "ownertrust" }}
EOF

  gpg --quiet --import-ownertrust < <(echo "$_ownertrust")
} >/dev/null 2>&1
