FROM ubuntu:20.04

LABEL maintainer="ge2317@uni-giessen.de"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    tar \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download and unpack SortMeRNA v4.3.6
WORKDIR /software
RUN wget https://github.com/sortmerna/sortmerna/releases/download/v4.3.6/sortmerna-4.3.6-Linux.tar.gz \
    && tar xzf sortmerna-4.3.6-Linux.tar.gz \
    && rm sortmerna-4.3.6-Linux.tar.gz \
    && mv /software/sortmerna-4.3.6-Linux/bin/sortmerna /usr/local/bin/
