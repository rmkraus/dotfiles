### COLOR DEFINITIONS
# Define foreground colors
readonly _FG_BLACK="\[\033[30m\]"
readonly _FG_CYAN="\[\033[36m\]"
readonly _FG_GRAY_LT="\[\033[37m\]"
readonly _FG_GREEN="\[\033[32m\]"
readonly _FG_RED="\[\033[31m\]"
readonly _FG_WHITE="\[\033[37m\]"
readonly _FG_PURPLE="\[\033[35m\]"
# Define background colors
readonly _BG_BLACK="\[\033[40m\]"
readonly _BG_CYAN="\[\033[46m\]"
readonly _BG_GRAY_LT="\[\033[47m\]"
readonly _BG_GREEN="\[\033[42m\]"
readonly _BG_RED="\[\033[41m\]"
readonly _BG_YELLOW="\[\033[103m\]"
readonly _BG_PURPLE="\[\033[45m\]"
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


# python virtual env function
function _find_venv() {
loop=1
start=$(pwd)

while [ $loop == 1 ]; do
    if [ -e */bin/activate ]; then
        loop=0
        file=$(ls */bin/activate | head -n1)
        found="$(pwd)/${file}"
    elif [ -e .*/bin/activate ]; then
        loop=0
        file=$(ls .*/bin/activate | head -n1)
        found="$(pwd)/${file}"
    elif [ "$(pwd)" == "/" ]; then
        loop=0
        found=""
    else
        cd ..
    fi
done

echo $found
cd "$start"
}


# time function
function _time() {
    tput sc
    tput cup 0 $(($(tput cols)-5))
    date +%H:%M
    tput rc
}


# PS1 Calc function
function ps1_real() {
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

    # load venv
    if [ -e "${VIRTUAL_ENV}" ]; then
        if [[ ! "$(pwd)" =~ "$(dirname ${VIRTUAL_ENV})".* ]]; then
            echo "Leaving Python Virtual Environment."
            deactivate
        fi
    fi
    if [ ! -e "${VIRTUAL_ENV}" ]; then
        source $(_find_venv) &> /dev/null
    fi

    PS1=""

    # get the python virtualenv
    if [ "$VIRTUAL_ENV" != "" ]; then
        venv=$(echo $(basename $VIRTUAL_ENV) | grep -v '^\.' || echo $(basename $(dirname $VIRTUAL_ENV)))
        PS1_VENV="${_BG_YELLOW}${_FG_CYAN}[ ${venv} ]"
    elif [ "$CONDA_PROMPT_MODIFIER" != "" ]; then
        PS1_VENV="${_BG_YELLOW}${_FG_CYAN} ${CONDA_PROMPT_MODIFIER}"
    else
        PS1_VENV=""
    fi
    PS1+=$PS1_VENV

    # get toolbox
    if [ -f "$TOOLBOX_PATH" ]; then
        PS1_TBX="${_BG_BLACK}${_FG_PURPLE}⬢ "
    else
        PS1_TBX=""
    fi
    PS1+=$PS1_TBX


    # set PS1 - part 1
    PS1+="${_FG_BLACK}${_BG_GRAY_LT} \\u@$(hostname -s)"
    PS1+="${_BG_CYAN}${_FG_WHITE}:\w "
    PS1+="${_NO_COLOR}"

    # decide b/w single or multi line
    _pwd=`pwd`
    if [ ${#_pwd} -gt 30 ]; then
        # two lines
        PS1="\n$PS1\n"
    fi

    # set PS1 - part 2
    PS1+="${BG_EXIT}${_FG_WHITE} $_PS_SYMBOL "
    PS1+="${_NO_COLOR} "
}

function ps1_joke() {
    # last exit bg color
    if [ $? -eq 0 ]; then
        local BG_EXIT="$_BG_GREEN"
        local FG_EXIT="$_FG_GREEN"
    else
        local BG_EXIT="$_BG_RED"
        local FG_EXIT="$_FG_RED"
    fi

    # set PS1 - part 1
    PS1=""
    PS1+="${_FG_BLACK}${_BG_GRAY_LT} whoami@hostname"
    PS1+="${_BG_CYAN}${_FG_WHITE}:pwd "
    PS1+="${_NO_COLOR}"
    PS1+="${BG_EXIT}${_FG_WHITE} $_PS_SYMBOL "
    PS1+="${_NO_COLOR} "

    # load venv
    if [ ! -e "${VIRTUAL_ENV}" ]; then
        source $(_find_venv) &> /dev/null
    fi

}

# Run function for each prompt
if [ `date +%m%d` == "0401" ]; then
    PROMPT_COMMAND=ps1_joke
else
    PROMPT_COMMAND=ps1_real
fi
