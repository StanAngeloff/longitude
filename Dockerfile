FROM ubuntu:18.04

MAINTAINER Stan Angeloff <stanimir@angeloff.name>

RUN mkdir -p /home/maximus \
	&& useradd --uid 1000 --user-group -G sudo --shell /bin/bash --home-dir /home/maximus maximus 1>/dev/null \
	&& chown maximus:maximus /home/maximus \
	&& apt-get -q update \
	&& apt-get install -y -q software-properties-common \
	&& apt-add-repository -y --update ppa:ansible/ansible \
	&& apt-get install -y -q ansible sudo \
	&& sed -e "s@^%sudo.*@%sudo ALL=(ALL:ALL) NOPASSWD: ALL@" -i /etc/sudoers \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /home/maximus/longitude

ENV IS_DOCKERIZED=1

USER maximus

VOLUME /home/maximus/longitude

ENTRYPOINT ["ansible-playbook", "longitude.playbook.yml", "--diff"]
