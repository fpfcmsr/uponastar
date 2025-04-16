#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos

#install packages for dolphin shortcuts
dnf5 install -y jpegoptim optipng pandoc qpdf recoll  xclip expect

#microsoft fonts install
dnf5 install -y mscore-fonts-all 

#for phone integration via usb
dnf5 -y copr enable zeno/scrcpy
dnf5 install -y scrcpy 
dnf5 -y copr disable zeno/scrcpy

#copr install webapp manager from bazzite
dnf5 -y copr enable bazzite-org/webapp-manager
dnf5 -y install webapp-manager 
dnf5 -y copr disable bazzite-org/webapp-manager

#copr install kde-kup for backups
#dnf5 -y copr enable justinz/kup
#dnf5 install kde-kup
#dnf5 -y copr disable justinz/kup

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#install specific brother printers
rm /opt
mkdir /opt
mkdir /tmp/rpms
curl --retry 3 -Lo /tmp/rpms/mfcl2710dwpdrv-4.0.0-1.i386.rpm "https://download.brother.com/welcome/dlf103525/mfcl2710dwpdrv-4.0.0-1.i386.rpm"
curl --retry 3 -Lo /tmp/rpms/brscan4-0.4.11-1.x86_64.rpm "https://download.brother.com/welcome/dlf105203/brscan4-0.4.11-1.x86_64.rpm"
curl --retry 3 -Lo /tmp/rpms/brscan-skey-0.3.2-0.x86_64.rpm "https://download.brother.com/welcome/dlf006650/brscan-skey-0.3.2-0.x86_64.rpm"
curl --retry 3 -Lo /tmp/rpms/brother-udev-rule-type1-1.0.2-0.noarch.rpm "https://download.brother.com/welcome/dlf103900/brother-udev-rule-type1-1.0.2-0.noarch.rpm"
curl --retry 3 -Lo /tmp/rpms/brmfcfaxdrv-2.0.2-1.x86_64.rpm "https://download.brother.com/welcome/dlf105190/brmfcfaxdrv-2.0.2-1.x86_64.rpm"
dnf5 install -y /tmp/rpms/*
mv /opt /usr/share/factory
ln -s /var/opt /opt

# install dolphin helper scripts
cd /tmp
git clone https://github.com/cfgnunes/nautilus-scripts.git
cd nautilus-scripts
touch script.exp
echo '#!/usr/bin/expect -f
set timeout -1
spawn bash install.sh
match_max 100000
expect -exact "Scripts installer.\r
\r
Select the options (<SPACE> to select, <UP/DOWN> to choose):\r
\r
\r
\r
\r
\r
\[6n"
send -- "\[59;1R"
expect -exact "\[?25l\[54;1H\[\[1;32m*\[0m\] \[7mInstall basic dependencies.\[27m\[55;1H\[\[1;32m*\[0m\] Install keyboard shortcuts.\[56;1H\[\[1;32m*\[0m\] Close the file manager to reload its configurations.\[57;1H\[ \] Choose script categories to install.\[58;1H\[ \] Preserve previous scripts."
send -- " "
expect -exact "\[54;1H\[ \] \[7mInstall basic dependencies.\[27m\[55;1H\[\[1;32m*\[0m\] Install keyboard shortcuts.\[56;1H\[\[1;32m*\[0m\] Close the file manager to reload its configurations.\[57;1H\[ \] Choose script categories to install.\[58;1H\[ \] Preserve previous scripts."
send -- "\[B"
expect -exact "\[54;1H\[ \] Install basic dependencies.\[55;1H\[\[1;32m*\[0m\] \[7mInstall keyboard shortcuts.\[27m\[56;1H\[\[1;32m*\[0m\] Close the file manager to reload its configurations.\[57;1H\[ \] Choose script categories to install.\[58;1H\[ \] Preserve previous scripts."
send -- "\[B"
expect -exact "\[54;1H\[ \] Install basic dependencies.\[55;1H\[\[1;32m*\[0m\] Install keyboard shortcuts.\[56;1H\[\[1;32m*\[0m\] \[7mClose the file manager to reload its configurations.\[27m\[57;1H\[ \] Choose script categories to install.\[58;1H\[ \] Preserve previous scripts."
send -- " "
expect -exact "\[54;1H\[ \] Install basic dependencies.\[55;1H\[\[1;32m*\[0m\] Install keyboard shortcuts.\[56;1H\[ \] \[7mClose the file manager to reload its configurations.\[27m\[57;1H\[ \] Choose script categories to install.\[58;1H\[ \] Preserve previous scripts."
send -- "\[A"
expect -exact "\[54;1H\[ \] Install basic dependencies.\[55;1H\[\[1;32m*\[0m\] \[7mInstall keyboard shortcuts.\[27m\[56;1H\[ \] Close the file manager to reload its configurations.\[57;1H\[ \] Choose script categories to install.\[58;1H\[ \] Preserve previous scripts."
send -- " "
expect -exact "\[54;1H\[ \] Install basic dependencies.\[55;1H\[ \] \[7mInstall keyboard shortcuts.\[27m\[56;1H\[ \] Close the file manager to reload its configurations.\[57;1H\[ \] Choose script categories to install.\[58;1H\[ \] Preserve previous scripts."
send -- "\[A"
expect -exact "\[54;1H\[ \] \[7mInstall basic dependencies.\[27m\[55;1H\[ \] Install keyboard shortcuts.\[56;1H\[ \] Close the file manager to reload its configurations.\[57;1H\[ \] Choose script categories to install.\[58;1H\[ \] Preserve previous scripts."
send -- "\[A"
expect -exact "\[54;1H\[ \] Install basic dependencies.\[55;1H\[ \] Install keyboard shortcuts.\[56;1H\[ \] Close the file manager to reload its configurations.\[57;1H\[ \] Choose script categories to install.\[58;1H\[ \] \[7mPreserve previous scripts.\[27m"
send -- "\[B"
expect -exact "\[54;1H\[ \] \[7mInstall basic dependencies.\[27m\[55;1H\[ \] Install keyboard shortcuts.\[56;1H\[ \] Close the file manager to reload its configurations.\[57;1H\[ \] Choose script categories to install.\[58;1H\[ \] Preserve previous scripts."
send -- "\r"
expect eof
' >> script.exp
./script.exp

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
“hotplug_type”: “None”
}' >> /etc/supergfxd.conf

#### Example for enabling a System Unit File

systemctl enable podman.socket
systemctl enable supergfxd.service 
systemctl disable nvidia-persistenced
systemctl mask nvidia-persistenced

