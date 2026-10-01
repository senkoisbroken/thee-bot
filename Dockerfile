FROM node:20

# Install wine64
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y wine64 wine32 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package.json .
RUN npm install
COPY . .

# Create wrapper for lute.exe to run with wine
RUN mkdir -p unveilr/bin
RUN echo '#!/bin/sh\nwine lute.exe "$@"' > unveilr/bin/lute-linux
RUN chmod +x unveilr/bin/lute-linux

ENV PROD=true
CMD ["node", "db.js"]