# fork: https://github.com/maxnilz/govanityurls/blob/master/Dockerfile
#
# builder
FROM golang:1.13-alpine3.9 as builder

RUN apk add --no-cache --update alpine-sdk bash
ENV GO111MODULE "on"

WORKDIR /go/src/github.com/kleister-io/govanityurls
COPY . .
RUN go build -o /govanityurls

# main
FROM alpine:3.9

RUN set -eux \
  && apk add --update tzdata ca-certificates openssl \
  && rm -rf /var/cache/apk/*

COPY --from=builder /govanityurls /usr/local/bin/govanityurls

ENTRYPOINT ["govanityurls", "/vanity.yaml"]