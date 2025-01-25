FROM gcr.io/oss-fuzz-base/base-builder

ENV DEBIAN_FRONTEND=noninteractive

# Take in arguments from build command
ARG DEPENDENCIES
ARG REPO_URL
ARG COMMIT_HASH
ARG SETUP_COMMANDS
ARG BUILD_COMMANDS
ARG TOOL_BUILD_COMMAND

# Install basic needed packages
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

# Install specific dependencies
RUN if [ ! -z "${DEPENDENCIES}" ]; then \
    apt-get update -y -q && \
    apt-get install -y -q --no-install-recommends ${DEPENDENCIES} && \
    apt-get clean && rm -rf /var/lib/apt/lists/*; \
    fi

# Instal CodeQL
# RUN wget "https://github.com/github/codeql-action/releases/download/codeql-bundle-v2.19.4/codeql-bundle-linux64.tar.zst" && \
#     tar --use-compress-program=unzstd -xvf codeql-bundle-linux64.tar.zst && \
#     mv codeql /opt/codeql

# Install Infer
# RUN curl -sSL "https://github.com/facebook/infer/releases/download/v1.1.0/infer-linux64-v1.1.0.tar.xz" \
#     | tar -C /opt -xJ && \
#     ln -s "/opt/infer-linux64-v1.1.0/bin/infer" /usr/local/bin/infer

# Clone project and check out to BIC
RUN git clone --recurse-submodules \
    ${REPO_URL} /project && \
    cd /project && git checkout -f ${COMMIT_HASH}

COPY build.sh /scripts/build.sh
RUN chmod +x /scripts/build.sh

ENV REPO_DIR=/project
ENV BUILD_DIR=/build
ENV SETUP_COMMANDS=${SETUP_COMMANDS}
ENV BUILD_COMMANDS=${BUILD_COMMANDS}
ENV TOOL_BUILD_COMMAND=${TOOL_BUILD_COMMAND}

WORKDIR /project