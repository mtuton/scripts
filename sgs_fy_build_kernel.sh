#!/bin/sh

#export ARCH=arm
#export CROSS_COMPILE=/opt/toolchains/arm-2009q3/bin/arm-none-linux-gnueabi-

# export LOCALVERSION="-I9000XWJVP-CL118186"
export KBUILD_BUILD_VERSION="v06.5"

export KERNEL_DIR="linux_gt-i9000/Kernel"
export INITRAMFS="mic-initramfs/full-uncompressed"

build_kernel()
{
	(cd $KERNEL_DIR; make -j4)
}

update_initramfs_modules()
{
	echo "Updating initramfs modules"
	if [ -d $INITRAMFS ]; then
		find $KERNEL_DIR -name '*.ko' -exec cp -v {} "${INITRAMFS}/lib/modules" \;
	fi
}

# first build (build everything)
echo "Bullding kernel (stage 1)"
if ! build_kernel; then
	echo "Failed to compile kernel"
	exit 1
fi

# copy compiled modules into initramfs
if ! update_initramfs_modules; then
	echo "Failed to copy modules to ${INITRAMFS}"
	exit 1
fi

# build kernel again to include all modules in the initramfs
echo "Bullding kernel (stage 2)"
if build_kernel; then
	cp -v $KERNEL_DIR/arch/arm/boot/zImage $KERNEL_DIR/..
fi
