# Stage 1: Build
FROM ubuntu:22.04 AS builder

# Set environment variables to prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libsdl2-dev \
    libepoxy-dev \
    libpixman-1-dev \
    libgtk-3-dev \
    libssl-dev \
    libsamplerate0-dev \
    libpcap-dev \
    ninja-build \
    python3-yaml \
    libslirp-dev \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clone the xemu repository from GitHub
RUN git clone https://github.com/mborgerson/xemu.git /xemu

# Set the working directory to the xemu directory
WORKDIR /xemu

# Build xemu using the provided build script
RUN ./build.sh

# Stage 2: Runtime
FROM ubuntu:22.04

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libssl3 \
    libsamplerate0 \
    libpcap0.8 \
    libslirp0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy xemu binaries from the build stage
COPY --from=builder /xemu/dist/xemu /usr/local/bin/xemu

# Set the working directory
WORKDIR /usr/local/bin

# Expose a port if needed (e.g., if xemu uses network features)
EXPOSE 8080

# Start xemu in headless mode
CMD ["xemu", "--headless"]
