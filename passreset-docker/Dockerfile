# This is cribbed from linuxkit/getty

FROM linuxkit/alpine:e2391e0b164c57db9f6c4ae110ee84f766edc430 AS mirror

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk add --no-cache --initdb -p /out \
    alpine-baselayout \
    busybox \
    tini \
    util-linux \
    && true
RUN mv /out/etc/apk/repositories.upstream /out/etc/apk/repositories

RUN cp /out/usr/bin/setsid /out/usr/bin/setsid.getty
RUN rm -rf /out/etc/inittab

FROM scratch
ENTRYPOINT ["/sbin/tini","-s","-v","--"]
WORKDIR /
COPY --from=mirror /out/ /
COPY usr/ /usr/
COPY etc/ /etc/

# This CMD doesn't get run. tini instead runs the shell script at /etc/inti.d/001-resetpass
CMD ["/usr/bin/chpass.sh"]
