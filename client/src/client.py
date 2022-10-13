import os
import json
import socket
import requests
import streamlit as st

BACKEND_URL = os.getenv('backend_service_url')
BACKEND_PORT = os.getenv('backend_service_port')

def main():
    host_name = socket.gethostname()
    host_ip = socket.gethostbyname(host_name)

    st.write('Hello World.')

    st.caption('Frontend Info')
    st.write({'Host Name': host_name, 'Host IP': host_ip})


    backend = BACKEND_URL + ':' + BACKEND_PORT
    response = requests.get(backend)
    st.caption('Backend Response')
    st.write(response.json())

if __name__ == '__main__':
    main()
