#!/bin/bash
UUID='tbc'
HOST='celina-laptop'
DOMAIN='local'
USER='celina'
GROUP='users'
TZ_SELECT='Europe/Warsaw'
LOCALE_SELECT='pl_PL.UTF-8 UTF-8'
LANG_SELECT='pl_PL.UTF-8'

# configure /etc/hostname
echo $HOST > /etc/hostname
# configure /etc/hosts
echo 127.0.0.1 localhost > /etc/hosts
echo ::1 localhost >> /etc/hosts
echo 127.0.1.1 $HOST.$DOMAIN $HOST >> /etc/hosts
# set password for root
passwd
# add users group
groupadd $GROUP
# add user
useradd -m -g $GROUP $USER
# set password for user
passwd $USER
# set timezone
timedatectl set-timezone "$TZ_SELECT"
hwclock --systohc
timedatectl set-ntp true
# set locale.gen
echo $LOCALE_SELECT >> /etc/locale.gen
# set locale.conf
echo LANG=$LANG_SELECT > /etc/locale.conf
# generate locale
locale-gen
# intel ucode
pacman -S intel-ucode
# xorg
pacman -S xorg-server xorg-xinit xorg-xinput xorg-xkill xorg-xrandr xorg-xdpyinfo arandr libwnck3 xf86-input-libinput mesa mesa-utils xterm
# nvidia
# pacman -S nvidia-dkms nvidia-utils nvidia-settings
# network
pacman -S b43-fwcutter dhclient dnsmasq dnsutils ethtool iwd modemmanager networkmanager networkmanager-openvpn nm-connection-editor nss-mdns mobile-broadband-provider-info usb_modeswitch wpa_supplicant dialog rp-pppoe
systemctl enable NetworkManager.service
# desktop enviromnent
pacman -S plasma
# login manager
pacman -S sddm
systemctl enable sddm.service
# vulkan
pacman -S vulkan-intel
# ntfs support
pacman -S ntfs-3g
# fonts
### ttf fonts
pacman -S ttf-bitstream-vera ttf-inconsolata ttf-dejavu ttf-font-awesome ttf-joypixels ttf-liberation ttf-opensans ttf-meslo-nerd
### noto-fonts
pacman -S noto-fonts noto-fonts-emoji noto-fonts-cjk
# directory support
pacman -S xdg-user-dirs xdg-utils
# audio
pacman -S alsa-firmware alsa-plugins alsa-utils
pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol
pacman -S mpg123 libcdio rtkit
# bluetooth
pacman -S bluez bluez-hid2hci bluez-libs bluez-utils
# package management
pacman -S reflector
# desktop integration
pacman -S gst-libav gst-plugin-pipewire gst-plugins-bad gst-plugins-ugly
# filesystem
pacman -S gparted unrar unzip p7zip xz
# power management
pacman -S cpupower power-profiles-daemon upower
# cups
pacman -S cups cups-filters cups-pdf
systemctl enable cups.service
# other terminal apps
pacman -S git hwinfo inxi neofetch fastfetch openssh
# kde desktop apps
pacman -S ark dolphin okular gwenview kate kcalc kcharselect spectacle
# wayland support KDE
pacman -S qt5-wayland qt6-wayland
# other apps
pacman -S celluloid mpv qmmp gimp thunderbird thunderbird-i18n-pl
# shell
pacman -S zsh
# systemd-boot install
mkdir -p /boot/loader/entries
bootctl install
# config for BTRFS!
echo default 01-arch-lts.conf > /boot/loader/loader.conf
echo timeout 4 >> /boot/loader/loader.conf
echo console-mode max >> /boot/loader/loader.conf
echo editor no >> /boot/loader/loader.conf
echo title Arch Linux LTS Kernel > /boot/loader/entries/01-arch-lts.conf
echo linux /vmlinuz-linux-lts >> /boot/loader/entries/01-arch-lts.conf
echo initrd /intel-ucode.img >> /boot/loader/entries/01-arch-lts.conf
echo initrd /initramfs-linux-lts.img >> /boot/loader/entries/01-arch-lts.conf
echo options root=PARTUUID=$UUID rootflags=subvol=/@ rw loglevel=3 nvidia-drm.modeset=1 initcall_blacklist=acpi_cpufreq_init amd_pstate.shared_mem=1 amd_pstate=passive retbleed=off mitigations=off >> /boot/loader/entries/01-arch-lts.conf
echo !!!
echo !!! DONE !!!
echo !!!