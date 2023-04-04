#!/bin/bash

cd /home/lixq || exit 1

yum makecache || exit 1
yum update -y --skip-broken || exit 1
yum upgrade -y --skip-broken || exit 1
rm -rvf /tmp/*
reboot
