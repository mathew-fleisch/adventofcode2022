FROM alpine:latest
RUN apk update && apk add bash make coreutils
COPY . /workspace
WORKDIR /workspace
ENTRYPOINT make run