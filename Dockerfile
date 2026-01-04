# Dockerfile

# ============================================
# 1. Build app
# ============================================
FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm ci --silent

# Copy all files
COPY . .

RUN npm run build

# ============================================
# Start NGINX server
# ============================================
FROM nginx:alpine

# Copy built app from the previous stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy custom NGINX configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Open port 10000
EXPOSE 10000

# Run NGINX server
CMD ["nginx", "-g", "daemon off;"]
