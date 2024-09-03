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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clone the xemu repository
RUN git clone https://github.com/mborgerson/xemu.git /xemu

# Build xemu without any X11 or Wayland dependencies
WORKDIR /xemu
RUN mkdir build
WORKDIR /xemu/build
RUN cmake -G Ninja .. \
    -DENABLE_OPENGL=OFF \
    -DENABLE_VULKAN=OFF \
    -DENABLE_SDL2=ON \
    -DENABLE_HEADLESS=ON
RUN ninja

# Create a directory for xemu config, games, and other files
RUN mkdir -p /root/.local/share/xemu

# Create a directory for the downloaded files
RUN mkdir -p /xemu-files

# Use wget to download the setup ZIP file
RUN wget -O /xemu-files/setup-files.zip "https://archive.org/download/xemu-files/XEMU_FILES.zip"
# Unzip the setup files into the xemu-files directory

RUN unzip /xemu-files/setup-files.zip -d /xemu-files

# Copy the built binary to the headless directory
RUN cp ./xemu /usr/local/bin/xemu

# Entry point for running xemu in headless mode
CMD ["xemu", "--no-gui", "--headless"]
