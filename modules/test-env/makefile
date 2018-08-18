.PHONY: help build destroy network-create network-destroy

.DEFAULT_GOAL = build
ENV = dev
AZs = az1
MODULES = app,data,web

help:
	@echo "Using make to deploy terraform"

network-create:
	bash ./build/create.sh $(ENV) $(AZs) network 

network-destroy:
	bash ./build/destroy.sh $(ENV) $(AZs) network

build:
	bash ./build/create.sh $(ENV) $(AZs) $(MODULES)

destroy:
	bash ./build/destroy.sh $(ENV) $(AZs) $(MODULES)

	




