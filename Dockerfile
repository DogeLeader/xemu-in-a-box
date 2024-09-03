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
RUN git clone --recursive https://github.com/mborgerson/xemu.git /xemu

# Change working directory to /xemu
WORKDIR /xemu

# Use the build script to build xemu
RUN ./build.sh

# Create a directory for xemu config, games, and other files
RUN mkdir -p /root/.local/share/xemu

# Create a directory for the downloaded files
RUN mkdir -p /xemu-files

# Use wget to download the setup ZIP file
RUN wget -O /xemu-files/setup-files.zip "https://example.com/path/to/your/setup-files.zip"

# Unzip the setup files into the xemu-files directory
RUN unzip /xemu-files/setup-files.zip -d /xemu-files

# Copy the built binary to the headless directory
RUN cp ./build/xemu /usr/local/bin/xemu

# Entry point for running xemu in headless mode
CMD ["xemu", "--no-gui", "--headless"]
