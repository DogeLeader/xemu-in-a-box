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

# Create a directory for xemu config and games
RUN mkdir -p /root/.local/share/xemu

# Set up a directory for headless operations
WORKDIR /xemu

# Copy the built binary to the root directory
RUN cp ./build/xemu /usr/local/bin/xemu

# Entry point for running xemu in headless mode
CMD ["xemu", "--no-gui", "--headless"]
