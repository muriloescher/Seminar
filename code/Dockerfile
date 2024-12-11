FROM gcr.io/oss-fuzz-base/base-builder

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y -q && \
    apt-get update -y -q && \
    apt-get install -y -q --no-install-recommends \
        bison \
        build-essential \
        cmake \
        flex \
        libboost-all-dev \
        ninja-build \
        python3 \
        vim \
        zstd

RUN wget "https://github.com/github/codeql-action/releases/download/codeql-bundle-v2.19.4/codeql-bundle-linux64.tar.zst" && \
    tar --use-compress-program=unzstd -xvf codeql-bundle-linux64.tar.zst

RUN git clone --recurse-submodules \
    https://github.com/apache/arrow.git $SRC/arrow && \
    cd $SRC/arrow && git checkout 3c5b62c116733e434508a8673c2d466776b27eed

COPY build.sh $SRC/