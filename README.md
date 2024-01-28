# batch-ip-scan.bat
Easy to use IP Port Scanner &amp; Subnet calculator based on Batch-Script for Windows 

- No Install
- No Admin rights 
- No Root needed
- No Antivirus or EDR detection

Just running a subnet scan with pure batch!

![Thumb](/files-src/screen01.PNG )

# Features
- Check your Network for aliving IP's and /or hostnames without any rights/permissions.
- Automatically find your own IP address / hostname and network.
- Using CIDR. See more: https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing
- You can easily calculate your Network / Netmask / Broadcast / Possible scan-range etc. Good for educational purposes!
- Works on all Windows (NT) / DOS Versions with batch interpreter!
- Creates an easy to read logfile for later purposes.
- Portscanning is soon available with additional tools / Telnet / or netcat TCP-SYNscans (Needs more permissions!)
- One Simple first check!

# How to Run:
## Requirements:

1. Requires nothing but a Windows installation and a double click on ```batch-ip-scan.bat``` 
2. Automatically find your own IP address & network, but you can also put in your desired Network/IP/Hostname
3. Put in your wished network scan-range in CIDR-Style. (Default: 24) > (Calculate fast with: ```2^24-2 = 254 Adresses```) See more: https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing

## On Linux / macOS / BSD:

Maybe it works also on Linux / macOS / BSD etc. with an Emulator (Like Wine)/A Virtual Mashine (VMWare/Qemu/Virtual Box)

<hr>

# Adding Nextcloud Account to your Windows as Network Drive:
Just add this file to: ```shell:startup``` -> ```Nextcloud_Startup_Drive.bat```

#### Setup an encoded password with `setup_b64_password.bat`

![grafik](https://github.com/suuhm/batch-ip-scan.bat/assets/11504990/abb30302-1c40-4f72-8205-f135bd0ae173)



# This script is beta! So please let me know if you have some issues

# Legal Disclaimer:

The project batch-ip-scan is made for educational and ethical testing purposes only. Usage of this tool for attacking targets without prior mutual consent is illegal. It is the end user's responsibility to obey all applicable local, state and federal laws. Developers assume no liability and are not responsible for any misuse or damage caused by this program. Thanks.
