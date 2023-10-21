# Executables (local)
DOCKER_COMP = docker-compose

# Docker containers
PHP_CONT  = $(DOCKER_COMP) exec php
NODE_CONT = $(DOCKER_COMP) exec nodejs

# Executables
PHP      = $(PHP_CONT) php
COMPOSER = $(PHP_CONT) composer
SYMFONY  = $(PHP_CONT) bin/console
YARN     = $(NODE_CONT) yarn

# Symfony
SYMFONY_VERSION=6.1

# Misc
.DEFAULT_GOAL = help
.PHONY        = help build up start down logs sh composer vendor sf cc

## —— 🎵 🐳 The Symfony-docker Makefile 🐳 🎵 ——————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker 🐳 ————————————————————————————————————————————————————————————————
build: ## Builds the Docker images
	@$(DOCKER_COMP) build --pull --no-cache

up: ## Start the docker hub in detached mode (no logs)
	@$(DOCKER_COMP) up --detach

start: build up ## Build and start the containers

down: ## Stop the docker hub
	@$(DOCKER_COMP) down --remove-orphans

logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

sh: ## Connect to the PHP FPM container
	@$(PHP_CONT) sh

## —— Composer 🧙 ——————————————————————————————————————————————————————————————
composer: ## Run composer, pass the parameter "c=" to run a given command, example: make composer c='req symfony/orm-pack'
	@$(eval c ?=)
	@$(COMPOSER) $(c)

vendor: ## Install vendors according to the current composer.lock file
vendor: c=install --prefer-dist --no-dev --no-progress --no-scripts --no-interaction
vendor: composer

## —— Symfony 🎵 ———————————————————————————————————————————————————————————————
init-sf:
	@$(DOCKER_COMP) pull
	@$(DOCKER_COMP) up --build -d php-fpm php-composer php nginx database
	@$(PHP_CONT) curl https://raw.githubusercontent.com/symfony/skeleton/$(SYMFONY_VERSION)/composer.json --output composer.json
	@$(COMPOSER) install --no-interaction

init-sf-web:
	@$(DOCKER_COMP) pull
	@$(DOCKER_COMP) up --build -d
	@$(PHP_CONT) curl https://raw.githubusercontent.com/symfony/skeleton/$(SYMFONY_VERSION)/composer.json --output composer.json
	@$(COMPOSER) install --no-interaction
	@$(COMPOSER) require webapp
	@$(COMPOSER) require symfony/webpack-encore-bundle
	@$(YARN) install
	@$(YARN) build
	@$(YARN) encore dev

sf: ## List all Symfony commands or pass the parameter "c=" to run a given command, example: make sf c=about
	@$(eval c ?=)
	@$(SYMFONY) $(c)

cc: c=c:c ## Clear the cache
cc: sf
