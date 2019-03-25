#! /bin/zsh
# Connect wifi with wpa_supplicant

if [ $# -lt 3 ]; then
	echo 'Usage: conwifi interface ssid password'
else
	ip link set $1 up
	wpa_passphrase $2 $3 > wpa_supplicant.tmp.conf
	wpa_supplicant -B -i $1 -c wpa_supplicant.tmp.conf
	dhcpcd $1
	rm wpa_supplicant.tmp.conf
fi
