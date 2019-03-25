sed -i '/#en_US.UTF-8/c en_US.UTF-8 UTF-8' /etc/locale.gen
sed -i '/#zh_CN.UTF-8/c zh_CN.UTF-8 UTF-8' /etc/locale.gen
sed -i '/#zh_TW.UTF-8/c zh_TW.UTF-8 UTF-8' /etc/locale.gen
sed -i '/#ja_JP.UTF-8/c ja_JP.UTF-8 UTF-8' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
