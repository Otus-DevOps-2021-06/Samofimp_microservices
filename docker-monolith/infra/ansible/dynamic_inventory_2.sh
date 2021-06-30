echo "[gitlab-host]" > inventory

yc compute instance list | grep gitlab-ci-vm | awk 'BEGIN { FS=" "; } { print $4, "ansible_host="$10; }' | sort -d >> inventory 
