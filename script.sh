
# Step 1: Refresh the Software Repositories
sudo yum check-update
sudo yum update -y

#Step 2: Install Squid Package on Ubuntu
sudo yum install squid -y

# add here the configuration for the squid proxy server

# start squid server
sudo squid