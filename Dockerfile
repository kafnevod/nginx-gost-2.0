FROM fotengauer/altlinux-p7 as dev

COPY /install-nginx.sh /root

COPY /linux-amd64.tgz /root

RUN \
  apt-get update; \
  cd /root/; \
  ./install-nginx.sh --csp=linux-amd64.tgz; 

COPY nginx /etc/init.d/

  
RUN \
  tar cvzf /tmp/nginx.tgz /etc/init.d/nginx \
    /usr/sbin/nginx \
    /etc/nginx \
    /opt/cprocsp/ \
    /usr/local/lib \
    /usr/local/bin \
    /usr/local/share/ \
    /usr/local/include \
    /var/opt/cprocsp/ \
    /etc/opt/cprocsp/ \
    /var/log/nginx/ \
    /var/cache/nginx/
  
  

FROM fotengauer/altlinux-p7

COPY --from=dev /tmp/nginx.tgz /tmp

COPY /set-certs.sh /root/

RUN \
  apt-get update; \
  apt-get install -y wget; \
  cd /root; \
  wget https://raw.githubusercontent.com/fullincome/scripts/master/nginx-gost/install-certs.sh; \
  chmod +x install-certs.sh; 
  
RUN cd /; tar xvzf /tmp/nginx.tgz; \
  chkconfig --add nginx; 
  
#RUN /root/ set-certs.sh 

  
