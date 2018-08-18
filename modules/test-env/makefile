.PHONY: help plan init build destroy network-build network-destroy network-plan network-init

.DEFAULT_GOAL = build
ENV = dev
AZs = az1
TIERs = app,data,web

help:
	@echo "Using make to deploy terraform"

plan:
	bash ./build/action.sh $(ENV) $(AZs) $(TIERs) plan 

build:
	bash ./build/action.sh $(ENV) $(AZs) $(TIERs) 

init:
	bash ./build/action.sh $(ENV) $(AZs) $(TIERs) init

destroy:
	bash ./build/destroy.sh $(ENV) $(AZs) $(TIERs)


network-build:
	bash ./build/action.sh $(ENV) $(AZs) network

network-init:
	bash ./build/action.sh $(ENV) $(AZs) network init

network-plan:
	bash ./build/action.sh $(ENV) $(AZs) network plan

network-destroy:
	bash ./build/destroy.sh $(ENV) $(AZs) network 



	




