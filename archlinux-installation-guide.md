Archlinux Installation Guide on Dell XPS 15 9550
===

Pre-installation Preparations
---

### Change BIOS Settings

Press `F2` when booting and do the following:

- Change the SATA Mode from the default "RAID" to "AHCI".
- Change Fastboot to "Thorough" in "POST Behaviour".
- Turn off the Secure Boot.

### Download and Verify the ISO file

Find a site to download the ISO and signature files [here](https://www.archlinux.org/download/).

Verify the signature on a current installed archlinux system with the following command:

	pacman-key -v archlinux-version-x86_64.iso.sig

### Write the ISO file to a USB stick

Use the following command (the device file name must be **without partition number**):

	dd bs=4M if=path/to/archlinux.iso of=/dev/sdx status=progress oflag=sync

Or simply use the script `scripts/write-usb.sh if of`.


Install the Archlinux System
---

### Boot into live disk environment

Press `F12` when booting and choose the USB stick.

### Verify the boot mode

If the output of the command `ls /sys/firmware/efi/efivars` is not empty, your system is booting with UEFI.

### Connect to the Internet

List the network interfaces with `ip link`, and set up the specified interface (assume that the interface's name is `wlp2s0`):

	ip link set wlp2s0 up

Connect to the Internet using wpa_supplicant:

	wpa_passphrase SSID password > /etc/wpa_supplicant/sample.conf
	wpa_supplicant -B -i wlp2s0 -c /etc/wpa_supplicant/sample.conf
	dhcpcd wlp2s0

The Internet should be connected successfully now. You can check with the `ping` command.

All the step above can be substitute by using the script:

	scripts/conwifi.sh wlp2s0 SSID password

### Update the system clock

	timedatectl set-ntp true

You can check the status with `timedatectl status`.

### Disk Partition

Use `fdisk -l` to lisk the partition table of all devices.

Assuming you want to partition the device `/dev/nvme0n1`, use `fdisk /dev/nvme0n1`.

The following partitions are required:

- a 512Mib EFI System Partition for the mount point `/boot` (type 1)
- a Linux x86-64 root partition for the mount point `/` (type 24)

### Format the partitions

Format the ESP partition:

	mkfs.fat -F 32 /dev/nvme0n1px

Format the root partition:

	mkfs.ext4 /dev/nvme0n1px

### Mount the partitions

Mount the root partition to `/mnt`:

	mount /dev/nvme0n1px /mnt

Create the `/mnt/boot` directory and mount the ESP partition:

	mkdir /mnt/boot
	mount /dev/nvme0n1px /mnt/boot

### Choose Mirrors

Edit the file `/etc/pacman.d/mirrorlist` and move preferred mirrors to the top of the file.  
Here are some good mirrors in Japan:

- <http://ftp.tsukuba.wide.ad.jp/Linux/archlinux/>
- <https://jpn.mirror.pkgbuild.com/>

### Install packages to your new system

	pacstrap /mnt base base-devel plasma-meta kde-applications-meta intel-ucode grub efibootmgr gvim bbswitch pulseaudio-bluetooth git openssh zsh noto-fonts-cjk rsync gparted gst-libav latte-dock telepathy-morse aria2 go

Or use the script `scripts/pkg-install.sh`.

### Generate the fstab

	genfstab -U /mnt >> /mnt/etc/fstab

Remember to check the `/mnt/etc/fstab` file.

### Change root to the new system

	arch-chroot /mnt

### Set the default shell of root to zsh

	chsh -s /bin/zsh

### Create the swap file

	dd if=/dev/zero of=/swapfile bs=1M count=16384 status=progress
	chmod 600 /swapfile
	mkswap /swapfile
	swapon /swapfile
	echo '/swapfile none swap defaults 0 0' >> /etc/fstab

Or use the script `scripts/cswapfile.sh`.

Check the status of the swap file with `free -h` or `swapon -s`.

### Configure hibernation

Get the offset of the swapfile:

	filefrag -v /swapfile | awk '{ if($1=="0:"){print $4} }'

Get the UUID of the root partition with `blkid`.

Edit `/etc/default/grub`, set the following content:

	GRUB_CMDLINE_LINUX=“resume=UUID=root_uuid resume_offset=swap_offset”

All the steps can be substitute by the script:

	scripts/cfghib.sh /dev/sda1(root partition)

### Change boot mode

Edit `/etc/mkinitcpio.conf` and change `udev` in the "HOOKS=..." line to `systemd`.

### Enable systemd services

	systemctl enable sddm
	systemctl enable bluetooth
	systemctl enable NetworkManager

All the steps can be replaced with `scripts/systemd-on.sh`.

### Set time zone

	ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
	hwclock --systohc

### Localization

Edit `/etc/locale.gen`, uncomment the following lines:

	en_US.UTF-8 UTF-8
	zh_CN.UTF-8 UTF-8
	zh_TW.UTF-8 UTF-8
	ja_JP.UTF-8 UTF-8

Then run `locale-gen`.

Set the `LANG` environment variable:

	echo LANG=en_US.UTF-8 > /etc/locale.conf

All the steps can be replaced with `scripts/cfgloc.sh`.

### Set hostname and hosts

	echo Arch > /etc/hostname

Edit `/etc/hosts`, add the following content:

	127.0.0.1	localhost
	::1		localhost
	127.0.1.1	Arch.localdomain	Arch

All the steps can be replaced with `scripts/set-host.sh`.

### Set root password

Use `passwd` command.

### Create the sudo user group

	groupadd sudo

Run `visudo`, uncomment the line starts with `%sudo`.

### Add a new user

	useradd -m -G sudo -s /bin/zsh me

Set password for the new user with `passwd me`.

### Disable the descrete display card

	echo bbswitch > /etc/modules-load.d/bbswitch.conf
	echo 'blacklist nouveau' > /etc/modprobe.d/blacklist.conf
	echo 'options bbswitch load_state=0 unload_state=1' > /etc/modprobe.d/bbswitch.conf

Or use `scripts/cfgbbswitch.sh`.

Check if the descrete display card is successfully disabled after reboot. `lspci` shoud show "ff" and the content of `/proc/acpi/bbswitch` should be "off".

### Generate the initramfs image

	mkinitcpio -p linux

### Install GRUB

	grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
	grub-mkconfig -o /boot/grub/grub.cfg

Or use `scripts/cfggrub.sh`.

### Exit the chroot environment

	exit

### Unmount all partitions

	umount -R /mnt

### Reboot the system

	reboot


Post-installation Recommendations
---

### Install and configure the input method

Install necessary packages:

	sudo pacman -S fcitx-im fcitx-mozc fcitx-rime kcm-fcitx

Edit `~/.xprofile`, add the following content:

	export GTK_IM_MODULE=fcitx
	export QT_IM_MODULE=fcitx
	export XMODIFIERS=@im=fcitx

Or use `scripts/cfgim.sh`.

Log out and log in again.

Download the XHUP schema [here](http://flypy.ys168.com/) and extract it. Copy all files starts with "flypy" in the `rime-data` directory to `~/.config/fcitx/rime/`. Copy all files in `rime-data/build` to `~/.config/fcitx/rime/build/`.  
Edit `~/.config/fcitx/rime/build/default.yaml`, add `flypy` and `flypyplus` to schema list and comment others.  
Re-deploy rime.

### Install the AUR helper yay

	git clone https://aur.archlinux.org/yay-bin.git
	cd yay-bin && makepkg -si

### Install useful AUR packages

	yay google-chrome
	yay visual-studio-code-bin

### Install virtualbox

	sudo pacman -S virtualbox virtualbox-guest-iso # Choose 2 (the one ends with "arch")
	sudo gpasswd -a me vboxusers
	yay virtualbox-ext-oracle
	sudo reboot

### Install and configure postgresql

	sudo pacman -S postgresql
	sudo mkdir /var/lib/postgres
	sudo chown postgres:postgres /var/lib/postgres
	sudo -u postgres initdb -D /var/lib/postgres/data
	sudo systemctl enable postgresql
	sudo systemctl start postgresql

