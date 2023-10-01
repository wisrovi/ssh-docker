FROM python:3.8

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install net-tools
RUN apt install iputils-ping -y


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

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DOCKER 1

COPY ./requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

COPY ./app /app

EXPOSE 8000

CMD ["/usr/sbin/sshd", "-D"]