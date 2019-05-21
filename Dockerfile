FROM debian:stable

RUN apt-get update && apt-get install -y python

COPY ./deb /tmp/deb

RUN dpkg -i /tmp/deb/* && rm -rf /tmp/deb

COPY ./entrypoint.sh /home/entrypoint.sh

EXPOSE 4500

ENTRYPOINT bash /home/entrypoint.sh