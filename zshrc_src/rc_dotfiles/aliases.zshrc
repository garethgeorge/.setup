#! /bin/bash

if [[ $OSTYPE == "darwin"* ]]; then
    alias ls="ls -Gah"
    alias ip-private="ipconfig getifaddr en0"
    alias new-mac="openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//' | xargs sudo ifconfig en0 ether"
    if [ `command -v encfs` ]; then
        alias asdf-mount-local="trap 'asdf-umount' EXIT && sshfs -o allow_other,default_permissions -o Compression=no -o cache=yes -o kernel_cache -o no_readahead -o cipher=chacha20-poly1305@openssh.com desktop-local:/media/lucastong/bulk_storage/.asdf ~/temp/.asdf && encfs ~/temp/.asdf ~/temp/asdf"

        alias asdf-mount="trap 'asdf-umount' EXIT && sshfs -o allow_other,default_permissions -o Compression=no -o cache=yes -o kernel_cache -o no_readahead -o cipher=chacha20-poly1305@openssh.com desktop:/media/lucastong/bulk_storage/.asdf ~/temp/.asdf && encfs ~/temp/.asdf ~/temp/asdf"

        alias asdf-umount="((cd ~; diskutil unmount force ~/temp/asdf; diskutil unmount force ~/temp/.asdf) &) &> /dev/null"
    fi

elif [[ $OSTYPE == "linux-gnu"* ]]; then
    alias ls="ls --color=auto -ah"
    alias nvidia-smi-watch="watch -n0.01 nvidia-smi"
    alias open="xdg-open"
    alias self-control="chomper all 5760"
    alias screenshare="x11vnc -display :1 -noxrecord -noxfixes -noxdamage -forever -passwd fubar"

    alias minecraft-server="tmux-wrap 'sudo ufw reload; cd ~/minecraft_server; java -Xmx1024M -Xms1024M -jar server.jar nogui'; tmux attach"
    alias ip-private="hostname -I | awk '{print \$1}'"

    if [ `command -v docker` ]; then
        function docker-clean() {
            echo "killing running containers"
            docker kill $(docker ps -q)

            echo "removing extra containers"
            docker rm $(docker ps -a -q)

            echo "removing extra images"
            docker system prune -f
        }
    fi

    alias asdf-mount="trap 'asdf-umount' EXIT && encfs /media/lucastong/bulk_storage/.asdf ~/temp/asdf"
    alias asdf-umount="(cd ~; fuser -k ~/temp/asdf; fusermount -u ~/temp/asdf) &"
fi

alias ssh-scai="ssh -tt ucla 'ssh lucas_tong@scai1.cs.ucla.edu -i ~/.ssh/lab'"
alias ssh-scai-tunnel="ssh -L 16006:127.0.0.1:16006 -L 8889:127.0.0.1:8889 -tt ucla 'ssh -L 16006:127.0.0.1:16006 -L 8889:127.0.0.1:8889 lucas_tong@scai1.cs.ucla.edu -i ~/.ssh/lab'"
alias youtube-dl-mp3="youtube-dl --extract-audio --audio-format mp3"
alias youtube-dl="pip install --upgrade youtube-dl; youtube-dl --no-playlist -o '%(title)s.%(ext)s'"
alias glances="glances --fs-free-space -1"
alias grep="grep -i"
alias ip-public="curl ifconfig.me"

# alias tmux="tmux -2"
alias tmux-wrap="tmux new-session -d"
alias tmux-jupyter="tmux-wrap 'jupyter lab --no-browser'"
alias tmux-tensorboard="tmux-wrap 'tensorboard --logdir logs'"
alias tmux-tensorboard-pub="tmux-wrap 'tensorboard --logdir logs --host 0.0.0.0'"
alias tmux-env="tmux-jupyter && tmux-tensorboard"
alias pyenv-python3="\`pyenv which python3\`"
alias pyenv-python="\`pyenv which python\`"
alias git-reset-soft="git reset --soft HEAD~1"



function ssh_tunnel() {
    # creates a tmuxed ssh tunnel from ip address arg1, port arg2 to localhost, port arg3
    tmux-wrap "ssh -L $3:127.0.0.1:$2 $1"
}
