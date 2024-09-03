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
    clang \
    llvm \
    libgbm-dev \
    libdrm-dev \
    libxkbcommon-dev \
    libwayland-dev \
    libinput-dev \
    libudev-dev \
    libvulkan-dev \
    pkg-config \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clone the xemu repository
RUN git clone https://github.com/mborgerson/xemu.git /xemu

# Disable X11 and Wayland in the xemu build
WORKDIR /xemu
RUN sed -i 's/find_package(X11 REQUIRED)/#find_package(X11 REQUIRED)/' CMakeLists.txt
RUN sed -i 's/find_package(Wayland REQUIRED)/#find_package(Wayland REQUIRED)/' CMakeLists.txt
RUN sed -i 's/add_definitions(-DX11_SUPPORT)/#add_definitions(-DX11_SUPPORT)/' CMakeLists.txt

# Build xemu
RUN ./build.sh

# Create a directory for xemu config and games
RUN mkdir -p /root/.local/share/xemu

# Create a directory for headless operations
RUN mkdir -p /xemu/headless

# Move the built binary to the headless directory
RUN cp ./dist/xemu /xemu/headless

# Set the working directory to headless
WORKDIR /xemu/headless

# Entry point for running xemu in headless mode without X11
CMD ["./xemu", "--no-gui", "--headless"]
