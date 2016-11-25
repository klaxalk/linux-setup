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

- **ctrl+a** tmux prefix
- **prefix w** list windows
- **ctrl t** create new window
- **shift left** switch to previous windows
- **shift right** switch to next windows
- **ctrl s** horizontal split
- **ctrl d** vertical split
- **alt <-** switch to left split pane
- **alt ->** switch to right split pane
- **prefix q** kill current tmux session
- **prefix space** switch panel configuration
- **F2** go to vim edit mode
- **prefix p** paste yanked text (from vim edit mode)
- **prefix ctrl+s** save current session using tmux-resurrect
- **prefix ctrl+r** resurrect previously saved session
- **shift down** gain control of embedded tmux
- **shift up** regain control of thr mother tmux
