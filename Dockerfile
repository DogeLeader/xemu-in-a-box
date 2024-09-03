# Use the official Ubuntu 22.04 base image
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    git \
    libgtk-3-dev \
    libglib2.0-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libx11-dev \
    libxext-dev \
    libxi-dev \
    libxrandr-dev \
    libxinerama-dev \
    libxss-dev \
    libpulse-dev \
    libasound2-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone the Xemu repository
RUN git clone --recurse-submodules https://github.com/xemu-project/xemu.git /xemu

# Set the working directory
WORKDIR /xemu

# Build Xemu
RUN ./build.sh

# Set the entry point for the container
ENTRYPOINT ["./dist/xemu"]

# Expose any necessary ports (if applicable)
# EXPOSE 8080
