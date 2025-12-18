# SSH Setup: Local Machine → Master EC2 → Worker Nodes

---

## Prerequisites

* Windows PowerShell
* SSH installed
* Ubuntu EC2 instances
* Private key available on local machine

Private key path (Local Machine):

```
C:\Users\Click\Desktop\Devops\Ansible\Ansible-lab\ansible-terraform-key
```

---

## PART 1 — Local Machine → Master EC2

### Step 1: SSH from Local to Master

```bash
ssh -i "C:/Users/Click/Desktop/Devops/Ansible/Ansible-lab/ansible-terraform-key" ubuntu@<master-ip>
```

If prompted, type:

```text
yes
```

---

## PART 2 — Copy Private Key from Local → Master

> SCP must be executed from the Local Machine.

### Step 2: Exit Master (if logged in)

```bash
exit
```

### Step 3: Copy private key to Master

```bash
scp -i "C:/Users/Click/Desktop/Devops/Ansible/Ansible-lab/ansible-terraform-key" "C:/Users/Click/Desktop/Devops/Ansible/Ansible-lab/ansible-terraform-key" ubuntu@<master-ip>:/home/ubuntu/
```

---

## PART 3 — Master EC2 Configuration

### Step 4: SSH into Master again

```bash
ssh -i "C:/Users/Click/Desktop/Devops/Ansible/Ansible-lab/ansible-terraform-key" ubuntu@<master-ip>
```

### Step 5: Move key to .ssh directory

```bash
mv ~/ansible-terraform-key ~/.ssh/
cd ~/.ssh
```

### Step 6: Set permissions

```bash
chmod 400 ansible-terraform-key
```

### Step 7: Generate public key

```bash
ssh-keygen -y -f ~/.ssh/ansible-terraform-key > ~/.ssh/ansible-terraform-key.pub
```

### Step 8: Verify files

```bash
ls -l ~/.ssh
```

---

## PART 4 — Master → Worker 1

Worker 1 IP:

```text
<worker1-ip>
```

### Step 9: Copy public key to Worker 1

```bash
ssh-copy-id -i ~/.ssh/ansible-terraform-key.pub ubuntu@<worker1-ip>
```

### Step 10: Test SSH

```bash
ssh -i ~/.ssh/ansible-terraform-key ubuntu@<worker1-ip>
```

### Step 11: Set hostname

```bash
sudo hostnamectl set-hostname ansible-worker-1
```

---

## PART 5 — Master → Worker 2

Worker 2 IP:

```text
<worker2-ip>
```

### Step 12: Copy public key to Worker 2

```bash
ssh-copy-id -i ~/.ssh/ansible-terraform-key.pub ubuntu@<worker2-ip>
```

### Step 13: Test SSH

```bash
ssh -i ~/.ssh/ansible-terraform-key ubuntu@<worker2-ip>
```

### Step 14: Set hostname

```bash
sudo hostnamectl set-hostname ansible-worker-2
```

---

## SUMMARY

Local → Master

```bash
ssh -i path/to/key ubuntu@<master-ip>
```

Local → Copy key

```bash
scp -i path/to/key key ubuntu@<master-ip>:/home/ubuntu/
```

Master → Setup

```bash
mv key ~/.ssh/
chmod 400 key
ssh-keygen -y -f key > key.pub
```

Master → Workers

```bash
ssh-copy-id -i key.pub ubuntu@<worker-ip>
ssh -i key ubuntu@<worker-ip>
```

---

# Ansible Ad-Hoc Commands (Master → Workers)

Inventory group:

```text
workers
```

---

## 1. Connectivity Test

```bash
ansible workers -m ping
```

---

## 2. Uptime Check

```bash
ansible workers -a "uptime"
```

---

## 3. OS Version Check

```bash
ansible workers -a "cat /etc/os-release"
```

---

## 4. Hostname Check

```bash
ansible workers -a "hostname"
```

---

## 5. Disk Usage

```bash
ansible workers -a "df -h"
```

---

## 6. Memory Usage

```bash
ansible workers -a "free -m"
```

---

## 7. Running Processes (Top Memory Usage)

```bash
ansible workers -a "ps aux --sort=-%mem | head"
```

---

## 8. Create File on Workers

```bash
ansible workers -a "touch /tmp/testfile"
```

---

## 9. Check if a Package Exists

```bash
ansible workers -a "which nginx"
```

---

## 10. Install a Package (APT)

```bash
ansible workers -m apt -a "name=apache2 state=present update_cache=yes" -b
```

---

## 11. Reboot Workers

```bash
ansible workers -m reboot -b
```

---

## 12. Show IP Address

```bash
ansible workers -a "ip a"
```

---

## 13. Fetch File from Worker to Master

```bash
ansible workers -m fetch -a "src=/etc/hostname dest=/tmp/ flat=yes"
```

---

## 14. Run Multiple Commands

```bash
ansible workers -a "uname -a && whoami && uptime"
```

---

# Hands-On Guide: SSH Key Generation to Ansible Ping

This document provides a step-by-step, classroom-style hands-on guide to provision infrastructure using Terraform and validate connectivity using Ansible ad-hoc commands. Script contents are intentionally omitted for clarity.

---

## PART 1: Project Setup and Folder Structure

Create the project directory:

```bash
mkdir ansible-lab
cd ansible-lab
```

Expected folder structure:

```text
ansible-lab/
 ├── main.tf
 ├── variables.tf
 ├── ec2.tf
 └── terraform.tfvars
```

---

## PART 2: SSH Key Generation (ansible-terraform-key)

Generate an SSH key pair on your local machine:

```bash
ssh-keygen -t rsa -b 4096 -f ansible-terraform-key
```

This generates:

```text
ansible-terraform-key        (private key)
ansible-terraform-key.pub    (public key)
```

Keep both files inside the `ansible-lab` directory.

---

## PART 3: Terraform Variables Configuration

Create `terraform.tfvars` and define:

* Path to the SSH public key
* Ubuntu AMI ID

Ensure the public key path matches your local system location.

---

## PART 4: Terraform Configuration Files

Terraform configuration consists of:

* Provider configuration
* Key pair creation using the generated public key
* Security group with SSH and HTTP access
* EC2 instances for:

  * Ansible Master
  * Ansible Worker 1
  * Ansible Worker 2

All instances use the same Ubuntu AMI and security group.

---

## PART 5: Terraform Deployment

Initialize Terraform:

```bash
terraform init
```

Review the execution plan:

```bash
terraform plan
```

Apply and create infrastructure:

```bash
terraform apply -auto-approve
```

After completion:

* Note down the **public IP addresses** of:

  * Ansible Master
  * Ansible Worker 1
  * Ansible Worker 2

---

## PART 6: SSH Configuration

Follow the SSH setup steps to:

* Connect from Local Machine to Master
* Copy the private key to Master
* Enable passwordless SSH from Master to Worker nodes

(Refer to the SSH setup README used earlier.)

---

## PART 7: Install Ansible on Master Node

SSH into the Master EC2 instance and run:

```bash
sudo apt update
sudo apt install ansible -y
ansible --version
```

Verify that Ansible is installed successfully.

---

## PART 8: Configure Ansible Inventory

Open the Ansible inventory file:

```bash
sudo vim /etc/ansible/hosts
```

Define the workers inventory group with:

* Worker hostnames
* Worker public IPs
* SSH user
* SSH private key path

Ensure the private key path points to:

```text
~/.ssh/ansible-terraform-key
```

Save and exit the file.

---

## PART 9: Ansible Connectivity Test

Run the Ansible ping module:

```bash
ansible workers -m ping
```

Expected output:

```text
worker1 | SUCCESS => {"ping": "pong"}
worker2 | SUCCESS => {"ping": "pong"}
```

---

## Outcome

* Terraform successfully provisions Master and Worker EC2 instances
* SSH key-based authentication is configured
* Ansible Master can communicate with Worker nodes
* Infrastructure is ready for Ansible ad-hoc commands and playbooks

---
