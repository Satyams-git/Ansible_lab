ANSIBLE AD-HOC COMMANDS (MASTER → WORKERS)
Inventory group: workers
________________________________________
1. Connectivity Test
ansible workers -m ping
________________________________________
2. Uptime Check
ansible workers -a "uptime"
________________________________________
3. OS Version Check
ansible workers -a "cat /etc/os-release"
________________________________________
4. Hostname Check
ansible workers -a "hostname"
________________________________________
5. Disk Usage
ansible workers -a "df -h"
________________________________________
6. Memory Usage
ansible workers -a "free -m"
________________________________________
7. Running Processes
ansible workers -a "ps aux --sort=-%mem | head"
________________________________________

8. Create File on Workers
ansible workers -a "touch /tmp/testfile"
________________________________________
9. Check if a Package Exists
ansible workers -a "which nginx"
________________________________________
10. Install a Package (Using APT)
ansible workers -m apt -a "name=apache2 state=present update_cache=yes" -b
________________________________________
11. Reboot Workers
ansible workers -m reboot -b
________________________________________
12. Show IP Address
ansible workers -a "ip a"
________________________________________
13. Fetch File From Worker to Master
ansible workers -m fetch -a "src=/etc/hostname dest=/tmp/ flat=yes"
________________________________________
14. Run Multiple Commands
ansible workers -a "uname -a && whoami && uptime"
