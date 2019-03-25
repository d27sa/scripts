#! /bin/zsh
echo bbswitch > /etc/modules-load.d/bbswitch.conf
echo 'blacklist nouveau' > /etc/modprobe.d/blacklist.conf
echo 'options bbswitch load_state=0 unload_state=1' > /etc/modprobe.d/bbswitch.conf
