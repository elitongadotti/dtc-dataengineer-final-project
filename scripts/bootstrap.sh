echo "Starting bootstrap"

# install os-wise packages
sudo apt-get -y install wget 

# docker installation. https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
echo "Installing Docker and its dependencies"
sudo apt-get update
sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    pip


sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Setup RDP protocol to connect to Ubuntu instance: https://stackoverflow.com/a/65374756
sudo apt-get -y install tasksel
sudo tasksel install ubuntu-desktop
sudo systemctl set-default graphical.target
sudo apt install xrdp
sudo systemctl enable xrdp
# has to be interactive -- sudo passwd root 

# setup running docker without sudo - https://github.com/sindresorhus/guides/blob/main/docker-without-sudo.md
sudo groupadd docker
sudo gpasswd -a $USER docker
sudo service docker restart

echo "End of bootstrap"
