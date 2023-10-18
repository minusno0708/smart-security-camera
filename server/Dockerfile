FROM python:3.11-slim-buster AS model-import

RUN pip install --upgrade pip && pip install onnx ultralytics && \
    apt-get update && apt-get install -y libgl1-mesa-glx libglib2.0-0 && \
    yolo task=detect mode=export model=yolov8n.pt format=onnx

FROM elixir:1.15.4-slim

WORKDIR /app

COPY . .
COPY --from=model-import yolov8n.onnx ./models

RUN apt-get update && apt-get install -y make gcc inotify-tools && \
    mix local.hex --force && \
    mix archive.install hex phx_new 1.7.7 --force
    