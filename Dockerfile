FROM debian:bookworm AS builder

RUN     apt-get update && \
        apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
        curl -sL https://apt.envoyproxy.io/signing.key | gpg --dearmor -o /etc/apt/keyrings/envoy-keyring.gpg && \
        echo "deb [signed-by=/etc/apt/keyrings/envoy-keyring.gpg] https://apt.envoyproxy.io bookworm main" | tee /etc/apt/sources.list.d/envoy.list && \
        apt-get update && \
        apt-get install -y \
        git python3-pip build-essential autoconf libtool pkg-config cmake libssl-dev libboost-all-dev tar wget envoy \
	python3-requests python3-yaml flatbuffers-compiler libflatbuffers-dev \
	libprotobuf-dev

# gRPC
RUN     cd root && \
        git clone -b v1.67.1 https://github.com/grpc/grpc && \
        cd grpc && \
        git submodule update --init && \
        mkdir -p "third_party/abseil-cpp/cmake/build" && \
        cd ./third_party/abseil-cpp/cmake/build && \
        cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE ../.. && \
        make -j install && \
        cd /root/grpc && \
        mkdir install && \
        mkdir -p cmake/build && \
        cd cmake/build && \
        cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DgRPC_INSTALL=ON \
        -DgRPC_BUILD_TESTS=OFF \
        -DgRPC_ABSL_PROVIDER=package \
        -DgRPC_SSL_PROVIDER=package \
        -DBUILD_SHARED_LIBS=ON \
        -DCMAKE_INSTALL_PREFIX=/root/grpc/install \
        ../.. && \
        make -j$((`nproc`*2)) && \
        make install

RUN     cd /root && \
        wget https://github.com/lballabio/QuantLib/releases/download/QuantLib-v1.22/QuantLib-1.22.tar.gz && \
        tar -zxvf QuantLib-1.22.tar.gz && \
        cd QuantLib-1.22 && \
        ./configure --enable-std-pointers && \
        make -j$((`nproc`*2)) && \
        make install && \
        ldconfig

# Quantra
RUN     cd /root && \
        git clone https://github.com/joequant/quantraserver && \
        cd quantraserver && \
        . ./scripts/config_vars.sh && \
        mkdir build && \
        cd build && \
        cmake ../ && \ 
        make -j$((`nproc`*2))

