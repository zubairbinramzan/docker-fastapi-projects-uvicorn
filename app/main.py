from fastapi import FastAPI
import tensorflow as tf
import os

app = FastAPI()

# Ensure TensorFlow uses GPU
os.environ['CUDA_VISIBLE_DEVICES'] = '0'

# Function to print GPU memory usage
def print_gpu_usage():
    gpus = tf.config.list_physical_devices('GPU')
    for gpu in gpus:
        details = tf.config.experimental.get_memory_info(gpu.name)
        print(f"GPU {gpu.name}:")
        print(f"  Memory limit: {details['current']} bytes")
        print(f"  Memory allocated: {details['total']} bytes")

@app.get("/")
async def root():
    print_gpu_usage()
    return {"Uvicorn": "I'm alive", "GPU Usage": "Check console for details"}
