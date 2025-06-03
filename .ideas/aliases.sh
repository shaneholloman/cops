#!/usr/bin/env bash

# Navigation Shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias docs="cd ~/Documents"
alias proj="cd ~/Projects"

# System Commands
alias ip="networksetup -getinfo Wi-Fi"
alias path='echo -e ${PATH//:/\\n}'
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# System Maintenance
alias update='echo "Running System Update" && \
    sudo softwareupdate -i -a && \
    echo "Running Homebrew Update" && \
    brew update && \
    brew upgrade && \
    brew cleanup'

alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes && \
    sudo rm -rfv ~/.Trash && \
    sudo rm -rfv /private/var/log/asl/*.asl && \
    sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# Finder Controls
alias showfiles="defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder"
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Spotlight Controls
alias spotoff="sudo mdutil -a -i off"
alias spoton="sudo mdutil -a -i on"

# Git Shortcuts
alias g="git"
alias gs="git status"
alias gp="git push"
alias gl="git pull"
alias gc="git commit"
alias gd="git diff"

# Development
alias py="python3"
alias pip="pip3"
alias serve="python3 -m http.server"

# Docker Shortcuts
alias dps="docker ps"
alias dimg="docker images"
alias dstop='docker stop $(docker ps -aq)'
alias dprune="docker system prune -af"

# Common Utils
alias ll="ls -la"
alias lt="ls -lat"
alias ports="sudo lsof -i -P | grep LISTEN"
alias pubkey="cat ~/.ssh/id_rsa.pub | pbcopy"
alias week='date +%V'
