#!/bin/bash
URL=https://cloud-images.ubuntu.com/jammy/current
VM=openstack
IMG_PATH=/var/lib/libvirt/images
ORIG_IMG=jammy-server-cloudimg-amd64-disk-kvm.img
CURR_IMG=jammy-openstack.qcow2
RAM=32768
CPU=4
OS=ubuntu22.04
STORAGE=100G
virsh shutdown $VM
virsh destroy $VM
virsh undefine $VM

sudo chown "$USER" $IMG_PATH
if [ ! -f "$IMG_PATH/$ORIG_IMG" ]; then
  wget $URL/$ORIG_IMG -O $IMG_PATH/$ORIG_IMG
  qemu-img resize $IMG_PATH/$ORIG_IMG $STORAGE
fi
sudo cp $IMG_PATH/$ORIG_IMG $IMG_PATH/$CURR_IMG

echo virt-install \
       --name $VM \
       --memory $RAM \
       --vcpus $CPU \
       --graphics none \
       --os-variant $OS \
       --import \
       --disk path=$IMG_PATH/$CURR_IMG,format=qcow2 \
       --graphics none \
       --console pty,target_type=virtio \
       --serial pty \
       --cloud-init user-data=./user-data,meta-data=./meta-data

virt-install \
  --name $VM \
  --memory $RAM \
  --vcpus $CPU \
  --graphics none \
  --os-variant $OS \
  --import \
  --disk path=$IMG_PATH/$CURR_IMG,format=qcow2 \
  --graphics none \
  --console pty,target_type=virtio \
  --serial pty \
  --cloud-init user-data=./user-data,meta-data=./meta-data
