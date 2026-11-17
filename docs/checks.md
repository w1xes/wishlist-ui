# Перевірки Wishlist UI

## Обов’язкові перевірки

Для `main` діє ruleset із обов’язковим pull request, актуальністю щодо `main`, скиданням застарілих схвалень і забороною видалення та force-push. Список обходу порожній. В індивідуальній роботі кількість обов’язкових схвалень дорівнює нулю. Для злиття мають пройти `UI lint`, `UI typecheck` і `UI build`. [Налаштування ruleset](https://github.com/w1xes/wishlist-ui/rules/27492372)

1. На коміті `da72788` GitHub повернув `mergeStateStatus: BLOCKED` для PR №1 після помилки ESLint. Перевірку типів і збірку пропустили. [PR №1](https://github.com/w1xes/wishlist-ui/pull/1) · [Невдалий прогін](https://github.com/w1xes/wishlist-ui/actions/runs/44167114420)
2. Крок `Run npm run lint` повідомив, що невикористана змінна `brokenDemo` у `src/main.ts:5:7` порушила правило `@typescript-eslint/no-unused-vars`. [Журнал ESLint](https://github.com/w1xes/wishlist-ui/actions/runs/44167114420/job/134336007140#step:5:1)
3. У тому самому PR коміт `b3d7f16` прибрав зайву змінну. Лінтер, перевірка типів і збірка пройшли, а GitHub повернув `mergeStateStatus: CLEAN`. [Виправлення](https://github.com/w1xes/wishlist-ui/pull/1/commits/b3d7f16ce3e29bdb6fbd4c2fa4036a6cbf2e0500) · [Успішний прогін](https://github.com/w1xes/wishlist-ui/actions/runs/44167372347)

Стан злиття перевірено через GitHub CLI. Знімки екрана для завдання 4 ще потрібно додати.

## Вимірювання кешу

Дві спроби того самого прогону на `main`, коміт `e1097ff`. Час узято з міток початку й завершення спроб у GitHub Actions.

| Прогін | Час |
|---|---:|
| [Без кешу](https://github.com/w1xes/wishlist-ui/actions/runs/44166606744/attempts/1) | 87 с |
| [З кешем](https://github.com/w1xes/wishlist-ui/actions/runs/44166606744/attempts/2) | 73 с |

Найдовший крок — `Run actions/setup-node@v6` у `UI typecheck`, 10 с у другій спробі.

У першій спробі `UI lint` заповнив кеш npm. Наступні завдання першої спроби та всі завдання другої відновили його. Повний прогін скоротився на 14 с.

## Нічний аудит

Окремий workflow `UI dependency audit` запускає `npm audit`. Ручний контрольний запуск виявив вразливість у транзитивній залежності `picomatch`. Аудит завершився з помилкою, а обов’язкові перевірки PR пройшли. [Результат аудиту](https://github.com/w1xes/wishlist-ui/actions/runs/44167184838) · [Звіт GitHub Advisory](https://github.com/advisories/GHSA-fc5q-39xc-vjpf)
