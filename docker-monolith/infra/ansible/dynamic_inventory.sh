echo "[docker-hosts]" > inventory

yc compute instance list | grep docker-host | awk 'BEGIN { FS=" "; } { print $4, "ansible_host="$10; }' | sort -d >> inventory 
