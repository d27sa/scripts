#! /bin/zsh

if [ $# -lt 3 ]; then
	echo 'Usage: conwifi interface ssid password'
else
	ip link set $1 up
	wpa_passphrase $2 $3 > /etc/wpa_supplicant/wifi.conf
	wpa_supplicant -B -i $1 -c /etc/wpa_supplicant/wifi.conf
	dhcpcd $1
fi
