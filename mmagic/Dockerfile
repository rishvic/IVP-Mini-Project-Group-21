ARG PYTORCH="2.2.2"
ARG CUDA="12.1"
ARG CUDA_ALIAS="121"
ARG CUDNN="8"
ARG MMCV="2.1.0"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0 8.6+PTX"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
ENV CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC
RUN apt-get update && apt-get install -y git ninja-build libglib2.0-0 libsm6 libxrender-dev libxext6 libgl1-mesa-glx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install mmagic
RUN conda clean --all
COPY ./mmagic /mmagic
WORKDIR /mmagic
ENV FORCE_CUDA="1"
RUN pip install openmim
RUN mim install mmcv==2.1.0
RUN pip install -r requirements.txt
RUN pip install --no-cache-dir -e .
