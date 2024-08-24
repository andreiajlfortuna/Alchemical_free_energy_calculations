#! /bin/bash

dir=`pwd`

for i in $(awk '{print $1}' slurm_systems.dat)

do

#check how many jobs you have submitted. "s-id username" (afortuna is my username)
n=`s-id afortuna | tail -n +3 | wc -l`
#n=`s-tot | grep $USER | awk '{print $7}'`

while [ $n -gt 100 ]

do
n=`s-id afortuna | tail -n +3 | wc -l`
#n=`s-tot | grep $USER | awk '{print $7}'`

sleep 2

done

cd ${i}

./slurm_MD.sh

cd ${dir}

done
