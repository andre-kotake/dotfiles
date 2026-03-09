mapfile -t packages < <(dpkg --get-selections | awk '{print $1}')
