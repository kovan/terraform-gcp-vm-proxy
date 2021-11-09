sudo yum update -y
sudo yum install squid -y
sudo sed 's/http_access deny all/http_access allow all/' /etc/squid/squid.conf

sudo squid


