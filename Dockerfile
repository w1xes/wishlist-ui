FROM node:24-alpine AS build
WORKDIR /app

# Dependencies first: this layer is rebuilt only when package.json or the lockfile changes.
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund

COPY . .

# Public API address, inlined into the JS bundle by Vite at build time (not a secret).
ARG VITE_API_BASE=http://localhost:8000
ENV VITE_API_BASE=$VITE_API_BASE
RUN npm run build


FROM nginx:1.30-alpine
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
