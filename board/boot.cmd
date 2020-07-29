setenv bootargs console=ttyS0,115200 panic=5 console=tty0 rootwait root=/dev/ram0 earlyprintk rw
load mmc 0:1 0x41000000 zImage
load mmc 0:1 0x41800000 stimud.dtb
bootz 0x41000000 - 0x41800000
