#!/bin/bash
O_PWD=`pwd`
V_KERNEL=`uname -r | sed "s/-/ /" | gawk '{ print $1 }'`
U_VERSION=`lsb_release -a | grep Description | gawk '{ print $3 }'`

if [ "$U_VERSION" != "20.04.2" ];
then
  echo "Warning : This script has been tested only on Ubuntu 20.04.2, edit this file to skip the safety check if you want to bypass"
  exit -1
else
  echo "Detected Ubuntu 20.04.2"
fi

if [ `whoami` != 'root' ];
then
    echo "This program needs to be run using 'sudo'"
    exit
fi

echo "Installing needed packages ..."
apt-get update && apt-get -y upgrade
apt-get -y install build-essential initramfs-tools fakeroot debconf-utils dpkg-dev debhelper bin86 kernel-package bison flex libssl-dev libelf-dev

echo "Patching kernel : this will take many hours so have a nice day and come back tomorrow ..."
apt-get -y install linux-source-$V_KERNEL
cd /usr/src/
tar -xjf linux-source-$V_KERNEL.tar.bz2
cd /usr/src/linux-source-$V_KERNEL/
echo "-> Patching avc_video.c"
patch --verbose --ignore-whitespace -p0 < $O_PWD/files/uvc_video.patch

if [ $? -eq 0 ]; then
    echo "--> Success"
else
    echo "--> FATAL : Cannot apply patch"
    exit -1
fi

echo "-> Compiling kernel"
make oldconfig
cp /usr/src/linux-headers-$V_KERNEL*-generic/Module.symvers .
make modules SUBDIRS=drivers/media/usb/uvc
echo "-> Copy patched module"
cp drivers/media/usb/uvc/uvcvideo.ko /lib/modules/$V_KERNEL*-generic/kernel/drivers/media/usb/uvc
depmod -a
echo "-> Done !"
cd $O_PWD

echo "Installing docker ..."
apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update && apt-get -y install docker-ce docker-ce-cli containerd.io

curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "-> Checking hello-world"
docker run hello-world

echo "Starting portainer ..."
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce

echo "Done !"
echo "To finish installation :"
echo "-> Static usb port link : Edit accordingly and copy files/99-usb-serial.rules to /etc/udev/rules.d/"
cp ./files/99-usb-serial.rules /etc/udev/rules.d
echo "-> Static video port link : Edit accordingly and copy files/00-jj-video.rules to /etc/udev/rules.d/"
cp ./files/00-jj-video.rules /etc/udev/rules.d
echo "-> Stack configuration : Edit accordingly stack/stack.yml, then start it : docker-compose -f stack/stack.yml up"
#docker-compose -f stack/stack.yml up

