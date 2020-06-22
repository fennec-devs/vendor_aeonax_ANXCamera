#!/bin/bash
#
# Script to decompile ANXCamera apk, change paths and recompile

# clone tools
git clone https://github.com/XEonAX/ANXMiuiPortTools -b phoenixin11.0.4.0

# decompile apk
wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.4.1.jar
java -jar apktool_2.4.1.jar d -p ANXMiuiPortTools/MiuiFrameworks -r -b proprietary/product/priv-app/ANXCamera/ANXCamera.apk

# alter paths for our convenience
# /system/etc/ANXCamera -> /product/etc/ANXCamera (mimoji)
# /sdcard/.ANXCamera -> /product/etc/ANXCamera (device configs)
cd ANXCamera
grep -lr "system/etc/ANXCamera" | xargs sed -i 's|system/etc/ANXCamera|product/etc/ANXCamera|g'
grep -lr "/sdcard/.ANXCamera" | xargs sed -i 's|/sdcard/.ANXCamera|/product/etc/ANXCamera|g'
cd ..

# recompile
# skipping zipalign and sign as android build system does it
java -jar apktool_2.4.1.jar b -p ANXMiuiPortTools/MiuiFrameworks -o ANXCamera.apk ANXCamera
mv ANXCamera.apk proprietary/product/priv-app/ANXCamera/ANXCamera.apk

# cleanup
git clean -fd
rm -rf ANXMiuiPortTools
