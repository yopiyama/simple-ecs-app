FROM python:latest

WORKDIR /src
COPY ./src/requirements.txt ./requirements.txt
RUN pip install -r ./requirements.txt

COPY ./src/api_server.py ./api_server.py
ENTRYPOINT [ "/usr/local/bin/python", "/src/api_server.py" ]
