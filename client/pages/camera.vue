<template>
    <h1>Camera Streaming</h1>

    <p>
    <input v-model="channel_id">
    <button @click="connectSocket">Connect</button>
    </p>

    <video ref="videoRef" autoplay></video>
    <canvas ref="canvasRef" style="display: none"></canvas>

    <p><NuxtLink to="/">Home</NuxtLink></p>
</template>

<script setup>
const channel_id = ref('')

const video = ref(null);
const ws = ref(null);

const videoRef = ref(null);
const canvasRef = ref(null);

onMounted(() => {
    setupCamera();
});

const setupCamera = () => {
    video.value = videoRef.value;
    if(navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
        navigator.mediaDevices.getUserMedia({ 
            video: true,
            audio: false,
            }).then(stream => {
            video.value.srcObject = stream;
            video.value.play();
        }).catch(error => {
            console.error("カメラにアクセスできませんでした:", error);
        });
    } else {
        console.warn("お使いのブラウザにサポートされていません。");
    }
}

const connectSocket = () => {
    setupWebSocket();
    sendFrame();
}   

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
    ws.value.onmessage = event => {
        console.log("メッセージを受信しました。", event.data);
    };
    ws.value.onclose = () => {
        console.log("WebSocketを切断しました。");
    };
}

const sendFrame = () => {
    const canvas = canvasRef.value;
    video.value.addEventListener('loadedmetadata', () => {
        canvas.width = video.value.videoWidth;
        canvas.height = video.value.videoHeight;
    });

    const ctx = canvas.getContext('2d');

    setInterval(() => {   
        ctx.drawImage(video.value, 0, 0, video.value.videoWidth, video.value.videoHeight);
        const frameData = canvas.toDataURL('image/jpeg');

        const request = {
            topic: `camera:${channel_id.value}`,
            ref: 1,
            payload: {
                message: frameData
            },
            event: "shout"
        };

        if (ws.value && ws.value.readyState === WebSocket.OPEN) {
            ws.value.send(JSON.stringify(request));
        }
    }, 100);
}
</script>