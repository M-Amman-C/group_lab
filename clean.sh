#!/bin/bash

echo "Starting cleanup of Linux Group Management Lab..."

# Delete user 'adminuser' (along with home directory)
if id "adminuser" &>/dev/null; then
    sudo userdel -r adminuser
    echo "User 'adminuser' deleted."
else
    echo "User 'adminuser' does not exist. Skipping."
fi

# Remove sudo rule for 'admin' group
if [ -f /etc/sudoers.d/admin_group ]; then
    sudo rm /etc/sudoers.d/admin_group
    echo "Sudo permissions for 'admingroup' group removed."
else
    echo "Sudoers file for 'admingroup' group not found. Skipping."
fi

# Delete group 'admingroup'
if getent group admingroup > /dev/null; then
    sudo groupdel admingroup
    echo "Group 'admingroup' deleted."
else
    echo "Group 'admingroup' does not exist. Skipping."
fi

# Delete renamed group 'uiux' (previously 'developer')
if getent group uiux > /dev/null; then
    sudo groupdel uiux
    echo "Group 'uiux' deleted."
else
    echo "Group 'uiux' does not exist. Skipping."
fi

# In case 'designers' group still exists
if getent group designers > /dev/null; then
    sudo groupdel designers
    echo "Group 'designers' deleted."
fi

# In case 'marketing' group was recreated for testing
if getent group marketing > /dev/null; then
    sudo groupdel marketing
    echo "Group 'marketing' deleted."
fi

# Deleting file of deleted group
rm -rf /tmp/example.txt


echo "Linux Group Management Lab cleanup complete."
