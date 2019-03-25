#! /bin/zsh
tmp=$(filefrag -v /swapfile | awk '{if($1=="0:"){print $4}}')
offset=${tmp:0:$(echo $tmp | wc -m)-3}
awkcmd="{if(\$1==\"$1:\"){print \$2}}"
tmp=$(blkid | awk $awkcmd)
uuid=${tmp:6:$(echo $tmp | wc -m)-8}
str=GRUB_CMDLINE_LINUX=\"resume=UUID=${uuid}\ resume_offset=${offset}\"
cmd=s/GRUB_CMDLINE_LINUX=.*$/$str/
sed -i $cmd /etc/default/grub
