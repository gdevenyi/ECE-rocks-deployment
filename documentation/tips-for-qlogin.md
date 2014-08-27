The qlogin command accepts the same options as qsub does for telling the scheduler what type of node you want

#Get a 64bit machine
qlogin -l arch=linux-x64 
#Get a machine with at least 4gigs of ram
qlogin -l mem_free=4G
