#!/bin/bash
ujust dx-group

mkdir /home/$user/Documents/SYSTEM-EDITS
git clone https://github.com/cfgnunes/nautilus-scripts.git /home/$user/Documents/SYSTEM-EDITS
cp nautilus-install.sh /home/$user/Documents/SYSTEM-EDITS/nautilus-scripts
bash nautilus-install.sh

# edit gpu switching config to enable seamless hotplug
rm /etc/supergfxd.conf
touch /etc/supergfxd.conf
echo '{
“mode”: “Hybrid”,
“vfio_enable”: true,
“vfio_save”: false,
“always_reboot”: false,
“no_logind”: true,
“logout_timeout_s”: 60,
“hotplug_type”: “Asus”
}' >> /etc/supergfxd.conf
