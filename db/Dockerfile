FROM node:8.11.3-alpine

WORKDIR /usr/app

# Install node dependencies
COPY package*.json /usr/app/
RUN npm install --quiet

# Copy over the db.json
COPY . .

EXPOSE 3000

# CMD [""]
