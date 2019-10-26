sudo su
yum update -y
yum install -y httpd
sudo su
service httpd start
echo "Server $1" > /var/www/html/index.html