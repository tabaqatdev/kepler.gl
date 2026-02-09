# Use Node.js 18 as the base image
FROM node:18

# Set the working directory
WORKDIR /app

# Enable Corepack
RUN corepack enable

# Copy the rest of the application code
COPY . .

# Fix line endings for shell scripts (Windows CRLF -> Unix LF) and set permissions
RUN find scripts -name "*.sh" -exec sed -i 's/\r$//' {} + && \
    chmod +x scripts/*.sh

# Set up Yarn 4.4.0 using corepack (after .yarnrc.yml is copied)
RUN corepack prepare yarn@4.4.0 --activate

# Install dependencies in the root folder
RUN yarn install

# Run fix-dependencies directly (skip full bootstrap which requires git submodules)
RUN yarn fix-dependencies

# Create stub dist directories for all workspace packages so imports resolve
RUN yarn workspaces foreach -At run stab

# Navigate to the examples/demo-app directory
WORKDIR /app/examples/demo-app

# Install dependencies in the demo-app folder
RUN yarn install

# Build the demo-app
RUN yarn build

# Use Caddy as the final image to serve the static files
FROM caddy:2-alpine

# Copy the built dist folder from the previous stage
COPY --from=0 /app/examples/demo-app/dist /usr/share/caddy

# Copy public assets (logo, etc.) into the serve directory
COPY --from=0 /app/examples/demo-app/public /usr/share/caddy

# Create and configure the Caddyfile
RUN printf ":80 {\n\
    root * /usr/share/caddy\n\
    file_server\n\
    try_files {path} /index.html\n\
}\n" > /etc/caddy/Caddyfile

# Expose port 80 for Caddy
EXPOSE 80

# Caddy will serve the index.html file by default
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
