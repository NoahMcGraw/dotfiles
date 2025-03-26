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
    local next_positional=0
    
    # Parse flags and their arguments
    declare -A flag_args
    for arg in "${args[@]}"; do
        if [[ $arg == -* ]]; then
            current_flag="${arg:1}"  # Remove the leading dash
        else
            if [ -n "$current_flag" ]; then
                flag_args[$current_flag]="$arg"
                current_flag=""
            else
                # Store positional args with numeric keys
                flag_args[$next_positional]="$arg"
                ((next_positional++))
            fi
        fi
    done

    # Track which positional args have been used
    local pos_arg_index=0

    while [ -n "$input" ]; do
        case "${input:0:2}" in
            co) 
                local msg=${flag_args[co]:-${flag_args[$pos_arg_index]:-""}}
                cmd+="git commit -m \"$msg\" && "
                [[ -z ${flag_args[co]} ]] && ((pos_arg_index++))
                input="${input:2}"
                ;;
            pl) cmd+="git pull && "; input="${input:2}";;
            ps) cmd+="git push && "; input="${input:2}";;
            ch) 
                local branch=${flag_args[ch]:-${flag_args[$pos_arg_index]:-""}}
                cmd+="git checkout $branch && "
                [[ -z ${flag_args[ch]} ]] && ((pos_arg_index++))
                input="${input:2}"
                ;;
            st) cmd+="git stash && "; input="${input:2}";;
            *)
                case "${input:0:1}" in
                    a) cmd+="git add -A && "; input="${input:1}";;
                    d) cmd+="git diff && "; input="${input:1}";;
                    r) 
                        local branch=${flag_args[r]:-${flag_args[$pos_arg_index]:-""}}
                        cmd+="git rebase $branch && "
                        [[ -z ${flag_args[r]} ]] && ((pos_arg_index++))
                        input="${input:1}"
                        ;;
                    m) 
                        local branch=${flag_args[m]:-${flag_args[$pos_arg_index]:-""}}
                        cmd+="git merge $branch && "
                        [[ -z ${flag_args[m]} ]] && ((pos_arg_index++))
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
