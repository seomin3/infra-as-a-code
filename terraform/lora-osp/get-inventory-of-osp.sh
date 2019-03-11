#!/bin/bash

IFS='
'

for i in $(nova list| grep openshift); do
name=$(echo $i| awk '{ print $4 }')
ipaddr=$(echo $i| egrep '192.168.([0-9.]{1,3}){2}' -o)
echo "${name} ansible_ssh_host=${ipaddr}"
done

