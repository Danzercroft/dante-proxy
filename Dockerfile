FROM alpine:3.19 AS builder

ENV DANTE_VER=1.4.4

# Устанавливаем зависимости для сборки
RUN apk add --no-cache \
    build-base \
    curl \
    linux-pam-dev \
    flex \
    bison

# Скачиваем, конфигурируем и собираем Dante
RUN curl -O https://www.inet.no/dante/files/dante-${DANTE_VER}.tar.gz && \
    tar xzf dante-${DANTE_VER}.tar.gz && \
    cd dante-${DANTE_VER} && \
    ./configure \
        --prefix=/usr \
        --sysconfdir=/etc \
        --localstatedir=/var \
        --disable-client \
        --without-libwrap \
        --without-bsdauth \
        --without-gssapi \
        --without-krb5 \
        --without-upnp \
        ac_cv_func_sched_setscheduler=no && \
    make -j$(nproc) && \
    make install

# Создаем финальный минимальный образ
FROM alpine:3.19

# Устанавливаем linux-pam для авторизации
RUN apk add --no-cache linux-pam

# Копируем собранный бинарник из builder'а
COPY --from=builder /usr/sbin/sockd /usr/sbin/sockd

# Копируем конфигурационный файл
COPY sockd.conf /etc/sockd.conf
COPY sockd.pam /etc/pam.d/sockd

# Создаем пользователя nobody, если его нет (в alpine обычно есть) и необходимые директории
RUN mkdir -p /var/run/sockd

EXPOSE 1080

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["sockd", "-f", "/etc/sockd.conf", "-N", "1"]