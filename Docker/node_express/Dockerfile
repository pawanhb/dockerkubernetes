FROM node:22

WORKDIR /app

COPY package*.json /app

RUN npm ci

COPY server.js ./server.js

ENTRYPOINT ["node"]
CMD [ "server.js"]

