
FROM golang:1.20.4-alpine3.18 as builder

ENV GOPATH /root/go

RUN apk add git curl zlib-dev bash build-base openssh --no-cache


# Build health server
WORKDIR /root/go/src/healthServer
ADD . .

RUN go build -a -o /tmp/healthServer ./main.go

RUN apk add --no-cache ca-certificates && update-ca-certificates

############################

FROM alpine:3.18 as healthServer

RUN apk update && apk upgrade

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /tmp/healthServer /healthServer

ENTRYPOINT ["/healthServer"]
