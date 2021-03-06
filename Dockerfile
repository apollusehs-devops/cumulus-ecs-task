FROM node:8.10-alpine

RUN npm install -g npm@latest

RUN apk update && \
  apk add unzip && \
  apk add python2 && \
  rm -rf /var/cache/apk

RUN addgroup -S -g 433 service
RUN adduser -S -u 431 -G service -h /home/service -s /sbin/nologin service

WORKDIR /home/service

COPY package.json package-lock.json /home/service/
RUN chown service:service /home/service/package*.json

RUN npm ci --production

COPY . /home/service/
RUN chown -R service:service /home/service

ENTRYPOINT ["node", "./bin/service.js"]
