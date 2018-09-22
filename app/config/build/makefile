.PHONY: help plan init build destroy network-build network-destroy network-plan network-init

.DEFAULT_GOAL = build

help:
	@echo "Using make to deploy terraform"

vpc-plan:
	bash ./action.sh $(project) vpc plan 

vpc-build:
	bash ./action.sh $(project) vpc build 

vpc-init:
	bash ./action.sh $(project) vpc init

vpc-destroy:
	bash ./action.sh $(project) vpc destroy


plan:
	bash ./action.sh $(project)  modules plan 

build:
	bash ./action.sh $(project)  modules build 

init:
	bash ./action.sh $(project) modules init 

destroy:
	bash ./action.sh $(project) modules destroy 


network-build:
	bash ./action.sh $(project) network build 

network-init:
	bash ./action.sh  $(project) network init

network-plan:
	bash ./action.sh $(project) network plan 

network-destroy:
	bash ./action.sh $(project) network destroy 



	




