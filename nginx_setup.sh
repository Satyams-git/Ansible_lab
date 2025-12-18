#!/bin/bash
#
#
apt update -y
apt install nginx -y


cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<style>
body {
  background-color: black;
  color: cyan;
  font-size: 40px;
  text-align: center;
  margin-top: 20%;
}
</style>
</head>
<body>
We are learning Ansible
</body>
</html>
EOF


systemctl restart nginx
