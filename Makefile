packages=tmux tmuxinator vim urxvt i3 vimtex ranger vimiv athame

# Variables above can be overwrite by local configuration
-include Makefile.config

# define paths
CURDIR = $(shell pwd)
APPCONFIG_PATH=$(CURDIR)/appconfig

all: git_init $(packages)
	echo $^
	toilet All Done

git_init:
	git submodule update --init --recursive

# For each package do following step: download dependecies,
# build and install
$(packages):
	echo $(CURDIR)
	@echo -----: $@
	@echo -----: $@ : Downloading dependencies
	@make -C $(APPCONFIG_PATH)/$@ dep
	@echo -----: $@ : Building
	@make -C $(APPCONFIG_PATH)/$@ build
	@echo -----: $@ : Installing
	@make -C $(APPCONFIG_PATH)/$@ install

# install packages
# XXX: I'm not sure if it is correct to call sudo in the Makefile
# Just use simple echo with installation of these all packages
install_packages:
	@echo "Please remove confict packages and install missing packages"
	@echo sudo apt-get -y update
	@echo sudo apt-get -y install cmake cmake-curses-gui ruby git sl htop git indicator-multiload \
		figlet toilet gem ruby build-essential tree exuberant-ctags libtool automake	\
	       	autoconf autogen libncurses5-dev python3-dev python2.7-dev libc++-dev clang-3.8	\
	       	clang-format openssh-server pandoc xclip xsel python-git vlc pkg-config
	# for mounting exfat
	@echo sudo apt-get -y install exfat-fuse exfat-utils
	$(foreach package, $(packages), @make -C $(APPCONFIG_PATH)/$(package) install_packages)
