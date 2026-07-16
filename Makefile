NAME = inception

COMPOSE = docker compose -f srcs/docker-compose.yml

DATA_DIR = /home/jjakupi/data
MARIADB_DATA = $(DATA_DIR)/mariadb
WORDPRESS_DATA = $(DATA_DIR)/wordpress

GREEN = \033[0;32m
YELLOW = \033[0;33m
BLUE = \033[0;34m
RED = \033[0;31m
RESET = \033[0m

all: up

up:
	@echo "$(BLUE)Creating data directories...$(RESET)"
	@sudo mkdir -p $(MARIADB_DATA)
	@sudo mkdir -p $(WORDPRESS_DATA)

	@echo "$(GREEN)Building and starting containers...$(RESET)"
	@$(COMPOSE) up --build -d
	@echo "$(GREEN)Inception is running.$(RESET)"
	@echo "$(YELLOW)Website: https://jjakupi.42.fr$(RESET)"

down:
	@echo "$(YELLOW)Stopping containers...$(RESET)"
	@$(COMPOSE) down
	@echo "$(GREEN)Containers stopped. Persistent data kept.$(RESET)"

clean:
	@echo "$(YELLOW)Cleaning containers and unused Docker resources...$(RESET)"
	@$(COMPOSE) down
	@docker system prune -f
	@echo "$(GREEN)Clean done.$(RESET)"

fclean:
	@echo "$(RED)Full cleanup: containers, volumes, images and data...$(RESET)"
	@$(COMPOSE) down -v
	@docker system prune -af
	@docker volume prune -f
	@sudo rm -rf $(MARIADB_DATA)
	@sudo rm -rf $(WORDPRESS_DATA)
	@sudo rm -rf /home/jjakupi/data
	@echo "$(GREEN)Full clean done.$(RESET)"

re: fclean all

status:
	@$(COMPOSE) ps

logs:
	@$(COMPOSE) logs

.PHONY: all up down clean fclean re status logs
