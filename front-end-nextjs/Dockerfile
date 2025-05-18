# ---------- Stage 1: Build ----------
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the frontend code
COPY . .

# Build the production-ready frontend
RUN npm run build

# ---------- Stage 2: Run ----------
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy built output and install only runtime deps
COPY --from=builder /app ./

# Expose Next.js app port
EXPOSE 3000

# Start the production server
CMD ["npm", "run", "start"]

