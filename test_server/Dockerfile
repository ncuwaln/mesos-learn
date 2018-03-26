FROM python:3

COPY ["./", "/var/test_server"]

WORKDIR /var/test_server

RUN pip3 install -r requirements.txt -i https://pypi.douban.com/simple/

CMD ["python3", "app.py"]
