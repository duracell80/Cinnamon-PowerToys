#!/bin/sh

sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/mint-logo/mint-logo.plymouth 200
sudo update-alternatives --set default.plymouth /usr/share/plymouth/themes/mint-logo/mint-logo.plymouth

sudo update-alternatives --config default.plymouth

sudo update-initramfs -u -k all
sudo update-grub
