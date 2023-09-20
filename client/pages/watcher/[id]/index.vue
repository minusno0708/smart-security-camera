<template>
    <div>
        <h1>Video Watching</h1>
        <canvas ref="canvasRef"></canvas>
        <NuxtLink to="/">Home</NuxtLink>
    </div>
</template>


<script setup>
const route = useRoute();
const camera_id = route.params.id;

const frame = ref(null);
const ws = ref(null);
const canvasRef = ref(null);

onMounted(() => {
    frame.value = new Image();

    setupWebSocket();
    recieveImage();
    displayFrame();
});

const setupWebSocket = () => {
    ws.value = new WebSocket("ws://localhost:4000/socket/websocket");
    ws.value.onopen = () => {
        const request = {
            topic: `camera:${camera_id}`,
            ref: 1,
            payload: {
            },
            event: "phx_join"
        };
        ws.value.send(JSON.stringify(request));

        console.log("WebSocketに接続しました。");
    };
    ws.value.onclose = () => {
        console.log("WebSocketを切断しました。");
    };
}

const recieveImage = () => {
    ws.value.onmessage = event => {
        //console.log("メッセージを受信しました。", event.data);

        try {
            frame.value.src = JSON.parse(event.data).payload.message;
        } catch (err) {
            console.warn("受信データをJSONとしてパースできませんでした。");
        }
    };
}

const displayFrame = () => {
    const canvas = canvasRef.value;
    const ctx = canvas.getContext('2d');

    frame.value.onload = () => {
        canvas.width = frame.value.width;
        canvas.height = frame.value.height;
        ctx.drawImage(frame.value, 0, 0, frame.value.width, frame.value.height);
    };
}
</script>