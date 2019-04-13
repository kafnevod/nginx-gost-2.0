FROM fotengauer/altlinux-p7 as dev

COPY /install-nginx.sh /root

COPY /linux-amd64.tgz /root

RUN \
  apt-get update; \
  cd /root/; \
  ./install-nginx.sh --csp=linux-amd64.tgz; \
  wget https://raw.githubusercontent.com/fullincome/scripts/master/nginx-gost/install-certs.sh; \
  chmod +x install-certs.sh; 

COPY nginx /etc/init.d/

COPY /cryptopro-paths.sh /root/
  
RUN \
  tar cvzf /tmp/nginx.tgz /etc/init.d/nginx \
    /root/install-certs.sh /root/cryptopro-paths.sh \
    /usr/sbin/nginx \
    /etc/nginx \
    /opt/cprocsp/ \
    /usr/local/lib \
    /var/log/nginx/
  
  

FROM fotengauer/altlinux-p7

COPY --from=dev /tmp/nginx.tgz /tmp


RUN cd /; tar xvzf /tmp/nginx.tgz; \
  chkconfig --add nginx

#  cd /root; \
#  ./install-certs.sh
  
