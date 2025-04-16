#!/bin/bash
ujust dx-group

mkdir /home/$user/Documents/SYSTEM-EDITS
git clone https://github.com/cfgnunes/nautilus-scripts.git /home/$user/Documents/SYSTEM-EDITS
cp nautilus-install.sh /home/$user/Documents/SYSTEM-EDITS/nautilus-scripts
bash nautilus-install.sh

