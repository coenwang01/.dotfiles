export XDG_CONFIG_HOME=$HOME/.config
export NVIM_BASE_DIR=XDG_CONFIG_HOME/nvim
export TERM_ITALICS=true
export EDITOR=nvim
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
# export TERM=screen-256color-bce
export WORKON_HOME=$HOME/.venvs
export PATH="$PATH:$HOME/.dotfiles/.bin"
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin"
export PATH="$PATH:$HOME/.local/share/nvim/mason/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export TMUX_TMPDIR=$HOME/.tmux/tmp
export CFLAYS="-Wall -Werror -Wextra"
if [[ $(uname) == 'Darwin' ]]; then
  export TERM=screen-256color
  export TERMINAL="iTerm"
	export PATH="$PATH:/opt/homebrew/bin"
	export PATH="$PATH:$HOME/.nix-profile/bin"
	export C_INCLUDE_PATH="$PATH:/opt/homebrew/include:$C_INCLUDE_PATH"
	export CPLUS_INCLUDE_PATH="$PATH:/opt/homebrew/include:$CPLUS_INCLUDE_PATH"
	export DYLD_LIBRARY_PATH="$PATH:/usr/local/lib:$DYLD_LIBRARY_PATH"
	export DYLD_LIBRARY_PATH="$PATH:/opt/homebrew/lib:$DYLD_LIBRARY_PATH"
	export LIBRARY_PATH="$PATH:/usr/local/lib:$LIBRARY_PATH"
	export LIBRARY_PATH="$PATH:/opt/homebrew/lib:$LIBRARY_PATH"
	export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles/bottles
elif [[ $(uname) == 'Linux' ]]; then
  export TERM=xterm-kitty
  export TERMINAL="kitty"
  export PATH=$PATH:/snap/bin
  export CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH:/usr/include/python2.7/"
  # for hidpi screen
	export GDK_SCALE=2
	export GDK_DPI_SCALE=0.5
	export QT_AUTO_SCREEN_SCALE_FACTOR=0
	export QT_SCALE_FACTOR=1
fi


# for user defined
export THEME="tokyonight"
# ----------------

# FZF bases
export FZF_DEFAULT_OPTS="
  --color fg:$color7
  --color fg+:$color0
  --color bg:$background
  --color bg+:$color0
  --color hl:$color10
  --color hl+:$color2
  --color info:$color4
  --color prompt:$color4
  --color spinner:$color12
  --color pointer:$color7
  --color marker:$color5
  --color border:$background
  --color gutter:$color0
  --color header:$color8
  --prompt ' '
  --pointer ' λ'
  --layout=reverse
  --border horizontal
  --height 40"