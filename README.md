# klaxalk's Linux environment

| Ubuntu       | Status                                                                                                                    |
|--------------|---------------------------------------------------------------------------------------------------------------------------|
| 18.04 Bionic | [![Build Status](https://travis-ci.com/klaxalk/linux-setup.svg?branch=master)](https://travis-ci.com/klaxalk/linux-setup) |

## Summary

This repo contains settings of klaxalk's Linux work environment.

It could be summarized as follows:
* **Ubuntu 18.04 or 20.04**
* **i3** (i3gaps) tiling window manager with i3bar and vim-like controls
  * **i3-layout-manager** for saving and loading window layouts
* **urxvt** terminal emulator with ability to show images (when using the *ranger* file manager)
* **tmux** terminal multiplexer is running all the time
  * **tmuxinator** for automation of tmux session
  * vim-compatible key bindings for split switching
* **vim** is everywhere
  * pluginized for smooth c++ and ROS development
  * youcompleteme
  * UltiSnips
  * shared clipboards between vim, tmux and OS
  * Ctrl+P
  * smooth latex development with vimtex and zathura
  * Tim Pope is the king
* **athame** gives you vim in the terminal (zsh)
  * handfull of plugins in terminal: ultisnips, vim-surround, targets.vim, vim-exchange, etc.
* **zsh** better shell for everyday use
* **ranger** terminal file manager
* **profile_manager** and **epigen** for switching between machine-specific configurations (profiles within dotfiles)
  * all-in-one configuration, no git branching, no more cherrypicking
  * sharing configs between multiple users
  * sharing configs between different machines
  * seamless switching of colorschemes

To clone and install everything run following code. **BEWARE**, running this will **DELETE** your current .i3, tmux, vim, etc. dotfiles.
```bash
cd /tmp
echo "mkdir -p ~/git
cd ~/git
sudo apt-get -y install git
git clone https://github.com/klaxalk/linux-setup.git
cd linux-setup
./install.sh" > run.sh && source run.sh
```
**Calling install.sh repeatedly** will not cause acumulation of code in your .bashrc, so feel free to update your configuration by rerunning it.

# How to? -> [wiki](https://github.com/klaxalk/linux-setup/wiki)

Refer to the project's [wiki](https://github.com/klaxalk/linux-setup/wiki) (work in progress).

# Credits

I thank the following sources for inspiration:

* All guys behind [thoughtbot](https://www.youtube.com/user/ThoughtbotVideo) and namely following presenters:
  * Mike Coutermarsh, https://www.youtube.com/watch?v=_NUO4JEtkDw
  * Chris Toomey, https://www.youtube.com/watch?v=wlR5gYd6um0
  * Aaron Bieber, https://www.youtube.com/watch?v=JWD1Fpdd4Pc
* Nick Nisi, https://www.youtube.com/channel/UCbNhLf99gKKXdXm0aFfQFKw
* Luke Smith, https://www.youtube.com/channel/UC2eYFnH61tmytImy1mTYvhA
* Alex Booker, https://www.youtube.com/watch?v=_kjbj-Ez1vU
* Chris Hunt, https://www.youtube.com/watch?v=9jzWDr24UHQ
* Gaël Ecorchard, https://github.com/galou

# Troubleshooting

It is possible and probable that after you update using ```git pull```, something might not work anymore.
This usually happens due to new programs, plugins, and dependencies that might not be satisfied anymore.
I suggest re-running **install.sh**, after each update.

# Disclaimer

This software is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.
