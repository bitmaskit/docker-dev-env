FROM ubuntu:20.04

ENV TZ=Europe/Sofia
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update && apt -y upgrade \
	bash-completion \
	build-essential \
	curl \
	git \
	git-core \
	golang \
	htop \
	locales \
	man \
	nmap \
	python3-pip \
	ruby-full \
	strace \
	sudo \
	tig \
	vim \
	nano \
	wget

RUN locale-gen en_US.UTF-8
RUN adduser --disabled-password --gecos '' ubuntu
RUN adduser ubuntu sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ubuntu
# Hush login messages
RUN touch ~/.hushlogin

# Add Nano config
RUN mkdir -p ~/.dotfiles/nano/bck
ARG NANORC
RUN test "$NANORC" && curl -sL $NANORC -o ~/.nanorc || :
# Linux specific
RUN test -f ~/.nanorc && sed -i 's+local/share+share+g' ~/.nanorc

WORKDIR /home/ubuntu
