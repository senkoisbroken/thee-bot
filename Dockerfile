FROM node:20-bookworm

# Install wine64, lua5.1, libcairo dependencies for canvas, and unzip for lune
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        unzip \
        wine \
        wine64 \
        lua5.1 \
        libcairo2-dev \
        libpango1.0-dev \
        libjpeg-dev \
        libgif-dev \
        librsvg2-dev && \
    ln -sf /usr/bin/lua5.1 /usr/local/bin/lua && \
    rm -rf /var/lib/apt/lists/*

# Install native Linux Lune CLI
RUN curl -fSL "https://github.com/lune-org/lune/releases/download/v0.10.5/lune-0.10.5-linux-x86_64.zip" -o /tmp/lune.zip && \
    unzip -o /tmp/lune.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/lune && \
    rm /tmp/lune.zip

WORKDIR /app

# Copy dependency definitions
COPY package.json package-lock.json* ./

# Cleanly install npm dependencies
RUN npm install --production

# Copy the rest of the application
COPY . .

# Setup wrapper so main.luau executes lute.exe through Wine under the hood
RUN mkdir -p /app/unveilr/bin && \
    echo '#!/bin/sh\nexec wine /app/unveilr/lute.exe "$@"' > /app/unveilr/bin/lute-linux && \
    chmod +x /app/unveilr/bin/lute-linux

ENV PROD=true
ENV WINEDEBUG=-all
ENV PORT=10000

EXPOSE 10000

CMD ["node", "db.js"]
