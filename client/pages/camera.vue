<template>
    <div>
        <h1>Camera Streaming</h1>
        <video ref="videoRef" autoplay></video>
        <canvas ref="canvasRef"></canvas>
    </div>
</template>

<script>
export default {
    name: 'CameraStreaming',
    data() {
        return {
            video: null,
            ws: null,
        }
    },
    mounted() {
        this.setupCamera();
        this.setupWebSocket();
        //this.sendFrame();
    },
    methods: {
        setupCamera() {
            this.video = this.$refs.videoRef;
            if(navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
                navigator.mediaDevices.getUserMedia({ 
                    video: true,
                    audio: false,
                 }).then(stream => {
                    this.video.srcObject = stream;
                    this.video.play();
                }).catch(error => {
                    console.error("カメラにアクセスできませんでした:", error);
                });
            } else {
                console.warn("お使いのブラウザにサポートされていません。");
            }
        },
        setupWebSocket() {
            this.ws = new WebSocket("ws://localhost:4000/socket/websocket");
            this.ws.onopen = () => {
                console.log("WebSocketに接続しました。");

                const request = {
                    topic: "camera:lobby",
                    ref: 1,
                    payload: {
                    },
                    event: "phx.join"
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
        /*
        sendFrame() {
            setInterval(() => {                
                const request = {
                    topic: "camera:lobby",
                    ref: 1,
                    payload: {
                    },
                    event: "phx.join"
                };

                if (this.ws && this.ws.readyState === WebSocket.OPEN) {
                    this.ws.send(JSON.stringify(request));
                }
            }, 100);
        },*/
    }
}
</script>