# define paths
CURDIR = $(shell pwd)
VIM=../../submodules/vim

all: dep build install

dep:
	@echo -----: vim
	sudo apt-get remove vim*
	sudo apt-get -y install libncurses5-dev libgnome2-dev \
		libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
		libcairo2-dev libx11-dev libxpm-dev libxt-dev

# compile vim from sources
build:
	cd $(VIM) ; ./configure \
		--with-features=huge \
		--enable-multibyte \
		--enable-rubyinterp=yes \
		--enable-pythoninterp=yes \
		--with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
		--enable-perlinterp=yes \
		--enable-luainterp=yes \
		--enable-gui=gtk2 --enable-cscope --prefix=/usr
	make -C $(VIM)
	make -C $(VIM) VIMRUNTIMEDIR=/usr/share/vim/vim80
	cd ~/.vim/plugged/youcompleteme/
	./install.py --all
	@echo "link .ycm_extra_conf.py"
	ln -fs $(CURDIR)/dotycm_extra_conf.py ~/.ycm_extra_conf.py

install:
	sudo make -C $(VIM) install
	@echo -----: vim : symlink vim settings
	rm ~/.vimrc
	rm -rf ~/.vim
	ln -fs $(CURDIR)/dotvimrc ~/.vimrc
	ln -fs $(CURDIR)/dotvim ~/.vim
	@echo -----: vim : install patched fonts
	../../submodules/fonts/install.sh


configure:
	git config --global merge.tool vimdiff
	export CTAGS_SOURCE_DIR="-R ~/mrs_workspace -R ~/workspace"' >> ~/.bashrc
	export CTAGS_ONCE_SOURCE_DIR="-R /opt/ros/kinetic/include"' >> ~/.bashrc
	export ROS_WORKSPACE="~/mrs_workspace ~/workspace" >> ~/.bashrc
	/usr/bin/vim -E -c "let g:user_mode=1" -c "so ~/.vimrc" -c "PlugInstall" -c "PlugClean" -c "wqa"

install_packages:
	@echo -----: vim
	@echo Please remove following pacakges!
	@echo sudo apt-get remove vim*
	@echo sudo apt-get -y install libncurses5-dev libgnome2-dev \
		libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
		libcairo2-dev libx11-dev libxpm-dev libxt-dev
