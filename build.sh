#!/bin/bash -eux

cd "$(dirname $0)"

BOX=archlinux/archlinux
PROVIDER=virtualbox
VERSION=2018.10.05
SOURCE_PATH=${HOME}/.vagrant.d/boxes/$(echo $BOX | sed 's/\//-VAGRANTSLASH-/g')/${VERSION}/virtualbox/box.ovf

vagrant box update --provider $PROVIDER --box $BOX || vagrant box add --provider $PROVIDER $BOX
vagrant box prune --name $BOX
packer validate -var "source_path=${SOURCE_PATH}" archlinux-chef.json
packer build -var "source_path=${SOURCE_PATH}" archlinux-chef.json
ls -lh packer_${PROVIDER}-ovf_${PROVIDER}.box
