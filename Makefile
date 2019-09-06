.DEFAULT_GOAL := help

.PHONY: x11 vnc build x11-brew x11-setup

# Install brew if you don't have it
brew:
	@command -v brew || /usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install X11/Xquartz if you don't have it
x11-brew: brew
	brew cask list xquartz || brew cask install xquartz
	open /Applications/Utilities/XQuartz.app

x11-setup: x11-brew
	defaults write org.macosforge.xquartz.X11 depth -int 32 && \
	defaults write org.macosforge.xquartz.X11.plist nolisten_tcp 0 && \
	defaults write org.macosforge.xquartz.X11.plist no_auth 1

# Source: 
#   https://hub.docker.com/r/kayvan/pgmodeler/
#   https://github.com/ksylvan/docker-pgmodeler

build: ## Build pgmodeler
	docker build . -t kayvan/pgmodeler:latest

pull: ## Pull original kayvan/pgmodeler
	docker pull kayvan/pgmodeler:latest

browser:
	open http://localhost:16922/vnc.html

#------------------------------------------------------------------------------
# Bring up containers
#------------------------------------------------------------------------------
up-x11: build x11-setup ## Run pgmodeler in host's x windows
	xhost + && \
	docker-compose up pgmodeler-x11

up-vnc: build ## Run pgmodeler in host's vnc client / web browser http://localhost:16922/vnc.html
	docker-compose up pgmodeler-vnc && browser
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Bring down containers
#------------------------------------------------------------------------------
down-x11: ## Bring down pgmodeler in x11
	docker-compose down -v --remove-orphans

down-vnc: ## Bring down pgmodeler in vnc
	docker-compose down -v --remove-orphans

down-all: down-x11 down-vnc ## Bring down all pgmodeler containers

#------------------------------------------------------------------------------
help: ## That's me!
	@echo
	@echo "#$(LINE)"
	@printf "\033[37m%-30s\033[0m %s\n" "# Makefile Help                                                                         |"
	@echo "#$(LINE)"
	@printf "\033[37m%-30s\033[0m %s\n" "# This Makefile can be used to run build, and run pgmodeler in hosts's x-windows or vnc |"
	@echo "#$(LINE)"
	@echo 
	@printf "\033[37m%-30s\033[0m %s\n" "#-target-----------------------description-----------------------------------------------"
	@grep -E '^[a-zA-Z_-].+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo 

print-%  : ; @echo $* = $($*)

