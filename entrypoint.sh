#!/bin/sh

# Создаем пользователя для прокси, если переданы переменные окружения
if [ -n "$PROXY_USER" ] && [ -n "$PROXY_PASSWORD" ]; then
    # Проверяем, существует ли пользователь
    if ! id "$PROXY_USER" >/dev/null 2>&1; then
        echo "Creating proxy user: $PROXY_USER"
        adduser -S -H $PROXY_USER
        echo "$PROXY_USER:$PROXY_PASSWORD" | chpasswd
    fi
fi

# Запускаем Dante SOCKS сервер
exec "$@"
