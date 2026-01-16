FROM debian:bookworm-slim

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

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
CMD jq -n \
    --arg discord_token "$DISCORD_TOKEN" \
    --arg username "$USERNAME" \
    --arg password "$PASSWORD" \
    '{discord_token: $discord_token, username: $username, password: $password}' > config.json && \
    ./ethone -cli

