#! /bin/zsh
echo Arch > /etc/hostname
echo '127.0.0.1 localhost
::1 localhost
127.0.1.1 Arch.localdomain Arch' >> /etc/hosts
