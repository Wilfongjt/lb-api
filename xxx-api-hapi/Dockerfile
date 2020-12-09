FROM node:14.15.1

# set target folder for app
WORKDIR /usr/src/app

# need only packages to get started

COPY package*.json ./

# update all the packages in node_modules
RUN npm install

# move code from repo to container
COPY . .

RUN echo $PWD
RUN ls
EXPOSE 3000

CMD ["npm", "run", "start"]

#ENV HOST 0.0.0.0
# CMD ["npm", "run", "dev"]
