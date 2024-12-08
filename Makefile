M = $(shell printf "\033[34;1m▶\033[0m")
APP_NAME = microcks

.PHONY: help
help: ## Prints this help message
	@grep -E '^[a-zA-Z_-]+:.?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: install
install: ## Install Application as executable
	$(info $(M) Installing $(APP_NAME) as executable at /usr/local/bin/$(APP_NAME))
	@sudo ln -s ${PWD}/scripts/run.sh /usr/local/bin/$(APP_NAME)

.PHONY: remove
remove: ## Remove Application as executable
	$(info $(M) Removing $(APP_NAME) as executable from /usr/local/bin/$(APP_NAME))
	@sudo unlink /usr/local/bin/$(APP_NAME)

######################
### MAIN FUNCTIONS ###
######################

.PHONY: add_localhost
add_localhost: ## Add local host into /etc/hosts file (need root permission)
	@ echo "# >>> ${APP_NAME} for workspace" >> /etc/hosts
	@ echo "127.0.0.1\tmicrocks.local.io microcks-kc.local.io microcks-postman.local.io" >> /etc/hosts
	@ echo "# <<< ${APP_NAME} for workspace" >> /etc/hosts
	$(info $(M) Local host added for ${APP_NAME} application in your hosts file)

.PHONY: remove_localhost
remove_localhost: ## Remove local host from /etc/hosts file (need root permission)
	@ sed -e '$(shell grep --line-number "# >>> ${APP_NAME} for workspace" /etc/hosts | cut -d ':' -f 1),$(shell grep --line-number "# <<< ${APP_NAME} for workspace" /etc/hosts | cut -d ':' -f 1)d' /etc/hosts  > /etc/hosts.tmp
	@ cp /etc/hosts.tmp /etc/hosts && rm -f /etc/hosts.tmp
	$(info $(M) Local host removed for ${APP_NAME} application in your hosts file)

.PHONY: start
start: ## Start the Microcks docker container
	$(info $(M) Starting an instance of $(APP_NAME) at : http://$(APP_NAME).local.io/)
	@docker-compose -f ./docker/docker-compose.yml up -d

.PHONY: stop
stop: ## Stopping running Microcks instances
	$(info $(M) Stopping $(APP_NAME) instance)
	@docker-compose -f ./docker/docker-compose.yml down

.DEFAULT_GOAL := help
