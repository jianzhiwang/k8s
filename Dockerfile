
FROM wangzj.club/nginx/nginx as base  # 不指定版本就是nginx:latest
# 补充:如果本地镜像仓库没有，则从远程下载-->前提是做好docker login
# 时区
ARG Asia/Shanghai
#  ldd /usr/sbin/httpd --->参照httpd来理解nginx所需要的动态连接库
RUN mkdir -p /opt/var/cache/nginx && \
        cp -a --parents /usr/lib/nginx /opt && \
        cp -a --parents /usr/share/nginx /opt && \
        cp -a --parents /var/log/nginx /opt && \
        cp -aL --parents /var/run /opt && \
        cp -a --parents /etc/nginx /opt && \
        cp -a --parents /etc/passwd /opt && \
        cp -a --parents /etc/group /opt && \
        cp -a --parents /usr/sbin/nginx /opt && \
        cp -a --parents /lib/x86_64-linux-gnu/libpcre.so.* /opt && \
        cp -a --parents /lib/x86_64-linux-gnu/libz.so.* /opt && \
        cp -a --parents /lib/x86_64-linux-gnu/libc.so.* /opt && \
        cp -a --parents /lib/x86_64-linux-gnu/libdl.so.* /opt && \
        cp -a --parents /lib/x86_64-linux-gnu/libpthread.so.* /opt && \
        cp -a --parents /lib/x86_64-linux-gnu/libcrypt.so.* /opt && \
        cp -a --parents /usr/lib/x86_64-linux-gnu/libssl.so.* /opt && \
        cp -a --parents /usr/lib/x86_64-linux-gnu/libcrypto.so.* /opt && \
        cp /usr/share/zoneinfo/${TIME_ZONE:-ROC} /opt/etc/localtime
# 多个&&-->层压缩！
FROM gcr.io/distroless/base
COPY --from=base /opt /
EXPOSE 80
VOLUME ["/usr/share/nginx/html"] # nginx默认的资源目录
ENTRYPOINT ["nginx", "-g", "daemon off;"]
