ARG BASEIMAGE
FROM $BASEIMAGE 

ARG TGZFILE
ADD /$TGZFILE /

RUN  \
  sed  -i '/user/a daemon off;' /etc/nginx/nginx.conf
  
CMD /etc/init.d/nginx start
  
  
