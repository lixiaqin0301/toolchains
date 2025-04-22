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

/bin/rm -rfv "$HOME/.config/gtk-3.0"
ln -sf /home/lixq/toolchains/data/gtk-3.0 "$HOME/.config/gtk-3.0"

/bin/rm -rfv "$HOME/.SpaceVim.d"
ln -sf /home/lixq/toolchains/SpaceVim.d "$HOME/.SpaceVim.d"

/bin/rm -rfv "$HOME/.zshrc"
ln -sf /home/lixq/toolchains/data/zshrc "$HOME/.zshrc"

/bin/rm -rfv /etc/profile.d/etc_profile_d.sh
ln -sf /home/lixq/toolchains/data/etc_profile_d.sh /etc/profile.d/

/bin/rm -rfv /etc/cron.d/vnc.conf
ln -sf /home/lixq/toolchains/data/vnc.conf /etc/cron.d
