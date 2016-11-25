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
# How to work with my setup?

Here I describe the most important keybindings and shortcuts..

## TMUX shortcuts

- **ctrl+a** tmux **__PREFIX__**
- **__PREFIX__** list windows
- **ctrl t** create new window
- **shift left** switch to previous windows
- **shift right** switch to next windows
- **ctrl s** horizontal split
- **ctrl d** vertical split
- **alt left** switch to left split pane
- **alt roght** switch to right split pane
- **__PREFIX__ q** kill current tmux session
- **__PREFIX__ space** switch panel configuration
- **F2** go to vim edit mode
- **__PREFIX__ p** paste yanked text (from vim edit mode)
- **__PREFIX__ ctrl+s** save current session using tmux-resurrect
- **__PREFIX__ ctrl+r** resurrect previously saved session
- **shift down** gain control of embedded tmux
- **shift up** regain control of thr mother tmux
