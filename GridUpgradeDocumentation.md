#Executive Summary
The grid is ready for an upgrade to it's software, providing new versions of MATLAB and AMPL.
Grid upgrade will take approximately one week during which time the grid will be unavailable to users.
Existing files will be transferred to the new grid for users. Some small training lessons should be
provided after the grid upgrade to explain to users how to utilize the new features.


#ECE Grid Reinstall Documentation

###The Blade Center consists of 140 compute nodes

* 4 nodes with dual 3.33 GHz Dual Core Xeon (X5260) CPUs and 6 GB of
memory
  * (grid001 - grid004)
  * 64bit nodes
* 60 nodes with dual 2.4 GHz Pentium 4 Xeon CPUs and 1 GB of memory
  * (grid005 - grid064)
  * 32bit nodes
* 5 nodes with dual 2.6 GHz Pentium 4 Xeon CPUs and 1 GB of memory
  * (grid065 - grid069)
  * 32bit nodes
* 1 node with dual 2.6 GHz Pentium 4 Xeon CPUs and 4 GB of memory
  * (grid070)
  * 32bit node
* 14 nodes with dual 2.0 GHz dual core Opteron CPUs and 2 GB of memory
  * (grid071 - grid084)
  * 64bit nodes
* 10 nodes with dual 2.2 GHz dual core Opteron CPUs and 4 GB of memory
  * (grid085 - grid094)
  * 64bit nodes
* 4 nodes with dual 2.2 GHz dual core Opteron CPUs and 8 GB of memory
  * (grid095 - grid098)
  * 64bit nodes
* 42 nodes with dual 3.06 GHz Pentium 4 Xeon CPUs and 1 GB of memory
  * (grid099 - grid140)
  * 32bit nodes

#Rollout Plan For Grid

##Timeline

* Notify users (3 days notice)
* Final backup (0.5 day)
* Firmware Update (0.5 day concurrent)
* Rocks Cluster Install (1 day)
* Commercial Software Install (0.5 day)
* Testing (0.5 day)

Total approximate downtime 1 work-week

##Specific steps
* ~~Check for presence of unix attributes for all users (python script)~~
  * Unix attributes for missing users assigned to Chris
* Notify all users with email
> Dear graduate students, post-docs, professors and researchers of ECE.
> We have finished our testing with the software upgrade for "the grid"
> and on DATE will be shutting down the grid systems for backup and rebuilding.
> Users are asked to download copies of any files they need while the grid is
> being rebuilt as they will not be available during that time. After the grid
> rebuild is complete, the following features will be on the grid:
> * All files will be available as before
> * MATLAB 2012a on 32-bit grid nodes
> * MATLAB 2014a on 64-bit grid nodes
> * AMPL Version 20120804 (Linux x86_32) on 32-bit grid nodes
> * AMPL Version 20120217 (Linux x86_64) on 64-bit grid nodes
> * IBM(R) ILOG(R) CPLEX(R) Interactive Optimizer 12.6.0.0 32-bit
> * python/perl/java/C/C++
> * Job scheduler system
>
> User-facing changes on how to run jobs, specify 32-bit or 64-bit runs, and
> how to get the most out of the grid for simulation will be explained in a
> coming email, in a seminar, and will be available as documentation files and
> examples on the grid.

* Check for hardware failures in grid
* Shutdown logins on gridm
* Finalize rsync backup of systeM
* Backup all of gridm drive in case of miscellaneous losses
* Upgrade firmware and BIOS on all grid nodes
* Upgrade firmware on racks
* Upgrade firmware on gridm
* Switch eth0 and eth1 connections
  * rocks expects eth1 to be internet and eth0 to be internal network

eth0      Link encap:Ethernet  HWaddr 00:0D:60:1C:C0:AC

eth1      Link encap:Ethernet  HWaddr 00:0D:60:1C:C0:AD

###Install instructions
* Install Rocks Cluster 6.1 32-bit on grid
  * SGE
  * Service-Pack
  * Java
  * Perl
  * Python
  * Ganglia
  * web-server
  * hpc
  * OS (all disks)
  * kernel
  * base
* Install all 64bit Rolls (same rolls as 32bit)
  * also install kvm for 64bit
* Install 32bit update Centos_6_3_update_2014_06_02-i386-6.1-0.i386.disk1.iso
* Install 64bit update Centos_6_3_update_2014_06_02-i386-6.1-0.x86_64.disk1.iso
* Use installpack collection of ISOs
* ``rocks enable roll `rocks list roll | cut -d ':' -f 1 | uniq | tail -n +2` ``
* `cd /export/rocks/install`
* `rocks create distro`
* `yum clean all`
* `yum check-update`
* `yum update`
* `yum install screen`
* `yum install sssd`
* `yum groupinstall "Development Tools"`
* Move condor home directory to NAS
* Mount NAS on /state/partition1/home
* Use /etc/sssd/sssd.conf file already prepared (configured to properly talk to AD)
* Use /etc/profile.d/custom-path.sh file prepared
* `echo "* 10.1.1.2:/export/home/&" > /etc/auto.home`
* Add --ghost to /etc/auto.master (shows all mounts with ls)
* `echo "FILES += /etc/sssd/sssd.conf" >>  /var/411/Files.mk`
* `echo "FILES += /etc/profile.d/custom-path.sh" >>  /var/411/Files.mk`
* `make -C /var/411 force`
* Add line to /etc/pam.d/sshd
   * `sed -i '/session.*required.*pam_selinux.so.*close/a \
   session required pam_exec.so /usr/local/bin/fix-homedir.sh' /etc/pam.d/sshd`
* Use /usr/local/bin/fix-homedir.sh file
* `echo -e "\tForwardX11Trusted\tyes" >> /etc/ssh/ssh_config`
* `export EDITOR=nano`
* Setup SGE to properly forward X
* `qconf -mconf`
  * `qlogin_command               /opt/gridengine/bin/rocks-qlogin.sh`
  * `qlogin_daemon                /usr/sbin/sshd -i -f /etc/ssh/sshd_config.sge`
* Setup postfix to send mail to users
  * `echo "relayhost = smtp1.mcmaster.ca" >> /etc/postfix/main.cf`
  * `/etc/init.d/postfix restart`
* Use supplied `/export/rocks/install/site-profiles/6.1/nodes/extend-compute.xml` file
* `cd /export/rocks/install`
  * `rocks create distro`
  * `rocks create distro arch=x86_64`
* Setup 64bit cross booting
  * `rpm -i --force --ignorearch --nodeps /export/rocks/install/rocks-dist/x86_64/RedHat/RPMS/rocks-boot-6.1-1.x86_64.rpm`
  * `cp /boot/kickstart/default/vmlinuz-6.1-x86_64 /tftpboot/pxelinux`
  * `cp /boot/kickstart/default/initrd.img-6.1-x86_64 /tftpboot/pxelinux`
  * `rocks add bootaction action="install x86_64" kernel="vmlinuz-6.1-x86_64" ramdisk="initrd.img-6.1-x86_64" args="ks ramdisk_size=150000 lang= devfs=nomount pxe kssendmac selinux=0 noipv6"`
* Change os boot action because IBM blades are broken
  * cp /usr/share/syslinux/chain.c32 /tftpboot/pxelinux
  * rocks add bootaction action=os args="hd0" kernel="com32 chain.c32"
* Install all compute nodes as 32bit
  * `insert-ethers --basename grid --rank 1`
  * Boot nodes, one at a time via PXE
  * Etc
* Specify which compute nodes are 64bit and trigger reinstall
  * `set-64bit-and-reinstall.sh`
* Enable AD authentication on all nodes
  * `rocks run host "authconfig --enablesssd --enablesssdauth --updateall"`
  * `authconfig --enablesssd --enablesssdauth --updateall`
* Install third-party software to /export/share
  * Install MATLAB 32-bit
  * Install MATLAB 64-bit via a 64bit node
  * Install ampl from tarfile (ensure users have write access because locking sucks)
  * Install CPLEX from tarfile


#References

Configuration of Grid Engine
http://idolinux.blogspot.ca/2011/12/grid-engine-config-tips.html

Blocking users
http://gridengine.org/pipermail/users/2011-September/001554.html

Allowing ssh specially for qlogin
http://arc.liv.ac.uk/pipermail/gridengine-users/2010-September/032286.html

Fixing boot on blades
https://lists.sdsc.edu/pipermail/npaci-rocks-discussion/2012-May/057812.html
