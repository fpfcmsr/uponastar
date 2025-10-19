#!/bin/bash

set -ouex pipefail


#install packages for dolphin shortcuts
#brew install jpegoptim optipng pandoc qpdf  xclip foremost rdfind rhash testdisk
dnf5 -y install recoll perl-Image-ExifTool texlive-pdfjam ocrmypdf # the others can be installed with brew

#utilities
dnf5 -y install speech-dispatcher android-tools konsole

# Get the current Fedora version
FEDORA_VERSION=$(rpm -E %fedora)

# Add the repo using the detected Fedora version
dnf config-manager addrepo --from-repofile="https://download.opensuse.org/repositories/home:paul4us/Fedora_${FEDORA_VERSION}/home:paul4us.repo"

# Install the package with dnf5
dnf5 -y install klassy

#copr install webapp manager from bazzite
dnf5 -y copr enable bazzite-org/webapp-manager
dnf5 -y install webapp-manager 
dnf5 -y copr disable bazzite-org/webapp-manager

#vapor theme for kde from bazzite (so we get good GTK theming)
dnf5 -y copr enable bazzite-org/bazzite
dnf5 -y install steamdeck-kde-presets-desktop
dnf5 -y copr disable bazzite-org/bazzite

rm /opt
mkdir /opt
#create directory for custom rpm download and install
mkdir /tmp/rpms

# get and download / install bitwarden rpm
URL=$(curl -s https://api.github.com/repos/bitwarden/clients/releases | jq -r 'first(.[] | .assets[]? | select(.browser_download_url | endswith(".rpm")) | .browser_download_url)')
echo "Downloading Bitwarden from $URL"
curl -sL -o /tmp/rpms/bitwarden-latest.rpm "$URL"
#bitwarden policy file
touch /usr/share/polkit-1/actions/com.bitwarden.Bitwarden.policy
echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE policyconfig PUBLIC
 "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/PolicyKit/1.0/policyconfig.dtd">

<policyconfig>
    <action id="com.bitwarden.Bitwarden.unlock">
      <description>Unlock Bitwarden</description>
      <message>Authenticate to unlock Bitwarden</message>
      <defaults>
        <allow_any>no</allow_any>
        <allow_inactive>no</allow_inactive>
        <allow_active>auth_self</allow_active>
      </defaults>
    </action>
</policyconfig>' > /usr/share/polkit-1/actions/com.bitwarden.Bitwarden.policy

#install all the downloaded rpms
dnf5 install -y /tmp/rpms/*

#ensure things downloaded to /opt and /root are present in final image and clean up symlinks
mv /opt /usr/share/factory
ln -s /var/opt /opt
ls -a /usr/share/factory/opt
