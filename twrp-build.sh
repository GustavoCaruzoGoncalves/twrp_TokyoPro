#!bin/bash

# Go to the working directory
mkdir ~/TWRP-9 && cd ~/TWRP-9
# Sync the source
repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git -b twrp-9.0
repo sync  -f --force-sync --no-clone-bundle --no-tags -j$(nproc --all)
# Clone device tree and common tree
git clone --depth=1 https://github.com/GustavoCaruzoGoncalves/twrp_TokyoPro device/TCL/TokyoPro
git clone --depth=1 https://github.com/osm0sis/twrp_abtemplate device/TCL/TokyoPro/installer
# Build recovery image
export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; lunch omni_TokyoPro-eng; make -j$(nproc --all) recoveryimage
# Make the recovery installer
cp -fr device/TCL/TokyoPro/installer out/target/product/TokyoPro
cd out/target/product/TokyoPro
cp -f ramdisk-recovery.cpio installer
cd installer
zip -qr recovery-installer ./
cd .. &&  cp -f installer/recovery-installer.zip .
# Rename and copy the files
twrp_version=$(cat ~/TWRP-9/bootable/recovery/variables.h | grep "define TW_MAIN_VERSION_STR" | cut -d '"' -f2)
date_time=$(date +"%d%m%Y%H%M")
mkdir ~/final
cp recovery.img ~/final/twrp-$twrp_version-TokyoPro-"$date_time"-unofficial.img
cp recovery-installer.zip ~/final/twrp-$twrp_version-TokyoPro-"$date_time"-unofficial.zip