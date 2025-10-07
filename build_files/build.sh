#!/bin/bash

set -ouex pipefail


#install packages for dolphin shortcuts
#brew install jpegoptim optipng pandoc qpdf  xclip foremost rdfind rhash testdisk
#dnf5 -y install recoll perl-Image-ExifTool texlive-pdfjam ocrmypdf # the others can be installed with brew

#utilities
#dnf5 -y install speech-dispatcher android-tools konsole

#remove unwanted stuff
#dnf5 -y remove google-noto-*

#dnf5 -y install google-droid-fonts-all

# install KLASSY
#dnf5 -y copr enable errornointernet/klassy
#dnf -y install --setopt=install_weak_deps=False klassy
#dnf5 -y copr disable errornointernet/klassy

# Get the current Fedora version
#FEDORA_VERSION=$(rpm -E %fedora)

# Add the repo using the detected Fedora version
#dnf config-manager addrepo --from-repofile="https://download.opensuse.org/repositories/home:paul4us/Fedora_${FEDORA_VERSION}/home:paul4us.repo"

# Install the package with dnf5
#dnf5 -y install --setopt=install_weak_deps=False klassy

#copr install webapp manager from bazzite
#dnf5 -y copr enable bazzite-org/webapp-manager
#dnf5 -y install webapp-manager 
#dnf5 -y copr disable bazzite-org/webapp-manager

#vapor theme for kde from bazzite
#dnf5 -y copr enable bazzite-org/bazzite
#dnf5 -y install steamdeck-kde-presets-desktop
#dnf5 -y copr disable bazzite-org/bazzite
