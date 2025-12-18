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
