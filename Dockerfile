FROM node:22-slim

# Install dependencies
RUN apt-get update && apt-get install -y xz-utils ca-certificates rsync curl \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm globally
RUN npm install -g pnpm

# Install moltbot (CLI is still named clawdbot until upstream renames)
RUN npm install -g clawdbot@2026.1.24-3 \
    && clawdbot --version

# Create moltbot directories
RUN mkdir -p /root/.clawdbot \
    && mkdir -p /root/.clawdbot-templates \
    && mkdir -p /root/clawd \
    && mkdir -p /root/clawd/skills

# Copy startup script
COPY start-moltbot.sh /usr/local/bin/start-moltbot.sh
RUN chmod +x /usr/local/bin/start-moltbot.sh

# Copy default configuration template
COPY moltbot.json.template /root/.clawdbot-templates/moltbot.json.template

# Copy custom skills
COPY skills/ /root/clawd/skills/

# Set working directory
WORKDIR /root/clawd

# Expose the gateway port
EXPOSE 18789

# Start moltbot
CMD ["/usr/local/bin/start-moltbot.sh"]
