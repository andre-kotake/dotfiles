readarray -t installed_packages < <(zypper search --installed-only --details | awk -F'|' '/^i/ {gsub(/^ *| *$/, "", $2); print $2}')
