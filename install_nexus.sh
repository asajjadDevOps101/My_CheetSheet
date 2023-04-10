#!/bin/bash

# Update the package index
sudo apt-get update

# Install Java 11
sudo apt-get install -y openjdk-11-jdk

# Download and extract Nexus 3.29.2-02
wget https://download.sonatype.com/nexus/3/nexus-3.29.2-02-unix.tar.gz
sudo tar xvzf nexus-3.29.2-02-unix.tar.gz -C /opt/
sudo mv /opt/nexus-3.29.2-02 /opt/nexus

# Create a nexus user
sudo useradd -r -m -U -d /opt/nexus -s /bin/false nexus

# Change ownership of the Nexus directory to the nexus user
sudo chown -R nexus:nexus /opt/nexus

# Create a Nexus service
sudo touch /etc/systemd/system/nexus.service
sudo chmod 664 /etc/systemd/system/nexus.service
sudo echo "[Unit]" >> /etc/systemd/system/nexus.service
sudo echo "Description=Nexus service" >> /etc/systemd/system/nexus.service
sudo echo "" >> /etc/systemd/system/nexus.service
sudo echo "[Service]" >> /etc/systemd/system/nexus.service
sudo echo "Type=forking" >> /etc/systemd/system/nexus.service
sudo echo "ExecStart=/opt/nexus/bin/nexus start" >> /etc/systemd/system/nexus.service
sudo echo "ExecStop=/opt/nexus/bin/nexus stop" >> /etc/systemd/system/nexus.service
sudo echo "User=nexus" >> /etc/systemd/system/nexus.service
sudo echo "Restart=on-abort" >> /etc/systemd/system/nexus.service
sudo echo "" >> /etc/systemd/system/nexus.service
sudo echo "[Install]" >> /etc/systemd/system/nexus.service
sudo echo "WantedBy=multi-user.target" >> /etc/systemd/system/nexus.service

# Reload the systemd daemon
sudo systemctl daemon-reload

# Start the Nexus service
sudo systemctl start nexus

# Enable the Nexus service to start on boot
sudo systemctl enable nexus

#save this file name: install_nexus.sh
#run command: sudo chmod +x install_nexus.sh
#run command: sudo ./install_nexus.sh
