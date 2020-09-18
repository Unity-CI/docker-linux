FROM ubuntu:20.04

RUN apt-get -q update \
    && apt-get -q install -y --no-install-recommends apt-utils \
    && apt-get -q install -y --no-install-recommends --allow-downgrades \
    ca-certificates \
    wget \
    libxtst6 \
    libxss1 \
    desktop-file-utils \
    fuse \
    libasound2 \
    libgtk2.0-0 \
    libnss3 \
    xdg-utils \
    xvfb \
    zenity \
    libdbus-glib-1-2 \
    xdotool \
    curl \
    && apt-get clean

ENV UNITY_DIR="/opt/unity"

# Download & extract AppImage
RUN wget --no-verbose -O /tmp/UnityHub.AppImage "https://public-cdn.cloud.unity3d.com/hub/prod/UnityHub.AppImage" \
    && chmod +x /tmp/UnityHub.AppImage \
    && cd /tmp \
    && /tmp/UnityHub.AppImage --appimage-extract \
    && cp -R /tmp/squashfs-root/* / \
    && rm -rf /tmp/squashfs-root /tmp/UnityHub.AppImage \
    && mkdir -p "$UNITY_DIR" \
    && mv /AppRun /opt/unity/UnityHub

ENV UNITY_HUB_BIN="/opt/unity/UnityHub"

# Accept
ENV CONFIG_DIR="/root/.config/Unity Hub"
RUN mkdir -p "${CONFIG_DIR}" && touch "${CONFIG_DIR}/eulaAccepted"

# Configure
RUN mkdir -p "${UNITY_DIR}/editors"

# Accept license
COPY bootstrapper.sh .
COPY no-really-lets-click-everywhere.sh .