FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Fetch latest download URL and download binary
RUN DOWNLOAD_URL=$(curl -s https://app.ethone.cc/api/client/downloads | jq -r '.["linux-amd64"].client.url') && \
    curl -L -o ethone "$DOWNLOAD_URL" && \
    chmod +x ethone

# Create config.json from environment variables and run in CLI mode
CMD echo "{\"discord_token\":\"$DISCORD_TOKEN\",\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\"}" > config.json && ./ethone -cli

