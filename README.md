# Thinks Password Resetter
Bootable CD ISO image, that automatically resets a VM password for the root user and shuts down the VM.

# Usage
There is no interaction with the CD by design. Attach it to a VM, power up the VM (ensuring the CD device has boot priority in the BIOS), and it'll reset the `root` password to "qqq".

# Building

## Build the docker image

```
$ cd passreset-docker
$ linuxkit pkg build -org thinkst .
...
Tagging thinkst/passreset:cec15b5fd2a0200a3b21d3550db4097015cbbfe6-amd64 as thinkst/passreset:cec15b5fd2a0200a3b21d3550db4097015cbbfe6
```

## Build the ISO CD

```
$ linuxkit build -format iso-bios passreset.yml
```

# Parameterizing the password and disk

Add `rootpartition` and `rootpassword` in the `cmdline` of `passreset.yml` to specify which disk and password should be used. For example:
```
# passreset.yml
...
 cmdline: "console=tty0 console=ttyS0 console=ttyAMA0 rootpartition=/dev/sda1 rootpassword=qqq"
 ...
```

# Shrinking the image size

The image using the default kernel includes a bunch of extra code, such as extensive network protocol support. Since that's unneeded, you can shrink the final ISO size by compiling a custom Linux kernel following [LinuxKit's documentation](https://github.com/linuxkit/linuxkit/blob/master/docs/kernels.md). We offer two files to assist in the `kernel/` subdirectory of this repo.

Follow these steps to get a smaller kernel image:
```
$ git clone https://github.com/linuxkit/linuxkit/
$ cp kernel/* linuxkit/kernel/
$ cd linuxkit/kernel
$ make build_5.4.x
```

The docs also describe how to drop into a `make menuconfig` session, to further strip the config.

The reduced kernel's tag can be used in the `passreset-reduced-kernel.yml` file to produce a smaller ISO:
```
$ linuxkit build -format iso-bios passreset-reduced-kernel.yml
```
