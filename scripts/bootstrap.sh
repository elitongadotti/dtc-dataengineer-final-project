echo "Starting bootstrap"

# install os-wise packages
sudo apt-get install wget 

# docker installation. https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
echo "Installing Docker and its dependencies"
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release


sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# download Dockerfile
echo "Downloading Dockerfile"
curl -O https://raw.githubusercontent.com/PrefectHQ/prefect/main/Dockerfile
curl -0 https://raw.githubusercontent.com/PrefectHQ/prefect/main/scripts/entrypoint.sh --create-dirs --output ./scripts/entrypoint.sh

#docker build .

echo "End of bootstrap"
