<template>
    <div>
        <h1>Video Watching</h1>
        <NuxtLink to="/">Home</NuxtLink>
    </div>
</template>


<script>
export default {
    name: 'VideoWatching',
    data() {
        return {
            ws: null,
        }
    },
    mounted() {
        this.setupWebSocket();
    },
    methods: {
        setupWebSocket() {
            this.ws = new WebSocket("ws://localhost:4000/socket/websocket");
            this.ws.onopen = () => {
                console.log("WebSocketに接続しました。");

                const request = {
                    topic: "camera:lobby",
                    ref: 1,
                    payload: {
                    },
                    event: "phx_join"
                };
                this.ws.send(JSON.stringify(request));
            };
            this.ws.onmessage = event => {
                console.log("メッセージを受信しました。", event.data);
            };
            this.ws.onclose = () => {
                console.log("WebSocketを切断しました。");
            };
        },
    }
}
</script>