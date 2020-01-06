FROM cloudflare-cfssl:v1.4.1

# Install goose
RUN go get bitbucket.org/liamstask/goose/cmd/goose

ENV DATADIR /cfssl/data

RUN mkdir -p $DATADIR

WORKDIR /cfssl

# Copy config JSON files
COPY *.json ./

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 8888 8889
