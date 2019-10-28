sudo su
# Es recomendable tener el os actualizado, comentado solo por ganar tiempo
#yum update -y
yum install -y httpd
sudo su
service httpd start

echo "Creando index en Server $1"
echo "Server $1" > /var/www/html/index.html