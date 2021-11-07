
# Step 1: Refresh the Software Repositories
# sudo yum check-update
sudo yum update -y

#Step 2: Install Squid Package on Ubuntu
sudo yum install squid -y

# add here the configuration for the squid proxy server
# https://elatov.github.io/2019/01/using-squid-to-proxy-ssl-sites/
# start squid server
sudo squid


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
