#! /bin/zsh
sudo pacman -S fcitx-im fcitx-mozc fcitx-googlepinyin kcm-fcitx
echo 'export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx' >> ~/.xprofile
