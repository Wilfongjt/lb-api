FROM node:14.15.1

# set target folder for app
WORKDIR /usr/src/app

# ENV NODE_ENV production
ENV NODE_ENV development

# need only packages to get started
COPY package*.json ./

# update all the packages in node_modules
RUN npm install

# move code from repo to container
COPY . .

EXPOSE 5555
#EXPOSE ${LB_API_PORT}

# allow browser connection to docker
# ENV HOST 0.0.0.0
#CMD ["node", "index.js"]
#CMD ["node", "index.js", "--host", "0.0.0.0"]
# CMD ["npm", "run", "dev"]
# CMD ["npm", "dev"]
