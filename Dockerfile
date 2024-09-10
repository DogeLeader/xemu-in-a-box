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
    npm \
    nodejs \
    cmake \
    gcc \
    g++ \
    zlib1g-dev \
    libuv1-dev \
    libjson-c-dev \
    libwebsockets-dev \
    sudo \
    curl \
    net-tools \
    vim \
    openssh-client \
    locales \
    bash-completion \
    iputils-ping \
    htop \
    libgtk-3-dev \
    gnupg2 \
    tmux \
    screen \
    zsh \
    xvfb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set environment variable for terminal type
ENV TERM=xterm-256color

# Clone and build ttyd
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

# Expose the desired port
EXPOSE 10000

# Entry point for running xemu in headless mode using Xvfb
# Check the actual location of the built xemu binary in the directory structure
CMD ["bash", "-c", "Xvfb :1 -screen 0 1024x768x16 & ttyd -p 10000 bash -c 'DISPLAY=:1 ./xemu/dist/xemu'"]
