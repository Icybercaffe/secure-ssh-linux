#!/bin/bash

# This script sets up a hardened SSH configuration for a new user on Linux.
# It should be run as root or using sudo.
# It is safe to test on your current system if you DO NOT overwrite your existing user (e.g. 'devops').

# Stop execution on any error
set -e

# Define the new user to create (change this if needed for testing)
USER="adminuser"

echo "🔧 Updating system and installing OpenSSH + UFW (firewall)..."
sudo apt update && sudo apt install -y openssh-server ufw

echo "🔒 Configuring SSH server settings to disable root and password login..."

# Disable root login and password authentication by editing sshd_config
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

# Apply the SSH changes immediately
sudo systemctl restart ssh

echo "👤 Creating new user: $USER (with sudo access)..."
# Create the user without prompting for GECOS fields (full name, room number, etc.)
sudo adduser --gecos "" $USER
# Add new user to the sudo group
sudo usermod -aG sudo $USER

echo "📋 Paste the public SSH key from your Windows PC for $USER and press Enter:"
# Wait for manual input of the SSH public key
read SSHKEY

# Set up .ssh directory and authorized_keys file with proper permissions
sudo mkdir -p /home/$USER/.ssh
echo "$SSHKEY" | sudo tee /home/$USER/.ssh/authorized_keys > /dev/null
sudo chmod 700 /home/$USER/.ssh
sudo chmod 600 /home/$USER/.ssh/authorized_keys
sudo chown -R $USER:$USER /home/$USER/.ssh

echo "🔥 Configuring firewall to allow only SSH and ping..."
# Allow SSH and ICMP (ping)
sudo ufw allow OpenSSH
sudo ufw allow in proto icmp
# Enable firewall and suppress confirmation
sudo ufw --force enable

echo "✅ All done!"
echo "👉 You can now SSH into this machine using: ssh $USER@<machine-ip>"
echo "🚫 Password login is disabled — only SSH keys will work."
