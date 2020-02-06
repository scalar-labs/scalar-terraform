FROM alpine:3

RUN ["/bin/sh", "-c", "apk add --update --no-cache bash ca-certificates curl git jq openssh"]

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
