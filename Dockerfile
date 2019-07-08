FROM golang:1.12-alpine AS builder
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --no-cache --update bash git
WORKDIR /build
ADD . .
RUN ./build.sh

FROM alpine:3.8
COPY --from=builder /build/bin/redis-shake /usr/local/app/redis-shake
COPY --from=builder /build/conf/redis-shake.conf /usr/local/app/redis-shake.conf
ENV TYPE sync
CMD /usr/local/app/redis-shake -conf /usr/local/app/redis-shake.conf -type ${TYPE}
