FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH=${PATH}:/usr/local/cuda/bin
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda/lib64

WORKDIR /root

RUN apt-get update && apt-get update -y
RUN apt-get install -y build-essential wget git

# install conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py37_4.10.3-Linux-x86_64.sh
RUN bash Miniconda3-py37_4.10.3-Linux-x86_64.sh -b
ENV PATH="/root/miniconda3/bin:${PATH}"
RUN rm Miniconda3-py37_4.10.3-Linux-x86_64.sh
RUN conda update -y --freeze-installed conda

RUN python -m pip install torch==1.4.0 torchvision==0.5.0

RUN git clone https://github.com/albchim/hand_object_detector.git

RUN cd hand_object_detector && pip install -r requirements.txt
RUN cd hand_object_detector/lib && python setup.py build develop

# download pretrained model
RUN pip install gdown
RUN cd hand_object_detector && mkdir models && cd models && gdown https://drive.google.com/u/0/uc?id=1H2tWsZkS7tDF8q1-jdjx6V9XrK25EDbE