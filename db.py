from flask import Flask, render_template, request, redirect, jsonify
import json
import requests
from datetime import datetime
import socket

app = Flask(__name__)
app.debug = True

## API Endpoint is http://{{ HOST }}:8888/api/v1/view and should return hostname, ip_address, time_stamp

## Render staic info page
@app.route('/', methods=['GET'])
def root():
    hostname = socket.gethostname()
    ip_addr = socket.gethostbyname(hostname)
    time_stamp = datetime.now()
    return render_template('/apisvc.html', hostname=hostname, ip_addr=ip_addr, time_stamp=time_stamp)

@app.route('/apisvc', methods=['GET'])
def index():
    hostname = socket.gethostname()
    ip_addr = socket.gethostbyname(hostname)
    time_stamp = datetime.now()
    return render_template('/apisvc.html', hostname=hostname, ip_addr=ip_addr, time_stamp=time_stamp)

@app.route('/api/v1/view', methods=['GET'])
def view():
    hostname = socket.gethostname()
    ip_addr = socket.gethostbyname(hostname)
    time_stamp = datetime.now()
    return_info = {
        'Host_Name': hostname,
        'IP_Address': ip_addr,
        'Timestamp': time_stamp
    }
    return jsonify(return_info)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8888)
