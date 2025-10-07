#!/bin/bash

set -ouex pipefail


#install packages for dolphin shortcuts
#brew install jpegoptim optipng pandoc qpdf  xclip foremost rdfind rhash testdisk
dnf5 -y install recoll perl-Image-ExifTool texlive-pdfjam ocrmypdf # the others can be installed with brew

#utilities
dnf5 -y install speech-dispatcher android-tools konsole

#remove unwanted stuff
dnf5 -y remove ptyxis
dnf5 -y remove google-noto-*

dnf5 -y install google-droid-fonts-all

# install KLASSY
#dnf5 -y copr enable errornointernet/klassy
#dnf -y install --setopt=install_weak_deps=False klassy
#dnf5 -y copr disable errornointernet/klassy

dnf config-manager addrepo --from-repofile=https://download.opensuse.org/repositories/home:paul4us/Fedora_42/home:paul4us.repo
dnf5 -y install --setopt=install_weak_deps=False klassy

#copr install webapp manager from bazzite
dnf5 -y copr enable bazzite-org/webapp-manager
dnf5 -y install webapp-manager 
dnf5 -y copr disable bazzite-org/webapp-manager

#vapor theme for kde from bazzite
dnf5 -y copr enable bazzite-org/bazzite
dnf5 -y install steamdeck-kde-presets-desktop
dnf5 -y copr disable bazzite-org/bazzite
