# Wishlist UI

Vue 3, TypeScript і Tailwind. Інтерфейс завантажує список із [Wishlist API](https://github.com/w1xes/wishlist-api) після відкриття сторінки. Запустіть API перед використанням інтерфейсу.

```powershell
Copy-Item .env.example .env
docker compose up -d --wait
```

Відкрийте [127.0.0.1:5174](http://127.0.0.1:5174). Адресу API для браузера задає `VITE_API_BASE` у `.env`.

## Образ для production

`Dockerfile` складається з двох етапів. Етап `build` (Node 24) виконує `npm ci` і `npm run build`. Фінальний образ містить лише nginx і каталог `dist/`, без Node, `node_modules` і вихідного коду. nginx віддає `index.html` для будь-якого маршруту, тому перезавантаження сторінки не дає 404.

```powershell
docker build --build-arg VITE_API_BASE=http://localhost:8000 -t wishlist-ui .
docker run --rm -p 127.0.0.1:8081:80 wishlist-ui
```

Відкрийте [localhost:8081](http://localhost:8081).

Адресу API вбудовує Vite у JavaScript-файл під час збирання (`import.meta.env.VITE_API_BASE`). Змінна середовища в `docker run` або в `compose.yaml` уже нічого не змінює. Щоб змінити адресу, перезберіть образ з іншим `--build-arg`. Це адреса, яку браузер відкриває з машини користувача, тому вона виглядає як `http://localhost:8000`, а не `http://api:8000`. Без аргументу використовується `http://localhost:8000`.

Файли `.env*` не потрапляють у контекст збирання (`.dockerignore`), інакше Vite вбудував би з них значення в пакет.

Розмір образів, вимірювання й докази перевірок описані в [docs/containers.md](docs/containers.md).

## Увесь стек

Postgres, Redis, API та UI запускаються однією командою з `compose.yaml` у репозиторії [wishlist-api](https://github.com/w1xes/wishlist-api). Образ UI збирається там із цього репозиторію (теки `wishlist-api` і `wishlist-ui` лежать поруч). Файл `compose.yaml` у цьому репозиторії лишається лише для розробки з Vite на порту 5174.
