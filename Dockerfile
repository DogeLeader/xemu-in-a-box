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
    x11vnc \
    xvfb \
    libgtk-3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a VNC password
RUN mkdir /root/.vnc && \
    x11vnc -storepasswd admin-doge /root/.vnc/passwd

# Set environment variable for terminal type
ENV TERM=xterm-256color

# Clone the xemu repository
RUN git clone --recursive https://github.com/mborgerson/xemu.git /xemu

# Change working directory to /xemu
WORKDIR /xemu

# Use the build script to build xemu
RUN ./build.sh

# Create a directory for xemu config
RUN mkdir -p /root/.local/share/xemu

# Expose the VNC port (5900 by default)
EXPOSE 5900

# Command to run Xvfb, x11vnc, and xemu
CMD ["bash", "-c", "Xvfb :1 -screen 0 1024x768x16 & DISPLAY=:1 ./xemu/dist/xemu & x11vnc -display :1 -usepw -forever -noxdamage -repeat -bg -rfbport 5900"]
