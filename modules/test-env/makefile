.PHONY: help build destroy network-create network-destroy

.DEFAULT_GOAL = build
ENV = dev
AZs = az1
TIER = app,data,web

help:
	@echo "Using make to deploy terraform"

plan:
	bash ./build/apply.sh $(ENV) $(AZs) $(TIER) plan 

build:
	bash ./build/apply.sh $(ENV) $(AZs) $(TIER) 

init:
	bash ./build/apply.sh $(ENV) $(AZs) $(TIER) init

destroy:
	bash ./build/destroy.sh $(ENV) $(AZs) $(TIER)


network-build:
	bash ./build/apply.sh $(ENV) $(AZs) network

network-init:
	bash ./build/apply.sh $(ENV) $(AZs) network init

network-plan:
	bash ./build/apply.sh $(ENV) $(AZs) network plan

network-destroy:
	bash ./build/destroy.sh $(ENV) $(AZs) network 



	




