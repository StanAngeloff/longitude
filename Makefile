.PHONY: usage ansible playbook docker-playbook

usage:
	@echo 'Usage: make [ ansible | playbook ]'

ansible:
	@sudo apt-get update
	@sudo apt-get install -y software-properties-common
	@sudo apt-add-repository -y --update ppa:ansible/ansible
	@sudo apt-get install -y ansible

playbook:
	ansible-playbook longitude.playbook.yml --ask-become-pass --diff

docker-playbook:
	@mkdir -p home
	@docker run \
		--rm --tty \
		--volume `pwd`/home:/home/stan \
		--volume `pwd`:/home/stan/longitude \
			ubuntu:16.04 \
				/bin/bash -c '\
					set -euo pipefail \
					&& useradd --uid $(shell id -u) --user-group -G sudo --shell /bin/bash --home-dir /home/stan stan 1>/dev/null \
					&& apt-get -q update \
					&& apt-get install -y -q software-properties-common \
					&& apt-add-repository -y --update ppa:ansible/ansible \
					&& apt-get install -y -q ansible sudo \
					&& sed -e "s@^%sudo.*@%sudo ALL=(ALL:ALL) NOPASSWD: ALL@" -i /etc/sudoers \
					&& su -lc " \
						cd longitude \
						&& env IS_DOCKERIZED=1 ansible-playbook longitude.playbook.yml --diff \
					" stan \
				'
