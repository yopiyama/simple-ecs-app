FROM python:latest

WORKDIR /src
COPY ./src/requirements.txt ./requirements.txt
RUN pip install -r ./requirements.txt

COPY ./src/client.py ./client.py
ENTRYPOINT [ "/usr/local/bin/streamlit", "run", "/src/client.py" ]
