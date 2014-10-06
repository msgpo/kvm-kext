#!/bin/bash -e

mkdir -p kvm.kext/Contents/MacOS
gcc -static main.c -o kvm.kext/Contents/MacOS/kvm -fno-builtin -nostdlib -lkmod -r -I/System/Library/Frameworks/Kernel.framework/Headers -Wall -Xlinker -kext

# copy
sudo rm -rf /tmp/kvm.kext
cp -rp kvm.kext /tmp/

# codesign
codesign -v -s "George Hotz" /tmp/kvm.kext

# set permissions
sudo chown -R root:wheel /tmp/kvm.kext
sudo chmod -R 0644 /tmp/kvm.kext

# load the kext
sudo kextload -v /tmp/kvm.kext

# print the log
tail /var/log/system.log

# unload the kext
sudo kextunload -v /tmp/kvm.kext

