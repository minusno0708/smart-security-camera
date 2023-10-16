from fastapi import FastAPI, WebSocket

import base64

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Welcome to Detect API"}

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    while True:
        data = await websocket.receive_text()
        print(data[:50])

        try:
            image = base64.b64decode(data)
            await websocket.send_text(f"Recieve message was {data}")

        except Exception as e:
            await websocket.send_text(f"Error:{e}")