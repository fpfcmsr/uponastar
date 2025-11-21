#!/bin/bash

set -ouex pipefail


#install packages for dolphin shortcuts
#brew install jpegoptim optipng pandoc qpdf  xclip foremost rdfind rhash testdisk
dnf5 -y install recoll perl-Image-ExifTool texlive-pdfjam ocrmypdf # the others can be installed with brew

#utilities
dnf5 -y install speech-dispatcher android-tools konsole
dnf5 -y remove ptyxis

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

touch /usr/lib/systemd/user/speech-dispatcherd.service
echo '[Unit]
Description=Speech-Dispatcher, common interface to speech synthesizers

[Service]
Type=forking
ExecStart=/usr/bin/speech-dispatcher -d -t 0
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=default.target
Alias=speech-dispatcher.service' > /usr/lib/systemd/user/speech-dispatcherd.service

touch /usr/share/ublue-os/firefox-config/02-bluefin-speech.js

echo '// Bluefin Speech Support
pref("narrate.enabled", true);
pref("narrate.filter-voices", false);' > /usr/share/ublue-os/firefox-config/02-bluefin-speech.js

touch /usr/share/ublue-os/just/70-speech.just

echo '# Setup local speech support with Pied voices and speech-dispatcher
[group('Apps')]
setup-speech-support ACTION="":
    #!/usr/bin/env bash
    source /usr/lib/ujust/ujust.sh

    OPTION={{ ACTION }}
    if [ "$OPTION" == "help" ]; then
        cat <<EOF
    Usage: ujust setup-speech-support <option>
      <option>: Specify the quick option to skip the prompt
      Use 'install' to Install speech support with Pied voices
      Use 'enable' to Enable speech-dispatcher user service
      Use 'disable' to Disable speech-dispatcher user service
      Use 'uninstall' to Uninstall Pied and disable speech support
    EOF
        exit 0
    fi
    if [ "$OPTION" == "" ]; then
        echo "${bold}Setup Local Speech Support${normal}"
        echo "This will install Pied for high-quality voices and configure speech-dispatcher"
        OPTION=$(Choose "Install" "Enable" "Disable" "Uninstall" "Exit")
    fi
    if [[ "${OPTION,,}" =~ ^install ]]; then
        echo "${green}${b}Installing${n} local speech support..."
        mkdir -p $HOME/.config/systemd/user
        # Copy the systemd user service if not already present
        if [ ! -f $HOME/.config/systemd/user/speech-dispatcherd.service ]; then
            cp /usr/lib/systemd/user/speech-dispatcherd.service $HOME/.config/systemd/user/
        fi
        # Disable system speech-dispatcher if running
        if systemctl is-enabled speech-dispatcherd.service 2>/dev/null; then
            echo "Disabling system speech-dispatcher service..."
            sudo systemctl disable speech-dispatcherd.service 2>/dev/null || true
        fi
        # Install Pied flatpak for better voices
        echo "Installing Pied flatpak for high-quality voices..."
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        flatpak install -y --user flathub page.codeberg.Elleo.Pied 2>/dev/null || \
            echo "Note: Pied may not be available on Flathub yet. You can build it from https://github.com/Elleo/pied"
        # Enable and start user service
        systemctl --user daemon-reload
        systemctl --user enable --now speech-dispatcherd.service
        echo "${green}${b}Speech support installed and enabled${n}"
        echo "Firefox has been configured with speech-dispatcher access."
        echo "In Firefox about:config, narrate.enabled and narrate.filter-voices have been set."
    elif [[ "${OPTION,,}" =~ ^enable ]]; then
        echo "${green}${b}Enabling${n} speech-dispatcher user service..."
        systemctl --user daemon-reload
        systemctl --user enable --now speech-dispatcherd.service
        echo "${green}${b}Speech support enabled${n}"
    elif [[ "${OPTION,,}" =~ ^disable ]]; then
        echo "${red}${b}Disabling${n} speech-dispatcher user service..."
        systemctl --user disable --now speech-dispatcherd.service
        echo "${red}${b}Speech support disabled${n}"
    elif [[ "${OPTION,,}" =~ ^uninstall ]]; then
        echo "${red}${b}Uninstalling${n} speech support..."
        systemctl --user disable --now speech-dispatcherd.service 2>/dev/null || true
        rm -f $HOME/.config/systemd/user/speech-dispatcherd.service
        flatpak uninstall -y --user page.codeberg.Elleo.Pied 2>/dev/null || true
        echo "${red}${b}Speech support uninstalled${n}"
    else
        echo "Have a good day :)!"
    fi' >> /usr/share/ublue-os/just/70-speech.just

#install all the downloaded rpms
dnf5 install -y /tmp/rpms/*

#ensure things downloaded to /opt and /root are present in final image and clean up symlinks
mv /opt /usr/share/factory
ln -s /var/opt /opt
ls -a /usr/share/factory/opt
