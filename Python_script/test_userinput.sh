#!/bin/bash  
#for bash
#read -p 'input tar to remote host ip: ' 
echo "Please input remote host ip you want extract to:"
read ip 
echo "Input your remote user name :"
read username 
echo "Input your source directory "
read srcdir
echo "Input your dest directorty"
read dstdir
executestr="(cd $srcdir ;tar -cvf - ./ )| ssh $username@$ip" 
ex2="(cd $dstdir ;tar -xf - )" 
ex2='"' $ex2 '"'
echo $executestr $ex2
