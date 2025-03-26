#!/usr/bin/env bash

# git-shortcuts.bash
#
# A collection of git shortcuts for bash.

# Basic git shortcuts
# alias gs="git status"
# alias gch="git checkout"
# alias ga="git add -A"
# alias gaco="git add -A && git commit -m"
# alias gco="git commit -m"
# alias gpl="git pull"
# alias gps="git push"
# alias gd="git diff"
# alias gr="git rebase"
# alias gm="git merge"
# alias gb="git branch"
# alias gsts="git stash"

# Function to chain git commands
g() {
    if [ $# -eq 0 ]; then
        git status  # Default behavior if no arguments
        return
    fi
    

    local cmd=""
    for part in $(echo "$1" | grep -o '.'); do
        case $part in
            s) cmd="$cmd git status &&";;
            a) cmd="$cmd git add -A &&";;
            c) cmd="$cmd git commit -m \"$2\" &&";;
            ">") cmd="$cmd git push &&";;
            "<") cmd="$cmd git pull &&";;
            "-") cmd="$cmd git stash &&";;
            "~") cmd="$cmd git checkout &&";;
            d) cmd="$cmd git diff &&";;
            r) cmd="$cmd git rebase &&";;
            m) cmd="$cmd git merge &&";;
            b) cmd="$cmd git branch &&";;
            *) echo "Unknown command: $part"; return 1;;
        esac
    done
    cmd=${cmd%" &&"}  # Remove the trailing &&
    eval $cmd
}
