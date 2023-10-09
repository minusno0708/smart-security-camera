<template>
    <h1>API Connection</h1>
    <p>Message: {{ message }}</p>
</template>

<script setup>

const ws = ref(null);
const message = ref("");

onMounted(() => {
    setupWebSocket();
});

const setupWebSocket = () => {
    ws.value = new WebSocket("ws://localhost:8000/ws");
    ws.value.onopen = () => {
        console.log("WebSocketに接続しました。");

        const request = "Hello, Detecto API";

        ws.value.send(JSON.stringify(request));
    };
    ws.value.onmessage = event => {
        console.log("メッセージを受信しました。", event.data);

        try {
          message.value = event.data;
        } catch (error) {
            console.log(error);
        }
    };
    ws.value.onclose = () => {
        console.log("WebSocketを切断しました。");
    };
}
</script>