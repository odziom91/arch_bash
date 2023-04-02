#!/bin/bash
lsblk
read -p "Check partitions before continue! - press Enter"
# check efi
echo TEST EVIVARS
ls /sys/firmware/efi/efivars
# check ping
echo TEST PING
ping archlinux.org -c 10
# format efi
mkfs.fat -n ARCH_BOOT -F 32 /dev/sda1
# format btrfs
mkfs.btrfs -f -L ARCH /dev/sda2
# create subvolumens
mount /dev/sda2 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@cache
btrfs subvolume create /mnt/@.snapshots
umount /mnt
# mount root
mount -o noatime,commit=120,compress=zstd,subvol=@ /dev/sda2 /mnt
# create dirs
mkdir -p /mnt/{boot,home,.snapshots,var/log,var/cache}
# mount dirs
mount -o noatime,commit=120,compress=zstd,subvol=@home /dev/sda2 /mnt/home
mount -o noatime,commit=120,compress=zstd,subvol=@cache /dev/sda2 /mnt/var/cache
mount -o noatime,commit=120,compress=zstd,subvol=@log /dev/sda2 /mnt/var/log
mount -o noatime,commit=120,compress=zstd,subvol=@.snapshots /dev/sda2 /mnt/.snapshots
mount /dev/sda1 /mnt/boot
# install base
pacman -Syy
pacstrap /mnt base base-devel linux-lts linux-firmware linux-lts-headers nano mc sudo wget
# generate fstab
genfstab -U /mnt >> /mnt/etc/fstab
# copy mirrorlist
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
echo !!!
echo !!! DONE !!!
echo !!! Remember to update UUID in post!
echo !!!