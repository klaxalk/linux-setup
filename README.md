# Linux Environment Preparation

This repo contains scripts for setting up my linux working environment, mainly by
installing two vital applications: TMUX and VIM and setting up their behaviour.

Beware, running this will DELETE your previous tmux and vim setup (.vim, .tmux.conf, .vimrc)!!

To clone and install everything run following code:

```bash
mkdir -p ~/git
cd ~/git
git clone --recursive https://github.com/klaxalk/linux-setup.git
cd linux-setup
./install.sh
```
