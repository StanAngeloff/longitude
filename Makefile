.PHONY: usage ansible playbook

usage:
	@echo 'Usage: make [ ansible | playbook ]'

ansible:
	@sudo apt-get update
	@sudo apt-get install -y software-properties-common
	@sudo apt-add-repository -y --update ppa:ansible/ansible
	@sudo apt-get install -y ansible

playbook:
	ansible-playbook baoboot.yml --ask-become-pass
