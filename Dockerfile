FROM tensorflow/tensorflow:latest-gpu


USER root


# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DOCKER 1


RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install net-tools
RUN apt install iputils-ping -y

RUN apt-get update && \
    apt-get install -y libgl1-mesa-glx
RUN apt-get install ffmpeg libsm6 libxext6  -y
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y



# ZSH
RUN apt-get update && apt-get install -y zsh
RUN apt-get install -y wget
# Uses "robbyrussell" theme (original Oh My Zsh theme), with no plugins
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t aussiegeek
# customizations
RUN apt-get install figlet -y
RUN echo "alias ll='ls -l'" >> ~/.zshrc



# Limpiar caché y archivos temporales
RUN rm -rf /var/cache/apk/*
RUN rm -rf /tmp/*
RUN apt-get clean



# ********************************************************
# ************************* ssh **************************
# ********************************************************
USER root

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root123' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22


# ********************************************************
# ********************** app python **********************
# ********************************************************


RUN pip install --upgrade pip

WORKDIR /app

COPY ./requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt


RUN echo "figlet ssh-docker" >> ~/.zshrc
RUN echo "figlet ssh-docker" >> ~/.bashrc


CMD ["/usr/sbin/sshd", "-D"]