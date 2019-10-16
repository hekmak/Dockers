FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu16.04

MAINTAINER Hamid Hekmatian <hamid.hekmatian@havalus.com>

#ARG TENSORFLOW_VERSION=1.6.0
#ARG TENSORFLOW_ARCH=gpu

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
	tensorflow-gpu==1.14.0

# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/

# Copy sample notebooks.
COPY notebooks /notebooks

# Jupyter has issues with being run directly:
#   https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY run_jupyter.sh /


# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

WORKDIR "/notebooks"

CMD ["/run_jupyter.sh", "--allow-root"]

