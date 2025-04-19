#!/bin/bash
# interactive stuff first
ujust setup-luks-tpm-unlock
ujust aurora-cli
ujust configure-grub
ujust regenerate-grub

mkdir /home/$user/Documents/SYSTEM-EDITS
git clone https://github.com/cfgnunes/nautilus-scripts.git /home/$user/Documents/SYSTEM-EDITS
sudo bash /home/$user/Documents/SYSTEM-EDITS/nautilus-scriptsinstall.sh

ujust configure-vfio # enable vfio
ujust configure-vfio # setup looking glass

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

# set initramfs to regen
rpm-ostree initramfs --enable

# restore kde settings 
python -m pip install konsave
konsave -i ~/aurora.knsv

# setting up looking glass
sudo touch /etc/udev/rules.d/99-kvmfr.rules 
sudo echo 'SUBSYSTEM=="kvmfr", OWNER="user", GROUP="kvm", MODE="0660"' >> /etc/udev/rules.d/99-kvmfr.rules
# get $user -> replace user with $user here: 'SUBSYSTEM=="kvmfr", OWNER="user", GROUP="kvm", MODE="0660"'
# todo next: Edit the file /etc/libvirt/qemu.conf and uncomment the cgroup_device_acl block, adding /dev/kvmfr0 to the list. To make this change active you then must restart libvirtd
