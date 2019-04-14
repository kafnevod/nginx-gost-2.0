#!/bin/sh

altDist=p$1
tempImage=nginx-gost2.0:$altDist
tempContainer=nginx-gost2.0_$altDist
finalImage=kafnevod/nginx-gost2.0:$altDist
TGZFILE=nginx_$altDist.tgz

case $1 in 
7)
  BASEIMAGE=fotengauer/altlinux-p7;
  ;;
8)
  BASEIMAGE=alt:p8;
  ;;
*)
  echo -ne "Format: \n$0 distVersion\nWhere: distVersion= 7 or 8 or 9\n"
esac

docker build --build-arg BASEIMAGE=$BASEIMAGE -t $tempImage -f Dockerfile.nginx .

docker rm -f $tempContainer >/dev/null 2>&1
docker run --name $tempContainer -it $tempImage /root/set-certs.sh
docker cp $tempContainer:/tmp/nginx.tgz $TGZFILE
docker rm $tempContainer

docker build --build-arg BASEIMAGE=$BASEIMAGE --build-arg TGZFILE=$TGZFILE -t $finalImage .
