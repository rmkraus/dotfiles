### COLOR DEFINITIONS
# Define foreground colors
readonly _FG_BLACK="\[\033[0;30m\]"
readonly _FG_BLUE="\[\033[0;34m\]"
readonly _FG_BLUE_LT="\[\033[1;34m\]"
readonly _FG_BROWN="\[\033[0;33m\]"
readonly _FG_CYAN="\[\033[0;36m\]"
readonly _FG_CYAN_LT="\[\033[1;36m\]"
readonly _FG_GRAY="\[\033[1;30m\]"
readonly _FG_GRAY_LT="\[\033[0;37m\]"
readonly _FG_GREEN="\[\033[0;32m\]"
readonly _FG_GREEN_LT="\[\033[1;32m\]"
readonly _FG_PURPLE="\[\033[0;35m\]"
readonly _FG_PURPLE_LT="\[\033[1;35m\]"
readonly _FG_RED="\[\033[0;31m\]"
readonly _FG_RED_LT="\[\033[1;31m\]"
readonly _FG_WHITE="\[\033[1;37m\]"
readonly _FG_YELLOW="\[\033[1;33m\]"
# Define background colors
readonly _BG_BLACK="\[\033[0;40m\]"
readonly _BG_BLUE="\[\033[0;44m\]"
readonly _BG_BLUE_LT="\[\033[1;44m\]"
readonly _BG_BROWN="\[\033[0;43m\]"
readonly _BG_CYAN="\[\033[0;46m\]"
readonly _BG_CYAN_LT="\[\033[1;46m\]"
readonly _BG_GRAY="\[\033[1;40m\]"
readonly _BG_GRAY_LT="\[\033[0;47m\]"
readonly _BG_GREEN="\[\033[0;42m\]"
readonly _BG_GREEN_LT="\[\033[1;42m\]"
readonly _BG_PURPLE="\[\033[0;45m\]"
readonly _BG_PURPLE_LT="\[\033[1;45m\]"
readonly _BG_RED="\[\033[0;41m\]"
readonly _BG_RED_LT="\[\033[1;41m\]"
readonly _BG_WHITE="\[\033[1;47m\]"
readonly _BG_YELLOW="\[\033[1;43m\]"
# define color reset
readonly _NO_COLOR="\[\033[0m\]"


# what OS?
case "$(uname)" in
    Darwin)
        readonly _PS_SYMBOL=''
        ;;
    Linux)
        readonly _PS_SYMBOL='§'
        ;;
    *)
        readonly _PS_SYMBOL='%'
esac


# time function
function _time() {
    tput sc
    tput cup 0 $(($(tput cols)-5))
    date +%H:%M
    tput rc
}


# PS1 Calc function
function ps1() {
    # last exit bg color
    if [ $? -eq 0 ]; then
        local BG_EXIT="$_BG_GREEN"
        local FG_EXIT="$_FG_GREEN"
    else
        local BG_EXIT="$_BG_RED"
        local FG_EXIT="$_FG_RED"
    fi

    # print time if we can
    if hash tput 2>/dev/null; then
        printf "$(_time)"
    fi

    # set PS1
    PS1="${_FG_BLACK}${_BG_GRAY_LT} $(hostname -s) "
    PS1+="${_BG_CYAN}${_FG_WHITE} \w "
    PS1+="${BG_EXIT}${_FG_WHITE} $_PS_SYMBOL "
    PS1+="${_NO_COLOR} "
}


# Run function for each prompt
PROMPT_COMMAND=ps1
