FROM node:20-bookworm-slim

# Install system dependencies, build tools, Wine, and unzip
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        unzip \
        python3 \
        make \
        g++ \
        build-essential \
        libcairo2-dev \
        libpango1.0-dev \
        libjpeg-dev \
        libgif-dev \
        librsvg2-dev \
        wine \
        wine64 \
        wine32 \
        lua5.1 && \
    rm -rf /var/lib/apt/lists/*

# Download native Linux Lune from GitHub releases to /usr/local/bin
RUN curl -fSL "https://github.com/lune-org/lune/releases/download/v0.10.5/lune-0.10.5-linux-x86_64.zip" -o /tmp/lune.zip && \
    unzip /tmp/lune.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/lune && \
    rm /tmp/lune.zip

WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci || npm install

COPY . .

# Setup wrapper so main.luau executes lute.exe through Wine under the hood
RUN mkdir -p unveilr/bin && \
    echo '#!/bin/sh\nexec wine "$(dirname "$0")/../lute.exe" "$@"' > unveilr/bin/lute-linux && \
    chmod +x unveilr/bin/lute-linux

ENV PROD=true
ENV WINEDEBUG=-all
ENV PORT=10000

EXPOSE 10000

CMD ["node", "db.js"]