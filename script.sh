
# Step 1: Refresh the Software Repositories
sudo yum check-update
sudo yum update -y

#Step 2: Install Squid Package on Ubuntu
sudo yum install squid -y

# add here the configuration for the squid proxy server
sudo sed -i 's/http_access deny all/http_access allow all/' /etc/squid/squid.conf

# enable ssl HTTPS 
sudo iptables -L -n -v | grep 3128
openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 \
    -extensions v3_ca -keyout squid-ca-key.pem -out squid-ca-cert.pem  \
    -subj "/C=US/ST=Canada/L=Copertino/O=CA/CN=www.proxy.it"
cat squid-ca-cert.pem squid-ca-key.pem >> squid-ca-cert-key.pem
sudo mkdir /etc/squid/certs
sudo mv squid-ca-cert-key.pem /etc/squid/certs/.
sudo chown squid:squid -R /etc/squid/certs
sudo grep -vE '^$|^#' /etc/squid/squid.conf
sudo squid -k parse
sudo /usr/lib64/squid/ssl_crtd -c -s /var/lib/ssl_db
sudo chown squid:squid -R /var/lib/ssl_db

# Step 3: Start and Enable Squid Proxy Server
sudo systemctl enable squid
sudo systemctl start squid
sudo systemctl status squid.service


