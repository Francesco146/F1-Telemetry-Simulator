FROM --platform=386 ubuntu:bionic

RUN apt-get update \
    && apt-get install -y gcc gdb make \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -u 1000 asmr
USER asmr

WORKDIR /asm
