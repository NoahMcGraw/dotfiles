#!/usr/bin/env bash

# git-shortcuts.bash
#
# A collection of git shortcuts for bash.


# Function to chain git commands
__git_chain() {
    local cmd=""
    local input=${1#g}  # Remove the leading 'g'
    shift
    local args=("$@")
    local current_flag=""
    local command_args=()
    
    # Parse flags and their arguments
    declare -A flag_args
    for arg in "${args[@]}"; do
        if [[ $arg == -* ]]; then
            current_flag="${arg:1}"  # Remove the leading dash
        else
            if [ -n "$current_flag" ]; then
                flag_args[$current_flag]="$arg"
                current_flag=""
            fi
        fi
    done

    while [ -n "$input" ]; do
        case "${input:0:2}" in
            co) 
                local msg=${flag_args[co]:-""}
                cmd+="git commit -m \"$msg\" && "
                input="${input:2}"
                ;;
            pl) cmd+="git pull && "; input="${input:2}";;
            ps) cmd+="git push && "; input="${input:2}";;
            ch) 
                local branch=${flag_args[ch]:-""}
                cmd+="git checkout $branch && "
                input="${input:2}"
                ;;
            st) cmd+="git stash && "; input="${input:2}";;
            *)
                case "${input:0:1}" in
                    a) cmd+="git add -A && "; input="${input:1}";;
                    d) cmd+="git diff && "; input="${input:1}";;
                    r) 
                        local branch=${flag_args[r]:-""}
                        cmd+="git rebase $branch && "
                        input="${input:1}"
                        ;;
                    m) 
                        local branch=${flag_args[m]:-""}
                        cmd+="git merge $branch && "
                        input="${input:1}"
                        ;;
                    b) cmd+="git branch && "; input="${input:1}";;
                    s) cmd+="git status && "; input="${input:1}";;
                    *) input="${input:1}";;
                esac
                ;;
        esac
    done
    cmd=${cmd% && }
    eval $cmd
}

# Set the maximum number of commands you want to chain
MAX_CHAIN_LENGTH=5

# Build the brace expansion pattern dynamically
PATTERN="{"
COMMANDS="a,co,pl,ps,ch,st,d,r,m,b,s"
for ((i=1; i<=MAX_CHAIN_LENGTH; i++)); do
    if [ $i -eq 1 ]; then
        PATTERN+="$COMMANDS"
    else
        PATTERN+="}{"
        PATTERN+=",$COMMANDS"
    fi
done
PATTERN+="}"

# Create dynamic aliases for all possible combinations starting with 'g'
eval "for cmd in $PATTERN; do alias \"g\$cmd=__git_chain g\$cmd\"; done"
