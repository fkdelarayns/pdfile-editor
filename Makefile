-include .env
ENV = production
SAIL = ./vendor/bin/sail
WEB_CONTAINER = $(if $(APP_SERVICE),$(APP_SERVICE),web)

NPM_EXEC := $(if $(APP_SERVICE),$(SAIL) npm,npm)
PHP_EXEC := $(if $(APP_SERVICE),$(SAIL),php)
DOCKER_EXEC = $(if $(APP_SERVICE),$(SAIL) exec $(APP_SERVICE),)

clear-logs:
	$(DOCKER_EXEC) truncate -s 0 storage/logs/laravel.log

clear-cache:
	$(PHP_EXEC) artisan cache:clear
	$(PHP_EXEC) artisan view:clear
	$(PHP_EXEC) artisan route:clear
	$(PHP_EXEC) artisan config:clear

setup-local:
	chmod +x ./setup.sh
	./setup.sh $(WEB_CONTAINER)

setup-test:
	cat ./docker/mysql/create-testing-database.sh | $(SAIL) exec -T mysql bash
	$(PHP_EXEC) artisan migrate:fresh --env=testing

build-assets:
	$(NPM_EXEC) install
	$(NPM_EXEC) run build -- --mode=$(ENV)
	$(NPM_EXEC) run lang-js

check-code: 
	$(DOCKER_EXEC) composer check

check-codesniffer:
	$(DOCKER_EXEC) composer cs-check-code

check-phpstan:
	$(DOCKER_EXEC) composer phpstan

check-md:
	$(DOCKER_EXEC) composer md

fix-code-standard:
	$(DOCKER_EXEC) composer cs-fix

bash:
	$(DOCKER_EXEC) bash