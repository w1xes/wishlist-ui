# Wishlist UI

Vue 3, TypeScript і Tailwind. Інтерфейс завантажує список із [Wishlist API](https://github.com/w1xes/wishlist-api) після відкриття сторінки. Запустіть API перед використанням інтерфейсу.

```powershell
Copy-Item .env.example .env
docker compose up -d --wait
```

Відкрийте [127.0.0.1:5174](http://127.0.0.1:5174). Адресу API для браузера задає `VITE_API_URL` у `.env`.
