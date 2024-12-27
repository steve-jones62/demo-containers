#! /usr/bin/env python3

from flask import Flask, render_template, request, redirect
import json
import requests
from datetime import datetime
import socket

app = Flask(__name__)
app.debug = True

HOSTNAME = socket.gethostname()
IP_ADDR = socket.gethostbyname(HOSTNAME)
NAMESPACE = "gitops-webby" if "gitops" in HOSTNAME else "webby"
PORT = "30999" if "gitops" in HOSTNAME else "31999"
# BASE_URL = f"http://ocp01-hpe02.pedemo.ignw.io:{PORT}"
# Changed with new RHOS Route - make sure it is created
BASE_URL = f"https://webby-webby.apps.ocp-hpe02.pedemo.ignw.io/"

@app.route('/', methods=['GET'])
def root():
    time_stamp = datetime.now()
    return render_template('/index.html', hostname=HOSTNAME, ip_addr=IP_ADDR, time_stamp=time_stamp, base_url = BASE_URL)

@app.route('/index', methods=['GET'])
def index():
    time_stamp = datetime.now()
    return render_template('/index.html', hostname=HOSTNAME, ip_addr=IP_ADDR, time_stamp=time_stamp, base_url = BASE_URL)

@app.route('/container', methods=['GET'])
def container():
    try:
        cont_response_get = requests.get(f'http://condb-service.{NAMESPACE}:8888/api/v1/view')
        return_data = cont_response_get.content.decode('utf-8')
        return_data = json.loads(return_data)
        return render_template('/container.html', data=(return_data), base_url = BASE_URL)
    except requests.exceptions.Timeout:
        return render_template('/conterror.html', base_url = BASE_URL)
    except requests.exceptions.HTTPError:
        return render_template('/conterror.html', base_url = BASE_URL)
    except requests.exceptions.ConnectionError:
        return render_template('/conterror.html', base_url = BASE_URL)

@app.route('/vm', methods=['GET'])
def vm():
    try:
        vm_response_get = requests.get(f'http://vmdb-service.{NAMESPACE}:8888/api/v1/view')
        return_data = vm_response_get.content.decode('utf-8')
        return_data = json.loads(return_data)
        return render_template('/vm.html', data=(return_data), base_url = BASE_URL)
    except requests.exceptions.Timeout:
        return render_template('/vmerror.html', base_url = BASE_URL)
    except requests.exceptions.HTTPError:
        return render_template('/vmerror.html', base_url = BASE_URL)
    except requests.exceptions.ConnectionError:
        return render_template('/vmerror.html', base_url = BASE_URL)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9999)
