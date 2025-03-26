# Base image with CUDA 11.4 and C++17-compatible compiler
FROM nvidia/cuda:11.4.3-devel-ubuntu18.04

# Metadata
LABEL maintainer="dktg@es.aau.dk"
LABEL description="Dockerfile for GVirtuS frontend component with matrix multiplication example"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV GVIRTUS_HOME=/home/GVirtuS

# Create the GVIRTUS_HOME directory and adjust permissions
RUN mkdir -p $GVIRTUS_HOME && \
    chmod -R 755 $GVIRTUS_HOME && \
    chown -R root:root $GVIRTUS_HOME

# Set the working directory to GVirtuS home
WORKDIR $GVIRTUS_HOME

# Update and install required dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    g++ \
    gcc \
    libxmu-dev \
    libxi-dev \
    libgl-dev \
    libosmesa-dev \
    git \
    curl \
    cmake \
    autotools-dev \
    nano \
    automake \
    libtool \
    liblog4cplus-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install CMake version 3.17 or above to compile Gvirtus
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    build-essential \
    libssl-dev \
    && apt-get purge -y cmake \
    && apt-get clean \
    && wget https://cmake.org/files/v3.17/cmake-3.17.1-Linux-x86_64.tar.gz \
    && tar zxvf cmake-3.17.1-Linux-x86_64.tar.gz \
    && rm -f cmake-3.17.1-Linux-x86_64.tar.gz \
    && mv cmake-3.17.1-Linux-x86_64 /opt/cmake-3.17.1 \
    && ln -sf /opt/cmake-3.17.1/bin/* /usr/bin/ 

# Install CUDA, cuDNN, and RDMA dependencies
RUN wget https://developer.download.nvidia.com/compute/cudnn/9.6.0/local_installers/cudnn-local-repo-ubuntu2004-9.6.0_1.0-1_amd64.deb && \
    dpkg -i cudnn-local-repo-ubuntu2004-9.6.0_1.0-1_amd64.deb && \
    cp /var/cudnn-local-repo-ubuntu2004-9.6.0/cudnn-*-keyring.gpg /usr/share/keyrings/ && \
    apt-get update && \
    apt-get -y install cudnn && \
    apt-get install libcudnn8 libcudnn8-dev && \
    rm -f cudnn-local-repo-ubuntu2004-9.6.0_1.0-1_amd64.deb && \
    apt-get install -y rdma-core librdmacm-dev libibverbs-dev && \
    apt-get remove -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone GVirtuS repository into the working directory
RUN git clone https://github.com/gvirtus/GVirtuS.git 

# Build and install GVirtuS
RUN cd GVirtuS && \
    mkdir -p build && \
    cd build && \
    cmake .. && \
    make && \
    make install

# Create examples directory and copy simple_matrix.cu
RUN mkdir -p ${GVIRTUS_HOME}/examples
COPY simple_matrix.cu ${GVIRTUS_HOME}/examples/

# Add GVirtuS binaries and libraries to PATH and LD_LIBRARY_PATH
ENV PATH="$GVIRTUS_HOME/bin:$PATH"
ENV LD_LIBRARY_PATH="$GVIRTUS_HOME/lib:$LD_LIBRARY_PATH"

# Expose port 8888 for TCP/IP communication
EXPOSE 8888
