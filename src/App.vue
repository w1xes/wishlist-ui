<script setup lang="ts">
import { onMounted, ref } from 'vue'

interface Wish {
  id: number
  title: string
}

const apiUrl = (import.meta.env.VITE_API_BASE ?? 'http://localhost:8000').replace(/\/$/, '')
const wishes = ref<Wish[]>([])
const title = ref('')
const error = ref('')
const loading = ref(true)
const saving = ref(false)

async function loadWishes() {
  try {
    const response = await globalThis.fetch(`${apiUrl}/items`)
    if (!response.ok) throw new Error('List request failed')
    wishes.value = await response.json()
  } catch {
    error.value = 'Не вдалося завантажити список. Оновіть сторінку, щоб спробувати ще раз.'
  } finally {
    loading.value = false
  }
}

async function addWish() {
  const trimmedTitle = title.value.trim()
  if (!trimmedTitle || saving.value) return

  saving.value = true
  error.value = ''
  try {
    const response = await globalThis.fetch(`${apiUrl}/items`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title: trimmedTitle }),
    })
    if (!response.ok) throw new Error('Create request failed')
    wishes.value.unshift(await response.json())
    title.value = ''
  } catch {
    error.value = 'Не вдалося додати бажання.'
  } finally {
    saving.value = false
  }
}

async function removeWish(wish: Wish) {
  if (saving.value) return

  saving.value = true
  error.value = ''
  try {
    const response = await globalThis.fetch(`${apiUrl}/items/${wish.id}`, { method: 'DELETE' })
    if (!response.ok) throw new Error('Delete request failed')
    wishes.value = wishes.value.filter((item) => item.id !== wish.id)
  } catch {
    error.value = 'Не вдалося видалити бажання.'
  } finally {
    saving.value = false
  }
}

onMounted(loadWishes)
</script>

<template>
  <main class="min-h-screen bg-stone-100 px-5 py-14 text-stone-900 sm:py-24">
    <section class="mx-auto max-w-xl rounded-2xl border border-stone-200 bg-white p-6 sm:p-9">
      <h1 class="mb-8 text-3xl font-semibold tracking-tight sm:text-4xl">
        Список бажань
      </h1>

      <form @submit.prevent="addWish">
        <label
          for="wish-title"
          class="mb-2 block text-sm font-medium"
        >Нове бажання</label>
        <div class="flex flex-col gap-2 sm:flex-row">
          <input
            id="wish-title"
            v-model="title"
            type="text"
            required
            maxlength="120"
            :disabled="loading || saving"
            class="min-w-0 flex-1 rounded-lg border border-stone-300 px-3 py-2 outline-emerald-700"
          >
          <button
            type="submit"
            :disabled="loading || saving || !title.trim()"
            class="rounded-lg bg-emerald-800 px-4 py-2 font-medium text-white hover:bg-emerald-900 disabled:opacity-50"
          >
            Додати
          </button>
        </div>
      </form>

      <p
        v-if="error"
        role="alert"
        class="mt-5 text-sm text-red-700"
      >
        {{ error }}
      </p>
      <p
        v-if="loading"
        role="status"
        class="mt-8 text-stone-600"
      >
        Завантаження…
      </p>
      <ul
        v-else-if="wishes.length"
        aria-label="Збережені бажання"
        class="mt-7 divide-y divide-stone-200 border-y border-stone-200"
      >
        <li
          v-for="wish in wishes"
          :key="wish.id"
          class="flex items-center justify-between gap-4 py-3"
        >
          <span class="min-w-0 wrap-break-word">{{ wish.title }}</span>
          <button
            type="button"
            :disabled="saving"
            :aria-label="`Видалити ${wish.title}`"
            class="rounded px-2 py-1 text-sm text-red-700 hover:bg-red-50 disabled:opacity-50"
            @click="removeWish(wish)"
          >
            Видалити
          </button>
        </li>
      </ul>
      <p
        v-else-if="!error"
        class="mt-8 text-stone-600"
      >
        Список ще порожній.
      </p>
    </section>
  </main>
</template>
