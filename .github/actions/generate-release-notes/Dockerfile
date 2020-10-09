FROM alpine:3

RUN apk --no-cache add git nodejs-npm
RUN npm install -g github-release-notes

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
