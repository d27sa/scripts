#! /bin/zsh

sed -i 's/Server =/# Server =/g' /etc/pacman.d/mirrorlist
echo 'Server = http://ftp.tsukuba.wide.ad.jp/Linux/archlinux/$repo/os/$arch
Server = https://jpn.mirror.pkgbuild.com/$repo/os/$arch' >> /etc/pacman.d/mirrorlist