# FROM node:stable
FROM node:10.15.3
RUN echo "IN DF"
# set target folder for app
WORKDIR /usr/src
# need only packages to get started
COPY package*.json /usr/src/
RUN ls
# update all the packages in node_modules
RUN npm install && npm run build
# move code from repo to container
COPY . /usr/src
EXPOSE 3000
ENV HOST 0.0.0.0
# CMD ["npm", "run", "dev"]
