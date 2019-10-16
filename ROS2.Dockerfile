FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

MAINTAINER Hamid Hekmatian <hamid.hekmatian@havalus.com>


# ROS 2
# Set the locale
RUN apt-get clean && apt-get update && apt-get install -y locales

RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8

RUN apt update && apt install -y --no-install-recommends curl gnupg2 lsb-release
RUN curl http://repo.ros2.org/repos.key | apt-key add -
RUN sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'
#CMD ["sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'"]

# Pick up some TF dependencies
RUN apt update && apt install -y --no-install-recommends --assume-yes \
        ros-dashing-desktop \
        ros-dashing-ros-base \
        python3-argcomplete \
        ros-dashing-rmw-opensplice-cpp \
        ros-dashing-rmw-connext-cpp 

#CMD ["source /opt/ros/dashing/setup.bash"]
RUN source /opt/ros/dashing/setup.bash
RUN echo "source /opt/ros/dashing/setup.bash" >> ~/.bashrc

# Install TensorFlow
RUN pip3 --no-cache-dir install --ignore-installed \
	tensorflow-gpu


#RUN pip3 install --upgrade pip
#RUN pip install --upgrade pip
#RUN pip3 install \
#        Pillow \
#        ipykernel \
#        jupyter \
#        && \
#    python3 -m ipykernel.kernelspec


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

