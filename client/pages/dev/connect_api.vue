<template>
    <h1>API Connection</h1>
    <button @click="changeStatus">Connect</button><br>

    <input v-on:change="uploadImage" type="file" name="file" accept="image/jpeg, image/png"><br>
    <img v-if="image" :src="image" alt="Uploaded preview" width="600"><br>
    <p>Image:{{ image }}</p>
    
    <button @click="sendMessage">Send</button>
    <p>Status:{{ status }}</p>
    <p>{{ message }}</p>
</template>

<script setup>

const ws = ref(null);
const message = ref("");

const status = ref(0);
const image = ref(null);

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

const uploadImage = (e) => {
    let files = e.target.files;
    e.preventDefault(); 

    if(files && files.length > 0){
        getFileAsBase64(files[0])
        .then((imgDataBase64)=>{
            image.value = imgDataBase64;
        });
    } else {
        console.log("error")
    }
}

const getFileAsBase64 = (file) => new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => resolve(reader.result);
    reader.onerror = error => reject(error);
})
</script>