FROM python:3.9.0

ENV APP_HOME /app
WORKDIR ${APP_HOME}

COPY . ./

# Install Ubuntu dependencies
# libopencv-dev = opencv dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        tzdata \
        libopencv-dev \ 
        build-essential \
        libssl-dev \
        libpq-dev \
        libcurl4-gnutls-dev \
        libexpat1-dev \
        gettext \
        unzip \
        supervisor \
        python3-setuptools \
        python3-pip \
        python3-dev \
        python3-venv \
        python3-urllib3 \
        git \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN pip install pip pipenv --upgrade

# sklearn opencv, numpy, and pandas
RUN pip install scikit-learn opencv-contrib-python numpy pandas

# tensorflow (including Keras)
RUN pip install tensorflow keras

# pytorch (cpu)
RUN apt-get update && apt-get -y install gcc mono-mcs && rm -rf /var/lib/apt/lists/*
RUN pip install torch==1.10.1+cpu torchvision==0.11.2+cpu torchaudio==0.10.1 -f https://download.pytorch.org/whl/torch_stable.html

# fastai
RUN pip install fastai

# Project installs
RUN pipenv install --skip-lock --system --dev

LABEL org.opencontainers.image.source https://github.com/JayantGoel001/Jupyter-x-Docker
LABEL org.opencontainers.image.description Jupyter Notebook Server built with Docker & deployed on Heroku.

RUN [ "chmod", "+x", "./scripts/entrypoint.sh" ]

CMD [ "./scripts/entrypoint.sh" ]
