# define standard colors
ifneq (,$(findstring xterm,${TERM}))
	BLACK        := $(shell tput -Txterm setaf 0)
	RED          := $(shell tput -Txterm setaf 1)
	GREEN        := $(shell tput -Txterm setaf 2)
	YELLOW       := $(shell tput -Txterm setaf 3)
	LIGHTPURPLE  := $(shell tput -Txterm setaf 4)
	PURPLE       := $(shell tput -Txterm setaf 5)
	BLUE         := $(shell tput -Txterm setaf 6)
	WHITE        := $(shell tput -Txterm setaf 7)
	RESET := $(shell tput -Txterm sgr0)
else
	BLACK        := ""
	RED          := ""
	GREEN        := ""
	YELLOW       := ""
	LIGHTPURPLE  := ""
	PURPLE       := ""
	BLUE         := ""
	WHITE        := ""
	RESET        := ""
endif

# set target color
TARGET_COLOR := $(BLUE)


POUND = \#

DC := docker-compose
TEST := $(DC) run --rm test
WEB := $(DC) run --rm web

.DEFAULT_GOAL := help

define find.functions
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
endef

help:
	@echo ""
	@echo "    ${BLACK}:: ${RED}Self-documenting Makefile${RESET} ${BLACK}::${RESET}"
	@echo ""
	@echo "Document targets by adding '$(POUND)$(POUND) comment' after the target"
	@echo ""
	@echo "Example:"
	@echo "  | job1:  $(POUND)$(POUND) help for job 1"
	@echo "  | 	@echo \"run stuff for target1\""
	@echo ""
	@echo "${BLACK}-----------------------------------------------------------------${RESET}"
	@grep -E '^[a-zA-Z_0-9%-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "${TARGET_COLOR}%-30s${RESET} %s\n", $$1, $$2}'



createsuperuser: ## Create superuser for django admin panel
	@echo "Creating superuser"
	@${WEB} python manage.py createsuperuser

migrate: ## Migrate database for django app
	@echo "Migrating database"
	@${WEB} python manage.py makemigrations && ${WEB} python manage.py migrate

run: ## Run django app
	@echo "Running django app"
	@${DC} up

test: ## Run tests for django app
	@echo "Running tests"
	@${TEST} pytest --ds=django_project.settings

django-shell: ## Run django-shell
	@echo "Running shell"
	@${WEB} python manage.py shell

shell: ## Run shell
	@echo "Running shell"
	@${DC} run shell

build: ## Build docker images
	@echo "Building docker images"
	@${DC} build

build-no-cache: ## Build docker images without cache
	@echo "Building docker images without cache"
	@docker-compose build --no-cache

format: ## Format code with black
	@echo "Formatting code"
	@${TEST} yapf -r -i . && ${TEST} isort . && ${TEST} djlint . --reformat

lint: ## Lint code with flake8
	@echo "Linting code"
	@${TEST} flake8 .  --max-line-length=120 --exclude=migrations && ${TEST} pylint .