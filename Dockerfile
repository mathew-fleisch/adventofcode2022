FROM alpine:latest
RUN apk update && apk add bash make coreutils tree
COPY . /workspace
WORKDIR /workspace
ENTRYPOINT make run