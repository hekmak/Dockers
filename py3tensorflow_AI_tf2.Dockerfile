FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu16.04
MAINTAINER Hamid Hekmatian <hamid.hekmatian@havalus.com>

# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 \
        python \
        python3-pip \
        python-pip \
        python3-setuptools \
        python-setuptools \
        python3-tk \ 
        libglib2.0-0 \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip
RUN pip install --upgrade pip
RUN pip3 install \
        Pillow \
        ipykernel \
        jupyter \
        numpy \
        scipy \
        sklearn \
        opencv-python \
        opencv-contrib-python \
        opencv-python-headless \
        matplotlib \
        && \
    python3 -m ipykernel.kernelspec

# Install TensorFlow
RUN pip3 --no-cache-dir install --ignore-installed \
	tensorflow-gpu==2.0.0rc2

RUN pip3 install keras

# Create notebooks folder.
RUN mkdir /notebooks

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

WORKDIR "/notebooks"

