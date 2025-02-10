# Use official Node.js Alpine as a lightweight base image
FROM node:18-alpine

# Set working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (or pnpm-lock.yaml) first to leverage Docker cache
COPY package.json pnpm-lock.yaml ./

# Install dependencies using pnpm
RUN npm install -g @angular/cli pnpm && pnpm install

# Copy the rest of the frontend code
COPY . .

# Expose Angular development server port
EXPOSE 4200

# Default command to run Angular app
CMD ["pnpm", "run", "start"]
