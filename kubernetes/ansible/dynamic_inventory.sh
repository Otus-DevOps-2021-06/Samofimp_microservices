echo "[hosts]" > inventory

yc compute instance list | grep node | awk 'BEGIN { FS=" "; } { print $4, "ansible_host="$10; }' | sort -d >> inventory 
