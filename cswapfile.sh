#! /bin/zsh
dd if=/dev/zero of=/swapfile bs=1M count=16384 status=progress
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '# /swapfile
/swapfile none swap defaults 0 0' >> /etc/fstab
