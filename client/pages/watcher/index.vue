<template>
    <h1>Watcher</h1>

    <input v-model="camera_id">
    <button @click="send">Send</button>

    <p><NuxtLink to="/">Home</NuxtLink></p>
</template>

<script setup lang="ts">
const router = useRouter()

const camera_id = ref<string>('');

const send = () => {
    router.push(`/watcher/${camera_id.value}`)
}
</script>