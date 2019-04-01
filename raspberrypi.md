Raspberrypi Notes
===

Connect to laptop by ethernet cable
---

The `dnsmasq` and `nmap` package is required.

Set the wired connection IPv4 setting to "Shared to other computers". Find the ip address of this connection (assume it's `10.42.0.1`).

Use `nmap 10.42.0.1/24` to find the ip address of the raspberrypi (assume it's `10.42.0.52`).

SSH to the raspberrypi with `ssh pi@10.42.0.52 -p 22`.