# Use Red Hat Universal Base Image 9 with Node.js
FROM registry.access.redhat.com/ubi9/nodejs-18:latest

# Set working directory
WORKDIR /opt/app-root/src

# Copy package files
COPY package*.json ./

# Install dependencies as the default user
USER 1001
RUN npm ci --omit=dev

# Copy application code
COPY --chown=1001:0 . .

# Expose port
EXPOSE 8080

# Set environment
ENV NODE_ENV=production

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:8080/health', (r) => { process.exit(r.statusCode === 200 ? 0 : 1); })"

# Start the application
CMD ["npm", "start"]
