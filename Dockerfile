FROM tensorflow/tensorflow:1.9.0-devel-gpu-py3

MAINTAINER arbin.timilsina@gmail.com

# for system
ENV XDG_RUNTIME_DIR=/tmp/$USER

# for ROOT
ENV ROOTSYS=/usr/local/root
ENV PATH=${ROOTSYS}/bin:${PATH}
ENV LD_LIBRARY_PATH=${ROOTSYS}/lib:${LD_LIBRARY_PATH}
ENV PYTHONPATH=${ROOTSYS}/lib:${PYTHONPATH}

# apt-get
RUN apt-get -y update && \
    apt-get -y install dpkg-dev \
    make \
    cmake \
    g++ \   
    gcc \
    libx11-dev \
    libxpm-dev \
    libxft-dev \
    libxext-dev \
    binutils \   
    libqt4-dev \
    python3-dev \
    python3-tk \
    python3-pip \
    git \
    wget \
    emacs \
    vim

# ROOT
RUN mkdir -p /tmp/root && \
    cd /tmp/root && \
    wget https://root.cern.ch/download/root_v6.14.02.source.tar.gz && \
    tar -xzf root_v6.14.02.source.tar.gz && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local/root -DGNUINSTALL=ON -Dminuit2:BOOL=ON $PWD/root-6.14.02 && \
    cmake --build . --target install -- -j4 && \
    rm -rf /tmp/root && \
    apt-get autoremove -y && apt-get clean -y

# pip basics- pip3 breaks the build- https://github.com/pypa/pip/issues/5599 so using python -m pip instead
RUN python -m pip install --upgrade pip
RUN python -m pip install --upgrade setuptools
RUN python -m pip install numpy wheel zmq six pygments pyyaml cython gputil psutil humanize h5py tqdm
RUN python -m pip install matplotlib pandas scikit-image scikit-learn Pillow opencv-python
RUN python -m pip install jupyter notebook

# keras
RUN python -m pip install keras

# Directory structure
RUN mkdir /work
RUN mkdir /scratch
RUN mkdir /data
RUN mkdir /app
WORKDIR /work

# Ports
EXPOSE 6006
EXPOSE 8888