NAME = inception

# Detect OS and set DATA_PATH accordingly
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    DATA_PATH = $(HOME)/data
else
    DATA_PATH = /home/$(USER)/data
endif

export DATA_PATH
DOCKER_COMPOSE = docker compose -f srcs/docker-compose.yml

all: setup
	$(DOCKER_COMPOSE) up -d --build

setup:
	@if [ ! -d "$(DATA_PATH)" ]; then \
		sudo mkdir -p $(DATA_PATH); \
		sudo mkdir -p $(DATA_PATH)/wordpress; \
		sudo mkdir -p $(DATA_PATH)/mariadb; \
		sudo chown -R $(USER):$(USER) $(DATA_PATH); \
		sudo chmod -R 755 $(DATA_PATH); \
	fi

build:
	$(DOCKER_COMPOSE) build

up:
	$(DOCKER_COMPOSE) up -d

down:
	$(DOCKER_COMPOSE) down

start:
	$(DOCKER_COMPOSE) start

stop:
	$(DOCKER_COMPOSE) stop

restart:
	$(DOCKER_COMPOSE) restart

ps:
	$(DOCKER_COMPOSE) ps

logs:
	$(DOCKER_COMPOSE) logs

clean: down
	docker system prune -af
	sudo rm -rf $(DATA_PATH)

fclean: clean
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	docker network rm inception 2>/dev/null || true

re: fclean all

.PHONY: all setup build up down start stop restart ps logs clean fclean re
