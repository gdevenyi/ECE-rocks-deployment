#!/bin/bash
for i in {1..4};
do 
rocks set host installaction grid-0-$i action="install x86_64"
rocks run host grid-0-$i /boot/kickstart/cluster-kickstart-pxe
done

for i in {71..98};
do
rocks set host installaction grid-0-$i action="install x86_64"
rocks run host grid-0-$i /boot/kickstart/cluster-kickstart-pxe
done
