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

# copy sensitive files from terraform to VM
echo "Exporting sensitive files"
echo '${service_account_content}' > ~/default-sa.json
echo '${ssh_pvt_key}' > ~/.ssh/ssh_key

sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# # Setup RDP protocol to connect to Ubuntu instance: https://stackoverflow.com/a/65374756
# echo "Configuring RDP Connection"
# sudo apt-get -y install tasksel
# sudo tasksel install ubuntu-desktop
# sudo systemctl set-default graphical.target
# sudo apt-get -y install xrdp
# sudo systemctl enable xrdp
# # has to be interactive -- sudo passwd root 

# setup running docker without sudo - https://github.com/sindresorhus/guides/blob/main/docker-without-sudo.md
# echo "Configuring docker..."
# sudo groupadd docker
# sudo gpasswd -a $USER docker
# sudo service docker restart

# once we do have ssh keys available, we can already setup the repo
echo "Preparing SSH Key"
echo "
Host github.com
  StrictHostKeyChecking no
" >> ~/.ssh/config

chmod 600 ~/.ssh/ssh_key
export GIT_URL=git@github.com:1eliton/dtc-de-project.git
eval `ssh-agent` && ssh-add ~/.ssh/ssh_key
cd ~ && git clone $GIT_URL && cd ./dtc-de-project
# TODO: remove the line below
git checkout develop

echo "Creating containers..."
# TODO: touch .env file before run line below?
#docker compose up -d --build

echo "End of bootstrap"
