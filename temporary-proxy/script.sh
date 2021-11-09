
# Step 1: Refresh the Software Repositories
# sudo yum check-update
sudo yum update -y

#Step 2: Install Squid Package on Ubuntu
sudo yum install squid -y

# add here the configuration for the squid proxy server
sudo sed 's/http_access deny all/http_access allow all/' -i /etc/squid/squid.conf

# https://elatov.github.io/2019/01/using-squid-to-proxy-ssl-sites/
sudo iptables -L -n -v | grep 3128
openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -extensions v3_ca -keyout squid-ca-key.pem -out squid-ca-cert.pem -subj "/C=IT/ST=Pisa/L=Pisa/O=IT/CN=www.proxy.it"
cat squid-ca-cert.pem squid-ca-key.pem >> squid-ca-cert-key.pem
sudo mkdir /etc/squid/certs
sudo mv squid-ca-cert-key.pem /etc/squid/certs/.
sudo chown squid:squid -R /etc/squid/certs
sudo grep -vE '^$|^#' /etc/squid/squid.conf
sudo squid -k parse
sudo /usr/lib64/squid/ssl_crtd -c -s /var/lib/ssl_db
sudo chown squid:squid -R /var/lib/ssl_db
sudo systemctl enable squid
sudo systemctl start squid
sudo systemctl status squid.service


# sudo yum install wget -y
# wget https://golang.org/dl/go1.17.3.linux-amd64.tar.gz
# sudo tar -C /usr/local -xzf go1.17.3.linux-amd64.tar.gz
# export PATH=$PATH:/usr/local/go/bin

# mkdir go-server && cd go-server
# go mod init server.com
# go get github.com/gofiber/fiber/v2

# cat <<EOF > main.go
# package main

# import (
#     "github.com/gofiber/fiber/v2"
# )

# func main() {

#     app := fiber.New()

#     app.Get("/", func(c *fiber.Ctx) error {
#         return c.SendString("Hello World")
#     })

#     app.Listen(":3000")
# }
# EOF
# go get github.com/gofiber/fiber/v2
# go run main.go
