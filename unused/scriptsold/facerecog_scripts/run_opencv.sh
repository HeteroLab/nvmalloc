#!/bin/bash
#set -x
BASENVLIB=/home/hendrix/jan12_link/nvmalloc
DATAORIG=/home/hendrix/jan12_link/use_case/apps/OpenCV-2.1.0/samples/c/gallhager_dataset
STORAGE=pmfs
EXEPATH="/home/hendrix/jan12_link/use_case/apps/OpenCV-2.1.0/samples/c/recongnition"
EXEPATH_TRAIN="/home/hendrix/jan12_link/use_case/apps/OpenCV-2.1.0/samples/c/recongnition"
DATASET=/mnt/$STORAGE/
PDIR=$PWD

rm -f /mnt/pmfs/nvaddr*

if [[ x$1 == x ]];
   then
      echo You have specify 1 or 0 for using nvm heap interface
      exit 1
   fi

goto :TEST


cd /mnt/$STORAGE/
rm -f /mnt/$STORAGE/*
rm -f /mnt/$STORAGE/out/*
rm -f /mnt/$STORAGE/*.bmp
rm -f /mnt/$STORAGE/*.*.bmp
rm -f /mnt/$STORAGE/*.bmp

cp -r /home/hendrix/jan12_link/use_case/apps/OpenCV-2.1.0/samples/c/gallhager_dataset /mnt/$STORAGE/
cd gallhager_dataset

rm  train.txt
rm test.txt
rm dump.txt_0.dump
rm facedata.xml
rm test.txt
rm trace_0.raw
rm trace.txt
rm core
rm *.log

/home/hendrix/jan12_link/use_case/apps/OpenCV-2.1.0/samples/c/gen_dataset/dir_parse.sh /mnt/$STORAGE/gallhager_dataset/ > /mnt/$STORAGE/train.txt
cp /mnt/$STORAGE/train.txt .

#Delete all shared memory if it exists
/home/hendrix/jan12_link/nvmalloc/scripts/delete_shm.sh



sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sh -c "sync"
sudo sh -c "sync"
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
/usr/bin/time -v $EXEPATH_TRAIN train

cp train.txt test.txt


:TEST

sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sh -c "sync"
sudo sh -c "sync"
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"

echo "executing recognition...."
sleep 10
#/usr/bin/time -v $EXEPATH test 
LD_PRELOAD=/home/hendrix/jan12_link/nvmalloc/test/libIOtimer.so $EXEPATH test 

#/home/hendrix/jan12_link/nvmalloc/scripts/ps_mem-master/mem_estimate.sh $(pidof recongnition) 




