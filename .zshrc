################################################################
##################### ZSH CONFIGURATION FILE FOR ###############
####################### DIANA LOCAL MACHINE ####################
################################################################

# export PATH="$PATH:$HOME/.lewel/bin"
# lewel # run lewel

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zmodload zsh/zprof #zsh profiling module
export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="/root/.oh-my-zsh"

# Homebrew
export BREW_HOME="/home/linuxbrew/.linuxbrew/bin"
export PATH="$PATH:$BREW_HOME"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Standard plugins: $ZSH/plugins/, Custom plugins: $ZSH_CUSTOM/plugins/
plugins=(git)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

POWERLEVEL9K_DISABLE_GITSTATUS=true
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last

# colorls in ~/.config/colorls

# aliases
alias open="explorer.exe $1"
alias ipx="curl ifconfig.me"
# alias ls="colorls"
# alias lA="colorls -A"
alias rmr="rm -r"
alias h=history
alias restart="clear; exec zsh"
alias downloads="cd ~/Downloads; lA"
alias desktop="cd ~/Desktop; lA"
alias zshrc="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
alias vimrc="code ~/.vimrc"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
# zshmarks
alias save="bookmark"
alias del="deletemark"
alias go="jump"
alias bms="showmarks"
# escape sequences
END="\x1b[0m"
BOLD="\x1b[1m"
ITALIC="\x1b[3m"
UNDERLINE="\x1b[4m"
declare -A normal=(
    [BLACK]="\x1b[30m"
    [RED]="\x1b[31m"
    [GREEN]="\x1b[32m"
    [YELLOW]="\x1b[33m"
    [BLUE]="\x1b[34m"
    [MAGENTA]="\x1b[35m"
    [CYAN]="\x1b[36m"
    [WHITE]="\x1b[37m"
)
declare -A light=(
    [BLACK]="\x1b[90m"
    [RED]="\x1b[91m"
    [GREEN]="\x1b[92m"
    [YELLOW]="\x1b[93m"
    [BLUE]="\x1b[94m"
    [MAGENTA]="\x1b[95m"
    [CYAN]="\x1b[96m"
    [WHITE]="\x1b[97m"
)

# functions
function bm() { # Displays bookmark commands
    echo "save   <bookmark>   - Saves current directory as bookmark"
    echo "del    <bookmark>   - Deletes bookmark"
    echo "go     <bookmark>   - Cd to the directory"
    echo "bms                 - Lists all available bookmarks"
}

function cmds() { # Displays all frequently used CLI functions
    printf "\n"
    echo " $BOLD${light[GREEN]}cdn        $END${light[YELLOW]}- go up a parent, therein x is repeat value"
    echo " $BOLD${light[GREEN]}mkd        $END${light[YELLOW]}- create directories and open them"
    echo " $BOLD${light[GREEN]}rp         $END${light[YELLOW]}- repeats commands. syntax: rp x [given command]"
    echo " $BOLD${light[GREEN]}gitall     $END${light[YELLOW]}- pushes current repository to github"
    echo " $BOLD${light[GREEN]}gitinit    $END${light[YELLOW]}- creates new repository given url"
    echo " $BOLD${light[GREEN]}gityuck    $END${light[YELLOW]}- hard fixes collision issue if ahead of branch"
    echo " $BOLD${light[GREEN]}gitcache   $END${light[YELLOW]}- caches gh user token for about a week time"
    echo " $BOLD${light[GREEN]}bm         $END${light[YELLOW]}- shows all bookmark commands"
    echo " $BOLD${light[GREEN]}zprof      $END${light[YELLOW]}- zsh profiling module"
    echo " $BOLD${light[GREEN]}alias      $END${light[YELLOW]}- show all active aliases"
    echo " $BOLD${light[GREEN]}showcolor  $END${light[YELLOW]}- displays xterm 256 color block int:[1] or all"
    echo " $BOLD${light[GREEN]}rgbto      $END${light[YELLOW]}- converts RGB to xterm 256 color"
    echo " $BOLD${light[GREEN]}round      $END${light[YELLOW]}- rounds either [1] or [1][2] division to nearest int"
    echo " $BOLD${light[GREEN]}ipx        $END${light[YELLOW]}- gets external ip address"
    echo " $BOLD${light[GREEN]}ncdu       $END${light[YELLOW]}- surveys current directory disk usage"
    echo " $BOLD${light[GREEN]}zshrc      $END${light[YELLOW]}- opens zsh config file"
    printf "$END\n"
}

function cdn() { # Ascend directory [n] amount of times
    for i in `seq $1`; do
        cd ..
    done
}

function rp() { # Repeats a command [n] amount of times
    local i=1 max=$1
    shift # passes [n] and shifts to command
    for ((; i <= max ; i++)); do
        eval "$@" # evaluates remaining args
    done
}

function gitall() { # Simple github directory push with custom message
    echo -n "${normal[YELLOW]}!!! WARNING !!!\n\n${light[RED]}You're about to push to a remote github repository.\nAre you sure you wanna make these changes?${END} [${normal[GREEN]}yes${END} / ${normal[RED]}no${END}] ${light[YELLOW]}"
    read RESPONSE
    printf "${END}\n"
    case $RESPONSE in
        [yY][eE][sS] | [yY])
            echo -n "${light[YELLOW]}Include your message: ${light[BLUE]}"
            read MESSAGE
            printf "${END}\n${light[GREEN]}"
            git add -A; git commit -m "$MESSAGE"; git push
            printf "$END"
            ;;
        *)
            echo "${light[RED]}u answered no or something else lmao. exiting...${END}"
            ;;
    esac
}

function gitinit() { # Initializes project in new GH repository
    git init
    git add .
    git commit -m "initialized"
    git remote add origin $1
    git remote -v
    git push --set-upstream origin master
}

function gityuck() {
    git reset --hard HEAD
    git pull
}

function gitcache() { # Caches GH credentials for up to one week
    git config --global credential.helper cache
    git config --global credential.helper 'cache --timeout=600000'
}

function mkd() { # Makes directory with name and cds to it
    mkdir -p $1; cd $1
    echo $light[GREEN]"directory \""$1"\" is created."$END
}


function showcolor() {  # show specific color or all
    if [[ $# -eq 0 ]]; then
        for i in {0..254}; do
            echo -n "\x1b[48;5;${i}m $i "
        done; echo "\x1b[48;5;255m 255 \x1b[0m"
    else
        echo "\x1b[48;5;$1m  \x1b[0m"
    fi
}

function round() { # Rounds [1] or [1][2] to nearest int
    if [[ $# -eq 1 ]]; then
        local mod=$(( $1 % 1 ))
        if [[ $mod -ne 0 ]]; then
            if [[ $mod -ge 0.5 ]]; then
                local to=$(( 1 - $mod ))
                local rnd=$(( $1 + $to ))
                echo $(bc <<< "scale=0;$rnd/1")
            else
                local rnd=$(( $1 - $mod ))
                echo $(bc <<< "scale=0;$rnd/1")
            fi
        else
            echo $1
        fi
    else
        local rounder=$(( $2 / 2 ))
        local numerator=$(( $1 + $rounder )) denominator=$2
        echo $(( $numerator / $denominator ))
    fi
}

function rgbto() { # Converts RGB to xterm 256
    if [[ $1 == $2 && $2 == $3 ]]; then
        if [[ $1 < 8 ]]; then
            echo "16"
        elif [[ $1 > 248 ]]; then
            echo "231"
        else
            local val1=$(($1 - 8))
            local val2=$(( $(round $val1 247) * 24 ))
            echo $(( $val2 + 232 ))
        fi
    else
        local red=$((16 + 36 * $(round $(bc <<< "scale=2; ($1/255*5)"))))
        local green=$((6 * $(round $(bc <<< "scale=2; ($2/255*5)"))))
        local blue=$(round $(bc <<< "scale=2; ($3/255*5)"))
        echo -n "color: "
        echo -n "[${normal[RED]}$red ${normal[GREEN]}$green ${normal[BLUE]}$blue$END]"
        echo " > ${normal[YELLOW]}${BOLD}$(( $red + $green + $blue ))$END"
    fi
}

# ZSH command highlighting
source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh