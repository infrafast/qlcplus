FROM mcr.microsoft.com/devcontainers/base:debian-13

USER root

ARG DEBIAN_FRONTEND=noninteractive

# Add ARM64 as a foreign Debian architecture. The Codespace itself remains amd64.
RUN dpkg --add-architecture arm64 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates git curl file rsync zip unzip \
       build-essential cmake ninja-build pkg-config \
       crossbuild-essential-arm64 gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
       python3 python3-lxml libxml2-utils \
       qt6-base-dev-tools qt6-declarative-dev-tools qt6-tools-dev qt6-tools-dev-tools qt6-l10n-tools \
    && apt-get install -y --no-install-recommends \
       qt6-base-dev:arm64 \
       qt6-declarative-dev:arm64 \
       qt6-multimedia-dev:arm64 \
       qt6-serialport-dev:arm64 \
       qt6-svg-dev:arm64 \
       qt6-websockets-dev:arm64 \
       qt6-3d-dev:arm64 \
       libglx-dev:arm64 \
       libgl1-mesa-dev:arm64 \
       libasound2-dev:arm64 \
       libftdi-dev:arm64 \
       libftdi1-dev:arm64 \
       libfftw3-dev:arm64 \
       libsndfile1-dev:arm64 \
       libudev-dev:arm64 \
       libusb-dev:arm64 \
       libusb-1.0-0-dev:arm64 \
       libxkbcommon-dev:arm64 \
    && rm -rf /var/lib/apt/lists/*

USER vscode
