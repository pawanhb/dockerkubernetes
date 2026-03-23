FROM node:18-alpine

WORKDIR .

COPY package*.json .

run npm install

COPY . . 

CMD ["node" ,"server.js"]
