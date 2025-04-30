#!/bin/bash


echo "Starting Linux Group Management Lab Setup..."

# Create group 'designers' with default GID
sudo groupadd designers
echo "Group 'designers' created."

# Create group 'marketing' with GID 2000
sudo groupadd -g 2000 marketing
echo "Group 'marketing' with GID 2000 created."

# Create group 'admin'
sudo groupadd admingroup
echo "Group 'admingroup' created."

# Create user 'adminuser' and add to 'admingroup' group
sudo useradd -m -G admingroup adminuser
echo "adminuser:Mypass@123" | sudo chpasswd
echo "User 'adminuser' created and added to group 'admingroup'. Password set."

# Grant sudo access to 'admin' group by editing sudoers file safely
echo "%admingroup ALL=(ALL:ALL) ALL" > /etc/sudoers.d/admin_group
sudo chmod 440 /etc/sudoers.d/admin_group
echo "Sudo access granted to group 'admingroup'."

# Rename group 'designers' to 'uiux'
sudo groupadd developer
sudo groupmod -n uiux developer
echo "Group 'developers' renamed to 'uiux'."

# Delete group 'marketing'
sudo groupadd tempgroup
touch /tmp/example.txt
sudo chgrp tempgroup /tmp/example.txt
sudo groupdel tempgroup
echo "Group 'tempgroup' deleted."

echo "Linux Group Management Lab setup complete."
