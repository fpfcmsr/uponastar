#!/bin/bash
# interactive stuff first
ujust setup-luks-tpm-unlock
ujust aurora-cli
ujust configure-grub
ujust regenerate-grub

mkdir /home/$user/Documents/SYSTEM-EDITS
git clone https://github.com/cfgnunes/nautilus-scripts.git /home/$user/Documents/SYSTEM-EDITS
sudo bash /home/$user/Documents/SYSTEM-EDITS/nautilus-scriptsinstall.sh

ujust configure-vfio
ujust configure-vfio

sudo ujust configure-nvidia
sudo ujust configure-nvidia-optimus

# things that can run in the background without user input
sudo ujust dx-group # add stuff to virtualization group
ujust install-gaming-flatpaks

# edit gpu switching config to enable seamless hotplug
sudo rm /etc/supergfxd.conf
sudo touch /etc/supergfxd.conf
sudo echo '{
“mode”: “Hybrid”,
“vfio_enable”: true,
“vfio_save”: false,
“always_reboot”: false,
“no_logind”: true,
“logout_timeout_s”: 60,
“hotplug_type”: “Asus”
}' >> /etc/supergfxd.conf

# restore kde settings 
python -m pip install konsave
konsave -i ~/aurora.knsv
