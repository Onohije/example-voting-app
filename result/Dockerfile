FROM node:24.22.1-slim AS base
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl tini && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /usr/local/app
COPY package*.json ./
RUN npm ci && \
    npm cache clean --force && \
    mv /usr/local/app/node_modules /node_modules
COPY --chown=node:node . .
ENV PORT=80
EXPOSE 80
ENTRYPOINT ["/usr/bin/tini", "--"]

FROM base AS dev
RUN npm install -g nodemon
USER node
CMD ["nodemon", "server.js"]

FROM base AS final
RUN rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx
USER node
CMD ["node", "server.js"]
