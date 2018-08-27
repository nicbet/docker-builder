FROM docker:18.03

RUN apk add --no-cache bash gawk sed grep bc coreutils git
RUN mkdir -p /opt && mkdir -p /build

WORKDIR /build

COPY build_docker.sh /opt
RUN chmod a+x /opt/build_docker.sh

CMD ["/opt/build_docker.sh"]
