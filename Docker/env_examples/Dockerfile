FROM node:22

WORKDIR /app

COPY package*.json /app

RUN npm ci

COPY server.js ./server.js

ENV PORT=3090
ENV APP_NAME="My_App"

#EXPOSE serves only as documentation
EXPOSE 3090

CMD ["node", "server.js"]

