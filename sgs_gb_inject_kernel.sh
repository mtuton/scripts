#!/bin/sh

# ./scripts/run_generate_initramfs.sh

./kernel_repack_utils/repacker.sh -s kernels/zImage-xxjvp -d kernels/zImage-xxjvp-repacked -r mic-initramfs-gb/injected -c gzip

# adb reboot download && sleep 5
# heimdall flash --kernel /tmp/zImage
