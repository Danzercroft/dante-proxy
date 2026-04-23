# Dante SOCKS5 Proxy Docker
Проект для сборки SOCKS5 прокси-сервера [Dante](https://www.inet.no/dante/) из исходного кода в минимальном Docker-контейнере на базе Alpine.

В проекте уже по умолчанию настроена базовая PAM-авторизация. Чтобы задать логин и пароль, достаточно передать их как переменные окружения.

## Запуск с помощью Docker Compose

Самый простой способ собрать и запустить:

```bash
docker-compose up -d --build
```

Прокси будет доступен на порту `1080`.
По умолчанию настроены логин `admin` и пароль `secretpassword` (вы можете поменять их в `docker-compose.yml`).

## Запуск с помощью Docker CLI

Сборка образа:
```bash
docker build -t dante-proxy .
```

Запуск контейнера с указанием логина и пароля:
```bash
docker run -d --name dante-proxy \
  -p 1080:1080 \
  -e PROXY_USER=myuser \
  -e PROXY_PASSWORD=mypass \
  --restart unless-stopped dante-proxy
```
