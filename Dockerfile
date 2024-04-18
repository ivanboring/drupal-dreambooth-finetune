FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04
LABEL maintainer="Hugging Face"
LABEL repository="diffusers"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y bash \
    build-essential \
    git \
    git-lfs \
    curl \
    ca-certificates \
    libsndfile1-dev \
    libgl1 \
    openssh-server \
    python3.10 \
    python3-pip \
    python3.10-venv && \
    rm -rf /var/lib/apt/lists

# make sure to use venv
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# pre-install the heavy dependencies (these can later be overridden by the deps from setup.py)
RUN python3 -m pip install --no-cache-dir --upgrade pip uv==0.1.11 && \
    python3 -m uv pip install --no-cache-dir \
    torch \
    torchvision \
    torchaudio \
    invisible_watermark && \
    python3 -m pip install --no-cache-dir \
    accelerate \
    datasets \
    hf-doc-builder \
    huggingface-hub \
    huggingface-cli \
    Jinja2 \
    librosa \
    numpy \
    scipy \
    tensorboard \
    transformers \
    pytorch-lightning

RUN git clone https://github.com/huggingface/diffusers && cd diffusers && pip install -e .

RUN cd diffusers && pip install -e .
RUN cd diffusers/examples/dreambooth && pip install -r requirements.txt

RUN accelerate config default

RUN mkdir new-model && mkdir training-data
COPY ./dreamon.sh /
RUN chmod +x dreamon.sh

# Make ssh available.
RUN mkdir /root/.ssh
COPY ./ssh.sh /
RUN chmod +x ssh.sh
RUN rm -f /etc/ssh/ssh_host_*

# Copy the config.
COPY default_config.yaml /root/.cache/huggingface/accelerate/default_config.yaml

# Copy the start file.
COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh
EXPOSE 22

# Copy the python command.
COPY create_repo.py /

CMD sh /ssh.sh && tail -f /dev/null
