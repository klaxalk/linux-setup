# Linux Environment Preparation

This repo contains scripts for setting up my linux working environment, mainly by
installing two vital applications: TMUX and VIM and setting up their behaviour.

**BEWARE**, running this will **DELETE** your previous tmux and vim setup (.vim, .tmux.conf, .vimrc)!!

To clone and install everything run following code:

```bash
cd /tmp
echo "mkdir -p ~/git
cd ~/git
sudo apt-get -y install git
git clone --recursive https://github.com/klaxalk/linux-setup.git
cd linux-setup
./install.sh" > run.sh && source run.sh
```
**Calling install.sh repeatedly** will not cause acumulation of gibrish in your .bashrc, so feel free to update your configuration by rerunning it.

# How to work with my setup?

Here I describe the most important keybindings and shortcuts..

## TMUX+Vim commons

Running Vim inside TMUX has some serious advantages.
First, TMUX allows to copy any text in the terminal using its own vi-mode (see TMUX shortcuts bellow).
With a simple hack, the coppied text is inserted into the system clipboard.
The same can be done with Vim, so basically, we have a clipboard shared between the system, Vim and TMUX, which is accessible and fillable without using a **mouse**.

Another notable feature is enabled by the plugin [christoomey/vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator].
It allows to seemlessly navigate throug TMUX and Vim splits (panes) with a single set of key bindings.
In my setup, those are **crtl h/j/k/l** for left/down/right/up movement.

## TMUX shortcuts

Following key bindings encapsulate 99% of all what I use in TMUX.
Most importantly, note that I remapped the standard **prefix** from ctrl+b to ctrl+a.
There are several reason for it, e.g. 1) it can be pressed easily by one hand and 2) most people on the internet do it like that.

- **ctrl a** tmux **__PREFIX__**
- **__PREFIX__ w** list windows
- **__PREFIX__ s** list all tmux sessions and theirs windows
- **ctrl t** create new window
- **shift left** switch to previous window (also **alt u**, handy for i3wm users)
- **shift right** switch to next window (also **alt i**, handy for i3wm users)
- **ctrl s** horizontal split
- **ctrl d** vertical split
- **alt left** switch to left split pane
- **alt right** switch to right split pane
- **ctrl h** focus left pane
- **ctrl j** focus down pane
- **ctrl k** focus up pane
- **ctrl l** focus right pane
- **__PREFIX__ ctrl h** resize current pane to the left
- **__PREFIX__ ctrl j** resize current pane down
- **__PREFIX__ ctrl k** resize current pane to the right 
- **__PREFIX__ ctrl l** resize current pane up
- **__PREFIX__ k** kill current tmux session with all its processes
- **__PREFIX__ space** switch panel configuration
- **F2** go to vim edit mode
- **__PREFIX__ p** paste yanked text (from vim edit mode) 
- **__PREFIX__ z** enlarge focused pane to the whole screen (or back)

TMUX-RESURRECT can be used to save a state of a single session.
Use following keys to control it.

- **__PREFIX__ ctrl-s** save the current session using tmux-resurrect
- **__PREFIX__ ctrl-r** resurrect previously saved session

### Custom TMUX config

If you wish to use your own tmux config besides mine, create a file **~/.my.tmux.conf**, it will be sourced automatically if it exists.

## TMUXINATOR

I forked TMUXINATOR (https://github.com/tmuxinator/tmuxinator), a handy tool for automating tmux sessions.
I suggest to read its tutorials.

## VIM

Vim has been heavily pluginized in this setup, which makes it more like IDE then a simple terminal editor.
Plugins are maintained by a plugin manager called **Vundle**, which should download them from their repositories automatically.
To update them manually, call **:PluginUpdate**, to install them **:PluginInstall** in Vim. However, they will be installed automatically by **install.sh**.

### List of plugins

Here is a list of plugin I use.
I divide plugins into two groups according to how they integrate to my workflow.
Plugins with new features, you are supposed to read their tutorials to know how to use them (but you don't have to if it does not suite you):

  * **vim-fugitive** - git integration
  * **vimux** - tmux integration
  * **nerdtree** - simple integrated file explorer
  * **vim-abolish** - automatic substitutions
  * **ultisnips** - code snippets
  * **ReplaceWithRegister** - adds "gr" action to replace text 
  * **vim-argwrap** - clever function argumment wrapping
  * **vim-multiple-cursors** - adding mupltiple cursors feature
  * **tagbar** - windows with tag list of the current file
  * **vim-expand-region** - clever visual selection for dummies
  * **vim-ros** - ROS integration
  * **vim-commentary** - clever code commenting
  * **vim-surround** - allows to manipulate with surrounding pairs of characters
  * **vimtex** - latex integration
  * **vimwiki** - notetaking and wikipedia edittingvim-exchange
  * **vim-exchange** - allows exchaning two target locations
  * **vim-unimpaired** - clever new keybindings for e.g. quickfix and buffers

Plugins you don't need to know about (their features integrate "seemlessly"):

  * **Vundle** - vim plugin manager
  * **jellybeans.vim** - color scheme
  * **vim-airline** - status line
  * **united-front** - sharing register between vim instances
  * **vim-startify** - new home screen for vim
  * **vim-signature** - shows marks left to line numbers
  * **targets.vim** - additional target descriptions, that feel natural
  * **vim-python-pep8-indent** - python integration
  * **GoldenView.Vim** - split resizing in golden ratio
  * **quick-scope** - f/t motion helper
  * **supertab** - allows youcompleteme to work with ultisnips
  * **youcompleteme** - automatic code-aware code completion
  * **tmuxline.vim** - tmux and vim statusline integration
  * **MatlabFilesEdition** - should add matlab syntax highlighting
  * **vim-tmux-navigator** - makes tmux and vim split navigation possible

### New mappings?

My new mapping for moving within vim:

- **shift j/k** move to next/previous tab
- **ctrl-h/j/k/l** move to left/down/up/right split

Here is a short description of the most important plugins together with example of their usage:

### Startify

Run vim without parameters! Really, try that. Startify shows a useful list of recently openned files when running vim without parameters. It also allows to **save** and **load** sessions. Save the current session by calling
```bash
:SSave
```
you will be prompted to enter the name of the session.
You can later see the session on the main Startify screen.
Startify also displays random vim tips in a form of a 'barking dog'.
Feel free to update those and submit them by means of a **pull request** on a file appconfig/vim/startify_quotes.txt.

- **\<leader\>s** - opens new vim tab and shows Startify

### NERDTree

NERDTree provides a simple file browser within a split.
Toggle it by **\<leader\>N**.
The current setup shows NERDTree also when you open vim with a folder in the argument.
Read its documentation for further information.

- **\<leader\>t** - opens new vim tab and shows NERDTree

### Vimmux

Vimmux allows to open TMUX splits and run commands in them.
I use them mainly for compiling my workspace.
Commands can be configured in **~/.my.vimrc** file which will stay unchanged by git.
Currently, I don't vimmux that much, but if you want, key mappings are commented in **.my.vimrc**.

### United-front

This pluggin allows to share registers between different instances of vim.
Thus allows to copy and paste regardles of splitting in vim od TMUX.

### YouCompleteMe

Want to work like a pro in an IDE? Vim can do that.
YouCompleteMe provides state-of-the art code completion functions.
YCM uses Clang compiler to make up suggestions and detect syntax and semantic errors in your code.
Clang needs to know compile flags for your particular piece of code.

Key mapping for youcompleteme:

- When suggestions appear, press either **tab**, **up/down**, **ctrl-j/k** to move within the menu.
- When you are in the menu, move within it using **tab**, **up/down**, **ctrl-j/k** or **j/k**.
- To confirm the selection, press **enter** or **l**.
- If the suggestions spawns a code snippet, move by **ctrl-h/l** between its parts.

#### C++ and ROS code completion

To allow full ROS code completion, follow those:

- Make sure a bash variable **$ROS_WORKSPACE** is set in your .bashrc. It should contain a list of locations of your ORS workspace(s), separated by spaces.
- Since now, build your workspace with **-DCMAKE_EXPORT_COMPILE_COMMANDS=ON** flag. You can do it e.g. by modifying the default build profile as
```bash
catkin config --profile default --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

Enjoy!

### UltiSnips

Completing code snippets is an existential part of programming.
Thanks to Ultisnip, pieces of code like **if**, **while** and more can be much simpler to write.
Ultisnip completes those by hitting **\<tab\>** after writing the keyword.
If needed, hitting it again jumps through new filled placeholders in the code snippet.

Key mapping for Ultisnip:

- When suggestions appear, press **tab** to expand the snippet.
- While in the snipper, move right and left over suggested parts by **left/right** or **ctrl-h / ctrl-l**.

Snippets can be used in visual mode by wrapping a selected code in e.g. **if** statement, by:
- 1. select a piece of code
- 2. hit **\<tab\>**, the code will disappeare
- 3. write a code word for a snipper, e.g. **if**
- 4. hit **\<tab\>** again, the code will appeear wrapped in new if statement.

Snippets are described in **.vim/UltiSnips** folder.
A snippet file for the currently openned document can be openned by **\<leader\>u**.

## Other vim stuff ...

### The leader key

I have remapped the leader to a comma ",".

### Using CTAGS

Ctags is a useful way to maintain "hyperlinks" in your code.
It later allows you to jump through "tags" (names in the code), e.g. function names.
Variable **CTAGS_SOURCES_DIR** in your **.bashrc** specifies where should ctags look for your code.
The database is built automatically when running vim, or manually by calling **:MakeTags** in vim.
Further shortcuts can be used to navigate through your code:

- **\<leader\>.** - dive into the tag
- **\<leader\>/** - go back one tag
- **\<leader\>;** - show list of files in which the tag is defined

### Macros

Working macros might be tedious.
If you, just like me, tend to record everything to @a, following feature might be useful.
When in **visual mode**, the **dot** operator applies macro **@a** over all selected lines.

### Other key bindings

- **\<leader\>a** - toggles highlighting of words under the cursor
- **\<leader\>p** - toggles :paste mode
- **\<leader\>g** - automatically indents the whole document while staying on the current line
