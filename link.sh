#!/bin/bash

/bin/rm -rfv /usr/share/fonts/lixq "$HOME/.local/share/fonts"
ln -sf /home/lixq/toolchains/fonts /usr/share/fonts/lixq
ln -sf /home/lixq/toolchains/fonts "$HOME/.local/share/fonts"
cd "$HOME/.local/share/fonts" || exit 1
mkfontscale 
mkfontdir 
fc-cache -fv

[[ -d $HOME/.cache/vimfiles/repos ]] || mkdir -p "$HOME/.cache/vimfiles/repos"
/bin/rm -rfv "$HOME/.cache/vimfiles/repos/github.com"
ln -sf /home/lixq/toolchains/github.com "$HOME/.cache/vimfiles/repos/github.com"

/bin/rm -rfv "$HOME/.config/nvim" "$HOME/.vim"
ln -sf /home/lixq/toolchains/SpaceVim "$HOME/.config/nvim"

/bin/rm -rfv "$HOME/.SpaceVim.d"
ln -sf /home/lixq/toolchains/SpaceVim.d "$HOME/.SpaceVim.d"

/bin/rm -rfv "$HOME/.zshrc"
ln -sf /home/lixq/toolchains/zshrc "$HOME/.zshrc"

/bin/rm -rfv "$HOME/.vscode-server"
ln -sf /home/lixq/toolchains/vscode-server "$HOME/.vscode-server"

/bin/rm -rfv "$HOME/.condarc"
ln -sf /home/lixq/toolchains/condarc "$HOME/.condarc"

/bin/rm -rfv "$HOME/go"
ln -sf /home/lixq/toolchains/go "$HOME/go"
cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd/third_party
ln -s /home/lixq/toolchains/go

/bin/rm -rfv /etc/profile.d/fcitx.sh
ln -sf /home/lixq/toolchains/fcitx.sh /etc/profile.d

/bin/rm -rfv /etc/cron.d/vnc.conf
ln -sf /home/lixq/toolchains/vnc.conf /etc/cron.d
