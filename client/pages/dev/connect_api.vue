<template>
    <h1>API Connection</h1>
</template>

<script setup>
const ws = ref(null);

onMounted(() => {
    setupWebSocket();
});

const setupWebSocket = () => {
    ws.value = new WebSocket("ws://localhost:4000/socket/websocket");
    ws.value.onopen = () => {
        console.log("WebSocketに接続しました。");

        const request = {
            topic: `camera:${channel_id.value}`,
            ref: 1,
            payload: {
            },
            event: "phx_join"
        };
        ws.value.send(JSON.stringify(request));
    };
    ws.value.onclose = () => {
        console.log("WebSocketを切断しました。");
    };
}
</script>