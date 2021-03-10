FROM python:3.9.2-slim-buster
LABEL maintainer='Thomas Yager-Madden <thomas@yager-madden.com>'

# install hugo to generate HTML
RUN apt-get update && apt-get install -y curl
RUN curl -L -O -J https://github.com/gohugoio/hugo/releases/download/v0.81.0/hugo_extended_0.81.0_Linux-64bit.deb
RUN dpkg -i hugo_extended_0.81.0_Linux-64bit.deb 2> /dev/null

# Copy in the code
COPY . /app

WORKDIR /app
VOLUME /public

# install from code currently in repo
RUN python setup.py install

ENTRYPOINT /app/entrypoint.sh
