# Use the Debian latest base image
FROM debian:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
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
    curl \
    unzip \
    novnc \
    websockify \
    x11vnc \
    xvfb \
    && apt-get clean

# Clone the xemu repository
RUN git clone https://github.com/mborgerson/xemu.git /xemu

# Build xemu
WORKDIR /xemu
RUN ./build.sh

# Set up noVNC and websockify for web access to xemu
RUN mkdir -p /opt/novnc/utils/websockify && \
    wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.zip -O /opt/novnc.zip && \
    unzip /opt/novnc.zip -d /opt && \
    mv /opt/noVNC-1.2.0 /opt/novnc && \
    wget https://github.com/novnc/websockify/archive/refs/tags/v0.9.0.zip -O /opt/websockify.zip && \
    unzip /opt/websockify.zip -d /opt/novnc/utils && \
    mv /opt/novnc/utils/websockify-0.9.0 /opt/novnc/utils/websockify

# Expose necessary ports
EXPOSE 8080

# Launch xemu with a virtual display
CMD ["sh", "-c", "Xvfb :99 -screen 0 1024x768x16 & x11vnc -display :99 -forever -shared -rfbport 5900 & /opt/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 8080 & DISPLAY=:99 ./dist/xemu"]
