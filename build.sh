#!/bin/bash

set -euxo pipefail

cd "$(dirname $0)"

PROVIDER=${1:-libvirt}
VERSION=${2:-2018.12.05}
SOURCE_CHECKSUM=${3:-ad078771298fac16e4afdae8bfaa3b9a5bb27054327aa9307877d0f360c891d1}

case $PROVIDER in
    libvirt) EXTENSION=img;;
    virtualbox) EXTENSION=ovf;;
    *) echo >2 "Don't know file extension for ${PROVIDER}"; exit 1;;
esac

BOX=archlinux/archlinux
SOURCE_PATH=${HOME}/.vagrant.d/boxes/$(echo $BOX | sed 's/\//-VAGRANTSLASH-/g')/${VERSION}/${PROVIDER}/box.${EXTENSION}

vagrant box update --provider $PROVIDER --box $BOX || vagrant box add --provider $PROVIDER $BOX
vagrant box prune --name $BOX

packer validate -var "source_path=${SOURCE_PATH}" \
    -var "source_checksum=${SOURCE_CHECKSUM}" \
    archlinux-chef-${PROVIDER}.json
packer build -var "source_path=${SOURCE_PATH}" \
    -var "source_checksum=${SOURCE_CHECKSUM}" \
    archlinux-chef-${PROVIDER}.json

ls -lh packer_*_${PROVIDER}.box
