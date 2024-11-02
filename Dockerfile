FROM debian:bookworm AS builder

RUN     apt-get update && \
        apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
        curl -sL https://apt.envoyproxy.io/signing.key | gpg --dearmor -o /etc/apt/keyrings/envoy-keyring.gpg && \
        echo "deb [signed-by=/etc/apt/keyrings/envoy-keyring.gpg] https://apt.envoyproxy.io bookworm main" | tee /etc/apt/sources.list.d/envoy.list && \
        apt-get update && \
        apt-get install -y \
        git python3-pip build-essential autoconf libtool pkg-config cmake libssl-dev libboost-all-dev tar wget envoy \
	python3-requests python3-yaml libgrpc-dev flatbuffers-compiler libflatbuffers-dev libgrpc++-dev \
	libprotobuf-dev

RUN     cd /root && \
        wget https://github.com/lballabio/QuantLib/releases/download/QuantLib-v1.22/QuantLib-1.22.tar.gz && \
        tar -zxvf QuantLib-1.22.tar.gz && \
        cd QuantLib-1.22 && \
        ./configure --enable-std-pointers && \
        make -j && \
        make install && \
        ldconfig

# Quantra
RUN     cd /root && \
        git clone https://github.com/joseprupi/quantragrpc && \
        cd quantragrpc && \
        . ./scripts/config_vars.sh && \
        mkdir build && \
        cd build && \
        cmake ../ && \ 
        make -j
