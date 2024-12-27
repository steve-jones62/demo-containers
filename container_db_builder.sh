#!/bin/bash -x

# Update the system packages
sudo apt-get update
sudo apt-get -y upgrade

# Install general utilities
sudo apt install -y tree
sudo apt install -y unzip


##### Set up user access #####
# Create a local users for the student
# User the `mkpasswd -m sha-512 <clear_text_pw>` to install
# This command is part of the whois apt repo
sudo useradd -m -p '$6$iX1yEimEZ6FX1n$AzZArfwsMXhyC/lpPh9RdMoWks9cwjldg4RxpIIQFOoy0QrKaJsGYIJbK3/QgwDTgvZoiDaJOE7q2tqzJz/2Y.' -s /bin/bash ignw

# Put the user in the group that allows xrdp access
sudo adduser ignw ssl-cert

# Add the user to sudoers file
sudo usermod -aG sudo ignw

##### Install software #####

# Install Terraform 0.15.5
wget https://releases.hashicorp.com/terraform/0.15.5/terraform_0.15.5_linux_amd64.zip
unzip terraform_*.zip
sudo mv terraform /usr/local/bin/

# Install Pip for Python3
sudo apt install -y python3-pip

## Install the packages as the lab user so
## they will be installed in the users .local/bin directory
## So pathing should work properly

# COPY folders and files from 'blue_container_db' folder and it's subfolders

## Add python package install directory to the path
# Add python libraries
sudo su -c 'pip3 install --user Flask==1.1.1' ignw
sudo su -c 'pip3 install --user Flask-Admin==1.5.4' ignw
sudo su -c 'pip3 install --user Flask-Bootstrap==3.3.7.1' ignw
sudo su -c 'pip3 install --user Flask-Cors==3.0.8' ignw
sudo su -c 'pip3 install --user Flask-HTTPAuth==3.3.0' ignw
sudo su -c 'pip3 install --user Flask-SQLAlchemy==2.4.1' ignw
sudo su -c 'pip3 install --user Flask-WTF==0.14.2' ignw
sudo su -c 'pip3 install --user Jinja2==2.10.3' ignw
sudo su -c 'pip3 install --user jinja2-time==0.2.0' ignw
sudo su -c 'pip3 install --user jsonschema==3.2.0' ignw
sudo su -c 'pip3 install --user more-itertools==7.2.0' ignw
sudo su -c 'pip3 install --user multidict==4.7.4' ignw
sudo su -c 'pip3 install --user python-dateutil==2.8.1' ignw
sudo su -c 'pip3 install --user requests==2.22.0' ignw
sudo su -c 'pip3 install --user requests-toolbelt==0.9.1' ignw
sudo su -c 'pip3 install --user uritemplate==3.0.0' ignw
sudo su -c 'pip3 install --user urllib3==1.25.7' ignw
sudo su -c 'pip3 install --user websocket-client==0.56.0' ignw
sudo su -c 'pip3 install --user Werkzeug==0.16.0' ignw
sudo su -c 'pip3 install --user WTForms==2.2.1' ignw


# When the default terminal opens, it does not run the .profile
# file, so including this line here to append the section from the 
# .profile section to the .bashrc file which does run.
# The down side is when VS Code does open it does read the .profile
# file, so then we get the local directory twice.
# This is super hackey, but the best i can come up with
sudo su -c 'echo -e "\n# set PATH so it includes users private bin if it exists\nif [ -d \"$HOME/.local/bin\" ] ; then\n     PATH=\"$HOME/.local/bin:$PATH\"\nfi" >> /home/ignw/.bashrc' ignw

# Set the IGNW user to be able to use the password to log in
# Appends commands to allow the ignw user to ssh in but still allow all other
# users to ssh in via google keys
sudo su -c 'echo -e "\n Match User ignw\n\tPasswordAuthentication yes\n" >> /etc/ssh/sshd_config'


### Names and Tags  
# VM Name: bluevmdb@usbanklab.com      
# Service Name: vmdb@usbank.com  

### Run Web Server on boot  
# 'python3 blue_db.py' should be entry point/autorun 
