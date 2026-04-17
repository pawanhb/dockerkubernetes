FROM node:22

WORKDIR /app

#copy the package.json file
COPY package*.json .

#install application dependencies
RUN npm install

#copy the source code
COPY src/server.js .

#run the application
CMD ["node", "server.js"]

