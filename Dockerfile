FROM golang:1.11-alpine as builder

ARG VERSION=default
ARG GOOS=linux

WORKDIR /go/src/github.com/readytalk/stim/
COPY ./ .

RUN CGO_ENABLED=0 GOOS=${GOOS} go build -ldflags "-X github.com/readytalk/stim/cmd.version=${VERSION}" -v -a -o stim .

CMD ["/bin/sh", "-c", "stim"]

# Stage 2

FROM alpine:latest

RUN apk --no-cache add ca-certificates

ENV CONFIGURATION_PATH=/config

COPY --from=builder /go/src/github.com/readytalk/stim/ /usr/bin

ENTRYPOINT ["stim"]
