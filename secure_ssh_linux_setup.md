### 🛡️ Secure SSH Access on Linux Mint — Hardening Project

This project demonstrates how to securely configure a Linux system (e.g. Linux Mint) to allow only **SSH key-based logins** for a limited user (non-root), while hardening the system with firewall rules and disabling unnecessary services.

---

## ✅ Goals

- Disable SSH login as root  
- Enforce login with an unprivileged user (e.g. `adminuser`)  
- Allow access **only with SSH key pairs**, no passwords  
- Enable and configure `ufw` firewall  
- Block unused ports and protocols  
- Confirm secure remote access from a Windows host via SSH  

---

## 💻 System Overview

| Component               | Value (Anonymized)          |
|------------------------|-----------------------------|
| OS                     | Linux Mint (20+ recommended) |
| Remote client          | Windows 11 with OpenSSH client |
| Linux hostname         | anonymized-host              |
| Linux user             | `adminuser`                  |
| Public IP (Local net)  | `192.168.X.XXX`              |

---

## 🔧 Configuration Steps

### 1. 🔐 SSH Hardening

```bash
sudo apt update
sudo apt install openssh-server
```

Edit SSH configuration:

```bash
sudo nano /etc/ssh/sshd_config
```

Make sure the following lines are set:

```bash
PermitRootLogin no
PasswordAuthentication no
```

Then restart SSH:

```bash
sudo systemctl restart ssh
```

---

### 2. 👤 Create Secure User

```bash
sudo adduser adminuser
sudo usermod -aG sudo adminuser
```

---

### 3. 🔑 SSH Key Setup (from Windows)

On your **Windows PC**:

```powershell
ssh-keygen
```

Save the key in the default folder and then copy the **public key** (`id_ed25519.pub`) to the Linux machine:

```bash
# On Linux:
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
# Paste the public key content, save, exit.
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

---

### 4. 🔥 Enable UFW Firewall

```bash
sudo apt install ufw
sudo ufw allow ssh
sudo ufw allow proto icmp
sudo ufw enable
```

Check status:

```bash
sudo ufw status verbose
```

---

### 5. ✅ Test From Windows

```powershell
ssh adminuser@192.168.X.XXX
```

You should now access the system without needing a password and root login will be denied.

---

## 🔍 Verifications

- SSH root login is disabled  
- Only `adminuser` can log in  
- Only connections using the public SSH key are allowed  
- UFW blocks unused ports and services  
- Remote SSH access from Windows confirmed  

---

## 📁 Future Enhancements

- Install `fail2ban` to block brute force attempts  
- Log and monitor all SSH login attempts  
- Automate this setup with Ansible or shell scripts  
- Run daily cron jobs for unattended upgrades  

---

## 📌 Disclaimer

This setup is for learning and small lab environments. For production systems, you should also configure intrusion detection, file integrity monitoring, and more advanced hardening.

