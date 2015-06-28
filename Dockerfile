FROM ubuntu:14.04

RUN apt-get -y update && apt-get -y upgrade && apt-get install -y g++ git gfortran python-pip wget python-dev

WORKDIR /opt/nvidia
ENV CUDA_RUN cuda_6.5.19_linux_64.run
ENV CUDA_URL http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/$CUDA_RUN
RUN wget -q $CUDA_URL && \
    chmod +x $CUDA_RUN && \
    mkdir installers && \
    ./$CUDA_RUN -extract=`pwd`/installers && \
    cd installers && \
    ./NVIDIA-Linux-x86_64-343.19.run -s -N --no-kernel-module && \
    ./cuda-linux64-rel-6.5.19-18849900.run -noprompt && \
    cd / && \
    rm -rf /opt/nvidia

RUN pip install numpy

WORKDIR /opt/cudnn
ENV CUDNN cudnn-6.5-linux-x64-v2
ADD $CUDNN.tgz /opt/cudnn/

ENV CUDA_ROOT /usr/local/cuda-6.5
ENV PATH $PATH:$CUDA_ROOT/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$CUDA_ROOT/lib64:$CUDA_ROOT/lib:/opt/cudnn/$CUDNN