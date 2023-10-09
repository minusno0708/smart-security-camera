<template>
    <h1>API Connection</h1>
    <button @click="changeStatus">Connect</button>
    <button @click="sendMessage">Send</button>
    <p>Status:{{ status }}</p>
    <p>{{ message }}</p>
</template>

<script setup>

const ws = ref(null);
const message = ref("");

const status = ref(0);

const changeStatus = () => {
    if (status.value == 0) {
        status.value = 1;
        setupWebSocket();
    } else {
        status.value = 0;
        ws.value.close();
    }
}

const setupWebSocket = () => {
    ws.value = new WebSocket("ws://localhost:8000/ws");
    ws.value.onopen = () => {
        console.log("WebSocketに接続しました。");
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

const sendMessage = () => {
    try {
        const request = "Hello, Detect API";
        ws.value.send(JSON.stringify(request));
    } catch (error) {
        console.log(error);
    }
}
</script>