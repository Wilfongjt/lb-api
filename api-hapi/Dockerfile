FROM node:14.15.1

# set target folder for app
WORKDIR /usr/src/app

ENV NODE_ENV production

# need only packages to get started
COPY package*.json ./

# update all the packages in node_modules
RUN npm install

# move code from repo to container
COPY . .

EXPOSE 3001

# allow browser connection to docker
# ENV HOST 0.0.0.0
#CMD ["node", "index.js"]
#CMD ["node", "index.js", "--host", "0.0.0.0"]
# CMD ["npm", "run", "dev"]
# CMD ["npm", "dev"]
