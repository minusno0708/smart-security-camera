<template>
    <div>
        <h1>Video Watching</h1>
        <canvas ref="canvasRef"></canvas>
        <NuxtLink to="/">Home</NuxtLink>
    </div>
</template>


<script>
export default {
    name: 'VideoWatching',
    data() {
        return {
            frame: new Image(),
            ws: null,
        }
    },
    mounted() {
        this.setupWebSocket();
        this.recieveImage();
        this.displayFrame();
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
            this.ws.onclose = () => {
                console.log("WebSocketを切断しました。");
            };
        },
        recieveImage() {
            this.ws.onmessage = event => {
                //console.log("メッセージを受信しました。", event.data);

                try {
                    this.frame.src = JSON.parse(event.data).payload.message;
                } catch (err) {
                    console.warn("受信データをJSONとしてパースできませんでした。");
                }
            };
        },
        displayFrame() {
            const canvas = this.$refs.canvasRef;
            const ctx = canvas.getContext('2d');

            this.frame.onload = () => {
                canvas.width = this.frame.width;
                canvas.height = this.frame.height;
                ctx.drawImage(this.frame, 0, 0, this.frame.width, this.frame.height);
            };
        },
    }
}
</script>