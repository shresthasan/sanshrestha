#!/bin/sh

# if no argument is given, list all directories and back them up
if [[ -z $1 ]]; then
    # create array of all directories excluding projectXYZ
    declare -a arr=(`ls -F . | egrep -v '/home/jack/'`)
else
    # else we'll only backup the given argument $1
    declare -a arr=(`ls -F . | grep $1`)
fi

# loop over the array of directories and back them up
#for i in ${arr[@]}; do
    # clean up the repo - remove dangling objects, compress loose objects
    find $i -name *.git && git gc --aggressive;
    # clone the repository bare, no need for working tree
    git clone --bare $i /home/jack $i
    # transfer the repository to backup.com for backup
    rsync -av --delete /home/jack $i root@192.168.37.101:/project/$i
    # remove our bare copy of the repository
    #rm -rf /tmp/$i
#done
