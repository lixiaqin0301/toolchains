#!/bin/bash

/bin/rm -rfv /usr/share/fonts/lixq $HOME/.local/share/fonts
ln -sf /home/lixq/toolchains/fonts /usr/share/fonts/lixq
ln -sf /home/lixq/toolchains/fonts $HOME/.local/share/fonts
cd $HOME/.local/share/fonts
mkfontscale 
mkfontdir 
fc-cache -fv

[[ -d $HOME/.cache/vimfiles/repos ]] || mkdir -p $HOME/.cache/vimfiles/repos
/bin/rm -rfv $HOME/.cache/vimfiles/repos/github.com
ln -sf /home/lixq/toolchains/github.com $HOME/.cache/vimfiles/repos/github.com

/bin/rm -rfv $HOME/.m2
ln -sf /home/lixq/toolchains/m2 $HOME/.m2

/bin/rm -rfv $HOME/.config/nvim $HOME/.vim
ln -sf /home/lixq/toolchains/SpaceVim-2.0.0 $HOME/.config/nvim
ln -sf /home/lixq/toolchains/SpaceVim-2.0.0 $HOME/.vim

/bin/rm -rfv $HOME/.SpaceVim.d
ln -sf /home/lixq/toolchains/SpaceVim.d $HOME/.SpaceVim.d

/bin/rm -rfv $HOME/.zshrc
ln -sf /home/lixq/toolchains/zshrc $HOME/.zshrc

/bin/rm -rfv /etc/profile.d/fcitx.sh
ln -sf /home/lixq/toolchains/fcitx.sh /etc/profile.d

/bin/rm -rfv /etc/cron.d/vnc.conf
ln -sf /home/lixq/toolchains/vnc.conf /etc/cron.d
