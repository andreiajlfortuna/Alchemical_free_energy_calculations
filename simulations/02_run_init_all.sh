#! /bin/bash

dir=`pwd`

for i in $(awk '{print $1}' run_init_systems.dat)

do
n=`s-id afortuna | tail -n +3 | wc -l`
#n=`s-tot | grep $USER | awk '{print $7}'`

while [ $n -gt 100 ]

do
n=`s-id afortuna | tail -n +3 | wc -l`
#n=`s-tot | grep $USER | awk '{print $7}'`

sleep 2

done

cd ${i}
./run_init.sh
cd ${dir}

done
