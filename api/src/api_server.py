import json
import socket
import datetime
from wsgiref.simple_server import make_server

def application(environ, start_response):
    status = '200 OK'
    headers = [
        ('Content-type', 'application/json; charset=utf-8'),
    ('Access-Control-Allow-Origin', '*')]
    start_response(status, headers)

    now_time = datetime.datetime.now().strftime('%Y/%m/%d %H:%M:%S')
    host_name = socket.gethostname()
    host_ip = socket.gethostbyname(host_name)
    message = 'Hi!'
    response_json = {'message': message, 'Received time': now_time,
                     'Host Name': host_name, 'Host IP': host_ip}

    return [json.dumps(response_json).encode('utf-8')]

with make_server('', 3000, application) as httpd:
    print('Listening port : 3000')
    httpd.serve_forever()
