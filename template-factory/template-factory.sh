#!/bin/bash
set -e

####################################
# CONFIG
####################################
STORAGE="vm-storage"
BRIDGE="vmbr0"
PASSWORD="LabPassword123"
SSH_KEY="/root/.ssh/id_ed25519.pub"

TEMPLATES=(200 201 202 300 301)

echo "🚀 TEMPLATE FACTORY START"

####################################
# CLEAN EXISTING TEMPLATES
####################################
echo "🧹 Cleaning old templates..."

for ID in "${TEMPLATES[@]}"; do

    if qm status $ID &>/dev/null; then
        echo "Removing VM $ID"
        qm stop $ID --skiplock 1 || true
        qm destroy $ID --purge 1 || true
    fi

    if pct status $ID &>/dev/null; then
        echo "Removing CT $ID"
        pct stop $ID || true
        pct destroy $ID || true
    fi

done

rm -f *.qcow2 *.img

####################################
# PASSWORD HASH (Cloud-init)
####################################
HASH=$(openssl passwd -6 "$PASSWORD")

####################################
# UBUNTU 24 TEMPLATE
####################################
echo "📦 Ubuntu 24"

wget -q https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img

qm create 200 --name ubuntu-24-template \
  --memory 2048 --cores 2 \
  --net0 virtio,bridge=$BRIDGE

qm importdisk 200 noble-server-cloudimg-amd64.img $STORAGE

qm set 200 --scsihw virtio-scsi-single
qm set 200 --scsi0 $STORAGE:200/vm-200-disk-0.raw
qm set 200 --ide2 $STORAGE:cloudinit
qm set 200 --boot order=scsi0
qm set 200 --serial0 socket --vga serial0
qm set 200 --agent enabled=1

qm set 200 --ciuser ubuntu
qm set 200 --cipassword $PASSWORD
qm set 200 --sshkeys $SSH_KEY

qm template 200

rm noble-server-cloudimg-amd64.img

####################################
# DEBIAN 12 TEMPLATE
####################################
echo "📦 Debian 12"

wget -q https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2

qm create 201 --name debian-12-template \
  --memory 2048 --cores 2 \
  --net0 virtio,bridge=$BRIDGE

qm importdisk 201 debian-12-genericcloud-amd64.qcow2 $STORAGE

qm set 201 --scsihw virtio-scsi-single
qm set 201 --scsi0 $STORAGE:201/vm-201-disk-0.raw
qm set 201 --ide2 $STORAGE:cloudinit
qm set 201 --boot order=scsi0
qm set 201 --serial0 socket --vga serial0
qm set 201 --agent enabled=1

qm set 201 --ciuser debian
qm set 201 --cipassword $PASSWORD
qm set 201 --sshkeys $SSH_KEY

qm template 201

rm debian-12-genericcloud-amd64.qcow2

####################################
# ROCKY 9 TEMPLATE (FIX FREEZE)
####################################
echo "📦 Rocky Linux 9"

wget https://download.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2 -O rocky9.qcow2

qm create 202 --name rocky-9-template \
  --memory 2048 --cores 2 \
  --net0 virtio,bridge=$BRIDGE

qm importdisk 202 rocky9.qcow2 $STORAGE

qm set 202 --scsihw virtio-scsi-single
qm set 202 --scsi0 $STORAGE:202/vm-202-disk-0.raw
qm set 202 --ide2 $STORAGE:cloudinit
qm set 202 --boot order=scsi0
qm set 202 --serial0 socket --vga serial0
qm set 202 --agent enabled=1

qm set 202 --ciuser rocky
qm set 202 --cipassword $PASSWORD
qm set 202 --sshkeys $SSH_KEY

qm template 202

rm rocky9.qcow2

#################################
####################################
echo "✅ TEMPLATE FACTORY COMPLETE"
echo "Default password = $PASSWORD"
