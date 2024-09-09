# Use Debian as the base image
FROM debian:latest

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libsdl2-dev \
    libepoxy-dev \
    libpixman-1-dev \
    libssl-dev \
    libsamplerate0-dev \
    libpcap-dev \
    ninja-build \
    python3-yaml \
    libslirp-dev \
    libgbm-dev \
    libdrm-dev \
    llvm \
    clang \
    unzip \
    wget \
    pkg-config \
    apt-get update && apt-get install -y \
    git \
    npm \
    nodejs \
    build-essential \
    cmake \
    clang \
    gcc \
    g++ \
    zlib1g-dev \
    libuv1-dev \
    libjson-c-dev \
    libwebsockets-dev \
    sudo \
    curl \
    wget \
    net-tools \
    vim \
    openssh-client \
    locales \
    bash-completion \
    iputils-ping \
    htop \
    gnupg2 \
    tmux \
    screen \
    zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set environment variable for terminal type
ENV TERM=xterm-256color

# Download and install ttyd from a specific version for compatibility
RUN git clone --branch 1.6.3 https://github.com/tsl0922/ttyd.git /ttyd-src && \
    cd /ttyd-src && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install
    
# Clone the xemu repository
RUN git clone --recursive https://github.com/mborgerson/xemu.git /xemu

# Change working directory to /xemu
WORKDIR /xemu

# Use the build script to build xemu
RUN ./build.sh

# Create a directory for xemu config, games, and other files
RUN mkdir -p /root/.local/share/xemu

# Create a directory for the downloaded files
RUN mkdir -p /xemu-files

# Copy the built binary to the headless directory
RUN cp -r ./dist/xemu /usr/local/bin/xemu

# Entry point for running xemu in headless mode
CMD ["bash", "-c", "ttyd -p 10000 bash -c './dist/xemu --no-gui --headless'"]
