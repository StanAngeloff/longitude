.PHONY: usage ansible playbook docker-build docker-playbook dearmor

usage:
	@echo 'Usage: make [ ansible | playbook ]'

ansible:
	@sudo apt-get update
	@sudo apt-get install -y software-properties-common
	@sudo apt-add-repository -y --update ppa:ansible/ansible
	@sudo apt-get install -y ansible

playbook:
	ansible-playbook longitude.$@.yml --ask-become-pass --diff

DOCKER_IMAGE_TAG = $(shell cat Dockerfile | grep '^FROM' | cut -d: -f2)

docker-build: DOCKER_OPTIONS=
docker-build: Dockerfile
	@cat Dockerfile | docker build $(DOCKER_OPTIONS) -t stanangeloff/longitude:$(DOCKER_IMAGE_TAG) -

docker-playbook:
	@docker run --rm --tty --volume `pwd`:/home/maximus/longitude --cap-add=NET_ADMIN stanangeloff/longitude:$(DOCKER_IMAGE_TAG)

dearmor: keys/keybase-20190624.asc.gpg keys/tarsnap-signing-key-2021.asc.gpg keys/python-Lukasz-Langa-keybase.asc.gpg keys/bintray-public.key.asc.gpg keys/trava90.asc.gpg
keys/%.asc.gpg: keys/%.asc
	gpg2 --yes -o "$@" --dearmor "$?"
