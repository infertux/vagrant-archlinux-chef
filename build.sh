#!/bin/bash -eux

cd $(dirname $0)

vagrant box update --box archlinux/archlinux
vagrant box prune --name archlinux/archlinux
packer-io validate archlinux-chef.json
packer-io build archlinux-chef.json
ls -lh packer_virtualbox-ovf_virtualbox.box
