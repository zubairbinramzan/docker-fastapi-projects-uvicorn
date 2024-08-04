# A Dockerfile is a text document that contains all the commands
# a user could call on the command line to assemble an image.

FROM nvidia/cuda:11.2.1-cudnn8-runtime-ubuntu20.04

# Basic Debian with Python 3.9.4 installation
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.9 \
    python3.9-dev \
    python3-pip \
    build-essential \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.9.4 and set it as default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1 \
    && update-alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3.9 1

# Create build directory
RUN mkdir -p /build

# Set the working directory
WORKDIR /build

# Copy all files from current directory to the working directory
COPY . .

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Install CUDA and cuDNN
RUN apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub \
    && echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list \
    && apt-get update && apt-get install -y --no-install-recommends \
    cuda-11-2 \
    libcudnn8=8.1.1.33-1+cuda11.2 \
    libcudnn8-dev=8.1.1.33-1+cuda11.2 \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for CUDA and cuDNN
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH
ENV CUDA_HOME /usr/local/cuda

# Expose port 80
EXPOSE 80

# Set the working directory to /build/app
WORKDIR /build/app

# Command to run the uvicorn server
CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
