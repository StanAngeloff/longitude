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

docker-build: DOCKER_OPTIONS=
docker-build:
	@cat Dockerfile | docker build $(DOCKER_OPTIONS) -t stanangeloff/longitude:latest -

docker-playbook:
	@docker run --rm --tty --volume `pwd`:/home/maximus/longitude --cap-add=NET_ADMIN stanangeloff/longitude:latest

dearmor: keys/keybase-20190624.asc.gpg
keys/%.asc.gpg: keys/%.asc
	gpg2 --yes -o "$@" --dearmor "$?"
