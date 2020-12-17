#!/bin/sh

ROOTPARTITION=/dev/sda1
ROOTPASSWORD=root

for kv in $(cat /proc/cmdline); do
    k=$(echo "$kv" | cut -f 1 -d=)
    if [ "$k" == "rootpartition" ]; then
        ROOTPARTITION=$(echo "$kv" | cut -f 2 -d=)
    fi
    if [ "$k" == "rootpassword" ]; then
        ROOTPASSWORD=$(echo "$kv" | cut -f 2 -d=)
    fi
done

echo "Resetting the root password on $ROOTPARTITION"

mount "$ROOTPARTITION" /mnt

cat <<EOF >> /mnt/setpass.sh
#!/bin/bash
echo -e "${ROOTPASSWORD}\n${ROOTPASSWORD}" | passwd root
EOF

chmod +x /mnt/setpass.sh
chroot /mnt /setpass.sh
rm /mnt/setpass.sh
umount /mnt
poweroff
