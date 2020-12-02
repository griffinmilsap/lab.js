FROM node:15.3.0-buster as build-deps
WORKDIR /usr/src/labjs
COPY . ./
RUN yarn && yarn run bootstrap
WORKDIR /usr/src/labjs/packages/library
RUN yarn run build:js && yarn run build:starterkit
WORKDIR /usr/src/labjs/packages/builder
RUN yarn run build

FROM nginx:1.12-alpine
COPY --from=build-deps /usr/src/labjs/packages/builder/build /usr/share/nginx/html
EXPOSE 80
CMD [ "nginx", "-g", "daemon off;" ]
