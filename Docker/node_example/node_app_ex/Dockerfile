FROM node:22-alpine

WORKDIR /app

COPY package*.json .

RUN npm ci

COPY src/ .

CMD ["node", "index.js"]

