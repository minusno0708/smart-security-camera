<template>
    <h1>Camera Streaming</h1>
    <div>
        <video id="video"></video>
    </div>
</template>

<script>
export default {
    mounted() {
        const video = document.getElementById('video');
        navigator.mediaDevices
        .getUserMedia({
            video: true,
            audio: true,
        })
        .then((stream) => {
            video.srcObject = stream;
            video.play();
        })
        .catch((e) => {
            console.log(e);
        });
    },
};
</script>