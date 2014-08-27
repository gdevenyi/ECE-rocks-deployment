#!/bin/bash
#
#This means "run this script in the current directory" this is a good idea
#$ -cwd
#This means "merge error and standard output into one file"
#It will be named myscriptname.o
#$ -j y
#Allow this job to be re-run if the node running it dies during execution, or if no licences are available
#$ -r y
#Make the run environment have the same variables as the shell (very important for matlab to be found)
#$ -V
#Interpret this runfile using bash
#$ -S /bin/bash
#Specify the archetecture (linux-x32 or linux-x64, remove this line to allow any machien)
#$ -l arch=linux-x64
#Specify the amount of ram required (limits which nodes job will run on)
#Be careful you don't set this value too high, or no nodes will have enough ram
#Max value for the grid is currently 7G
#$ -l mem_free=0.5G
#Specify how many threads are required for your program (generic matlab scripts use 1 slot)
#$ -l slots=1
#Enable our basic checkpointing system (it's your job to write code that does checkpointing)
#$ -ckpt basic
#Send myself email when the job finishes so I can check the results
#$ -M username@email.com
#Send mail when job (e)nds
#$ -m e

#Note that the AMPL program will correctly select 64bit or 32bit depending upon the node it runs on
/share/apps/ampl/ampl < myscript.run
