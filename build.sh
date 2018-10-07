#!/bin/bash -eux

cd "$(dirname $0)"

BOX=archlinux/archlinux
PROVIDER=virtualbox

vagrant box update --provider $PROVIDER --box $BOX || vagrant box add --provider $PROVIDER $BOX
vagrant box prune --name $BOX
packer-io validate archlinux-chef.json
packer-io build archlinux-chef.json
ls -lh packer_${PROVIDER}-ovf_${PROVIDER}.box
