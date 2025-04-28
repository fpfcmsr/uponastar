#!/bin/bash

set -ouex pipefail

### Install packages

#install packages for dolphin shortcuts + expect for bash noninteractive
dnf5 -y install jpegoptim optipng pandoc qpdf recoll  xclip expect

# install btrfs assistant
dnf5 -y install btrfs-assistant

#microsoft fonts install
dnf5 -y install mscore-fonts-all xorg-x11-font-utils cabextract fontconfig
rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

#setup etckeeper
dnf5 -y install etckeeper 

#for phone integration via usb
dnf5 -y copr enable zeno/scrcpy
dnf5 install -y scrcpy 
dnf5 -y copr disable zeno/scrcpy

# install webapp manager from bazzite
dnf5 -y copr enable bazzite-org/webapp-manager
dnf5 -y install webapp-manager 
dnf5 -y copr disable bazzite-org/webapp-manager

#vapor theme for kde from bazzite
dnf5 -y copr enable bazzite-org/bazzite
dnf5 -y install steamdeck-kde-presets-desktop
dnf5 -y copr disable bazzite-org/bazzite

#install specific brother printers
mkdir /tmp/rpms
curl --retry 3 -Lo /tmp/rpms/mfcl2710dwpdrv-4.0.0-1.i386.rpm "https://download.brother.com/welcome/dlf103525/mfcl2710dwpdrv-4.0.0-1.i386.rpm"
curl --retry 3 -Lo /tmp/rpms/brscan4-0.4.11-1.x86_64.rpm "https://download.brother.com/welcome/dlf105203/brscan4-0.4.11-1.x86_64.rpm"
curl --retry 3 -Lo /tmp/rpms/brscan-skey-0.3.2-0.x86_64.rpm "https://download.brother.com/welcome/dlf006650/brscan-skey-0.3.2-0.x86_64.rpm"
#curl --retry 3 -Lo /tmp/rpms/brother-udev-rule-type1-1.0.2-0.noarch.rpm "https://download.brother.com/welcome/dlf103900/brother-udev-rule-type1-1.0.2-0.noarch.rpm"
curl --retry 3 -Lo /tmp/rpms/brmfcfaxdrv-2.0.2-1.x86_64.rpm "https://download.brother.com/welcome/dlf105190/brmfcfaxdrv-2.0.2-1.x86_64.rpm"
dnf5 install -y /tmp/rpms/*
#note to self: install the brother udev rules post installation


# Things not currently included but may revisit
# install zed editor
#dnf5 -y config-manager setopt "terra*".enabled=true
#dnf5 -y install zed
#dnf5 -y config-manager setopt "terra*".enabled=false

# for stuff that writes to /opt ??? unsure
# rm /opt
# mkdir /opt
# mv /opt /usr/share/factory
# ln -s /var/opt /opt

