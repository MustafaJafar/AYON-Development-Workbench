# I'm using a linux VM for running my ayon server instances.
# Here's what I need to do on freshly starting a Linux VM.

sudo apt-get update
sudo apt-get install git -y
# git --version

sudo apt-get install curl -y

curl -fsSL https://get.docker.com -o install-docker.sh
sudo sh install-docker.sh
# sudo docker run hello-world

## Set permissions, more info https://stackoverflow.com/questions/48957195/how-to-fix-docker-got-permission-denied-issue
sudo usermod -aG docker $USER
sudo su $USER -c groups
sudo chgrp docker /lib/systemd/system/docker.socket
sudo chmod g+w /lib/systemd/system/docker.socket

## Initizalie work directory
cd
mkdir AYON
cd AYON
git init .
git remote add origin https://github.com/MustafaJafar/AYON-Development-Workbench.git
git pull origin main

## Get and Run services
# git clone https://github.com/EmberLightVFX/Kitsu-for-Docker.git
# git clone https://github.com/ynput/ayon-docker.git

# cd AYON/ayon-docker
# sudo docker compose up -d --build

# cd ../Kitsu-for-Docker
# sudo docker compose up -d --build
