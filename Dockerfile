FROM alpine:latest

# ENV V2RAY_VERSION master
ENV V2RAY_VERSION v1.17.3
ENV BUILD_DEPENDENCIES go git
ENV GOPATH /tmp/go

RUN apk add --update $BUILD_DEPENDENCIES \
 && mkdir $GOPATH \

 # Part of the following code was taken from official build script
 && go get -v -u github.com/v2ray/v2ray-core \
 && cd $GOPATH/src/github.com/v2ray/v2ray-core \
 && git checkout $V2RAY_VERSION \
 && rm -f $GOPATH/bin/build \
 && go get -v github.com/miekg/dns \
 && go install -v github.com/v2ray/v2ray-core/tools/build \
 && $GOPATH/bin/build \

 && cp $GOPATH/bin/v2ray-$V2RAY_VERSION-linux-64/v2ray /usr/local/bin/ \

 && rm -rf $GOPATH \
 && apk del --purge $BUILD_DEPENDENCIES \
 && rm -rf /var/cache/apk/*

EXPOSE 1080 10086

VOLUME ["/etc/v2ray/config.json", "/var/log/v2ray"]
CMD /usr/local/bin/v2ray -config /etc/v2ray/config.json
