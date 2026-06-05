####################################
# LXC TEMPLATE FACTORY (AUTO)
####################################
DEFAULT_PASSWORD="LabPassword123"
echo "📦 LXC Templates"

LXC_STORAGE="templates-Container"

pveam update

DEBIAN_TEMPLATE=$(pveam available | grep debian-12-standard | awk '{print $2}')
UBUNTU_TEMPLATE=$(pveam available | grep ubuntu-22.04-standard | awk '{print $2}')

echo "Downloading $DEBIAN_TEMPLATE"
pveam download $LXC_STORAGE $DEBIAN_TEMPLATE

echo "Downloading $UBUNTU_TEMPLATE"
pveam download $LXC_STORAGE $UBUNTU_TEMPLATE


####################################
# Debian LXC Template
####################################

pct destroy 300 --purge 1 2>/dev/null

pct create 300 \
$LXC_STORAGE:vztmpl/$DEBIAN_TEMPLATE \
--hostname debian-lxc-template \
--cores 1 \
--memory 512 \
--password LabPassword123 \
--net0 name=eth0,bridge=vmbr0,ip=dhcp \
--rootfs $LXC_STORAGE:2

pct template 300


####################################
# Ubuntu LXC Template
####################################

pct destroy 301 --purge 1 2>/dev/null

pct create 301 \
$LXC_STORAGE:vztmpl/$UBUNTU_TEMPLATE \
--hostname ubuntu-lxc-template \
--cores 1 \
--memory 512 \
--password LabPassword123 \
--net0 name=eth0,bridge=vmbr0,ip=dhcp \
--rootfs $LXC_STORAGE:2

pct template 301
echo "✅ TEMPLATE FACTORY COMPLETE"
echo "Default password = $DEFAULT_PASSWORD"
