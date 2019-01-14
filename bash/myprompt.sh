### COLOR DEFINITIONS
# Define foreground colors
readonly _FG_BLACK="\[\033[30m\]"
readonly _FG_CYAN="\[\033[36m\]"
readonly _FG_GRAY_LT="\[\033[37m\]"
readonly _FG_GREEN="\[\033[32m\]"
readonly _FG_RED="\[\033[31m\]"
readonly _FG_WHITE="\[\033[37m\]"
# Define background colors
readonly _BG_CYAN="\[\033[46m\]"
readonly _BG_GRAY_LT="\[\033[47m\]"
readonly _BG_GREEN="\[\033[42m\]"
readonly _BG_RED="\[\033[41m\]"
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
    # if hash tput 2>/dev/null; then
    #     printf "$(_time)"
    # fi

    # set PS1
    PS1="${_FG_BLACK}${_BG_GRAY_LT} \\u@$(hostname -s)"
    PS1+="${_BG_CYAN}${_FG_WHITE}:\w "
    PS1+="${BG_EXIT}${_FG_WHITE} $_PS_SYMBOL "
    PS1+="${_NO_COLOR} "
}


# Run function for each prompt
PROMPT_COMMAND=ps1
