FROM node:8.11.3-alpine

WORKDIR /usr/app

COPY package*.json /usr/app/
RUN npm install --quiet

COPY . .

EXPOSE 8080

CMD ["node", "index.js"]