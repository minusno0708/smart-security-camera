<template>
    <h1>API Connection</h1>
    <button @click="sendMessage">Send</button>
    <p>{{ message }}</p>
</template>

<script setup>
const ws = ref(null);

const channel_id = ref("1");
const message = ref("Not Recieved")

onMounted(() => {
    setupWebSocket();
    recieveMessage();
});

onBeforeUnmount(() => {
    if (ws.value) {
        ws.value.close();
    }
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

const sendMessage = () => {
    const request = {
        topic: `camera:${channel_id.value}`,
        ref: 1,
        payload: {
            body: {
                message: "Connection Test"
            }
        },
        event: "connect_api"
    };

    if (ws.value && ws.value.readyState === WebSocket.OPEN) {
        ws.value.send(JSON.stringify(request));
    }
}

const recieveMessage = () => {
    ws.value.onmessage = event => {
        console.log("メッセージを受信しました。", event.data);

        try {
            message.value = JSON.parse(event.data).payload.response.body.message;
        } catch (err) {
            console.warn("受信データをJSONとしてパースできませんでした。");
        }
    };
}
</script>