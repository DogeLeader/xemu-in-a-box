# Stage 1: Build
FROM ubuntu:latest AS builder

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
FROM ubuntu:latest

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libsdl2-2.0-0 \
    libepoxy0 \
    libpixman-1-0 \
    libgtk-3-0 \
    libssl3 \
    libsamplerate0 \
    libpcap0.8 \
    libslirp0 \
    novnc \
    websockify \
    x11vnc \
    xvfb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy xemu binaries from the build stage
COPY --from=builder /xemu/dist/xemu /usr/local/bin/xemu

# Copy noVNC files
COPY --from=builder /usr/share/novnc /usr/share/novnc

# Set the working directory
WORKDIR /usr/local/bin

# Expose port 8080 for web access
EXPOSE 8080

# Start the VNC server, websockify, and xemu
CMD ["sh", "-c", "xvfb-run --server-args=\"-screen 0 1024x768x24\" x11vnc -display :99 -forever -shared -rfbport 5900 -nolookup -nopw & websockify --web=/usr/share/novnc/ 8080 localhost:5900 & xemu"]
