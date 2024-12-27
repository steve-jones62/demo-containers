## Readme for V1.0 DB Container
v1.0 version for Demos   

### Target for Packer Image with initially TF OS deployment

### Build Container Image with Docker
Requires:  
    Ubuntu 20.04 LTS
    RUN: 'sudo apt update && sudo apt upgrade -y'
    RUN: 'sudo apt install python3'
    RUN: 'sudo apt install pip3'
    COPY: folders and files from 'blue_container_db' folder and it's subfolders
    RUN: 'pip3 install -r requirements.txt'

### Names and Tags  
VM Name: vmdb.lab12.local

### Run Web Server on boot  
'python3 db.py' should be entry point/autorun  

### Responds to webby.lab12.local API - Therefore, requires this server to be running before use!
The vmdb.lab12.local server is a headless Flask server fronting a Redis DB image.  
The v1 API calls are:  
    return the hostname, ip Address, and timestamp from server use vmdb.lab12.local:8888/api/v1/view   


  
