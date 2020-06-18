FROM tensorflow/tensorflow:2.2.0-gpu-jupyter

ARG INTERPRETER

ENV USER=ubuntu \
    UID=1000 \
    GID=1000 \
    DEBIAN_FRONTEND=noninteractive

RUN env DEBIAN_FRONTEND=noninteractive \
    add-apt-repository ppa:git-core/ppa -y \
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
         build-essential \
         openssh-server \
         git \
         locales \
         rsync \
         curl \
         wget \
         iputils-ping \
         telnet \
         screen \
         nano \
         vim \
         ${INTERPRETER} \
    && mkdir -p \
         /run/sshd \
         /home/"$USER"/.ssh \
    && rm -f /etc/ssh/ssh_host_*key* \
    && addgroup --gid "$GID" "$USER" \
    && adduser \
         --disabled-password \
         --gecos "" \
         --ingroup "$USER" \
         --uid "$UID" \
         --shell /bin/bash \
         "$USER" \
    && chmod 700 /home/"$USER"/.ssh \
    && chown $USER:$USER -R /home/"$USER" /tmp \
    && rm -rf \
        /var/lib/apt/lists/* \
        /var/cache/debconf \
        /tmp/* \
        /usr/local/bin/pip3 \
        /usr/local/bin/pip \
        /usr/bin/python3 \
    && apt-get clean \
    && ln -s /usr/local/bin/pip${INTERPRETER/python} /usr/local/bin/pip \
    && ln -s /usr/local/bin/pip${INTERPRETER/python} /usr/local/bin/pip3 \
    && ln -s /usr/bin/${INTERPRETER} /usr/bin/python3

RUN curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py \
    && ${INTERPRETER} /tmp/get-pip.py \
    && ${INTERPRETER} -m pip install tensorflow-gpu==2.2.0 \
    && rm -rf /tmp/get-pip.py

COPY sshd_config /home/"$USER"/.ssh/sshd_config
COPY config /home/"$USER"/.ssh/config
COPY bash.bashrc /etc/bash.bashrc

RUN ${INTERPRETER} -m pip install xgboost

RUN chmod 400 /home/"$USER"/.ssh/config \
    && chown -R $USER:$USER /home/"$USER"/.ssh

EXPOSE 2222 \
       8888 \
       6006

WORKDIR /tmp

USER $USER

CMD ["/bin/sh", "-c", "exit 0"]

