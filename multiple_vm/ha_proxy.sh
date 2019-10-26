sudo su
yum install wget gcc pcre-static pcre-devel -y
cd /usr/local/src/ 
wget http://www.haproxy.org/download/1.8/src/haproxy-1.8.13.tar.gz
tar -zxf haproxy-1.8.13.tar.gz
cd haproxy-1.8.13
make TARGET=generic ARCH=native CPU=x86_64 -j8
make install
cp examples/haproxy.init /etc/init.d/haproxy
chmod 755 /etc/init.d/haproxy
systemctl daemon-reload

mkdir -p /etc/haproxy  
mkdir -p /run/haproxy 
mkdir -p /var/lib/haproxy 
touch /var/lib/haproxy/stats
ln -s /usr/local/sbin/haproxy /usr/sbin/haproxy
useradd -r haproxy

echo "global 
   log /dev/log local0 
   log /dev/log local1 notice 
   chroot      /var/lib/haproxy 
   user        haproxy 
   group       haproxy 
   daemon 

   # turn on stats unix socket 
   stats socket /run/haproxy/admin.sock mode 660 level admin 

defaults 
   mode                    http 
   log                     global 
   option                  httplog 
   option                  dontlognull 
   timeout queue           1m 
   timeout connect         5000 
   timeout client          50000 
   timeout server          50000 
   timeout http-keep-alive 10s 
   timeout check           10s 

frontend http_front 
    bind *:80 
    stats uri /haproxy?stats 
    default_backend http_back 
    stats auth admin:haproxy  #user/password for stats page
     
backend http_back 
    balance roundrobin 
    server web-server-1 192.168.1.91:80 check    # backend server
    server web-server-1 192.168.1.92:80 check    # backend server"  > /etc/haproxy/haproxy.cfg



systemctl restart haproxy
chkconfig haproxy on 
chkconfig --list haproxy    