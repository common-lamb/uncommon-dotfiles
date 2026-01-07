#### .bashrc is sourced on shell startup
# errors, exit commands, and sometimes text output will bork your login/ssh access/subshells to varying degrees
# if login is exiting then sudo is your only hope ( we <3 sysadmins)
# rename a copy to test changes! 
#
#### all accidental output in this file is redirected in non interactive mode
# if [[ $- != *i* ]];
# then
    # exec &> ~/TEST_muted_bashrc_OP.txt
    # exec &> /dev/null
# fi

#### session type flags
# when ~/.bashrc exists
if [[ -f ~/.bashrc ]];
then every_session=1
else every_session=0
fi

# ssh access, console login, bash --login, 
if shopt -q login_shell 2> /dev/null;
then login_session=1
else login_session=0
fi

# open new terminal, run bash from terminal, ./x script execution, shebang scripts, subshells, command substition,
if [[ !${login_session} ]];
then nonlogin_session=1
else nonlogin_session=0
fi

# user entry at prompt,
if [[ $- == *i* ]];
then interactive_session=1
else interactive_session=0
fi

# running scripts, piped commands, background scripts, cron jobs, remote ssh execution, here docs,
if [[ !${interactive_session} ]];
then noninteractive_session=1
else noninteractive_session=0
fi

#### contextual shell setup

if (( ${every_session} )); 
then 
    : # NOOP in case of empty block
    # Always executed 
    # General configuration 
    # MUST not create any output!
    #
    # non user facing environment variables
    #  PATH modifications
    #  TMPDIR
    #  TMP
    #  TEMP
    #  LC_* locale specifications
    #  JAVA_HOME, CARGO_HOME application specific variables
    #
    # non interactive shell configuration
    #   umask
    #   ulimit
    #
    #
    
    # unofficial strict mode
    # http://redsymbol.net/articles/unofficial-bash-strict-mode/
    set -euo pipefail
    IFS=$'\n\t'
    
    set -o notify
    set -o noclobber # Prevent accidental overwrites when using > IO redirection
    set -o ignoreeof
    
    # umask 0022 # Give others in your group read but (no write or execute) permissions upon file/folder creation
    
    #
fi  # end every_session

if (( ${login_session} )); 
then
    : # NOOP in case of empty block
    # These are executed only when it is a login shell
    # 
    # login time operations
    #   check mail
    #   start ssh-agent
    #   load environment modules
    #   other low freq ops
    #
    echo "login shell"
fi  # end login_session

if (( ${interactive_session} )); 
then 
    : # NOOP in case of empty block
    # These are executed only for interactive shells
    #
    # user facing environment variables
    #  EDITOR 
    #  VISUAL 
    #  PAGER
    #  LANG
    #  MANPATH
    #  INFOPATH
    #  XDG_* directory specifications
    # 
    # load heavy tools for cozy work
    # load interactive tools
    # set shopt
    # set history manipulation
    # set completion
    # set prompt
    
    # specific bin directories to PATH
    export PATH=$JAVA_HOME/bin:$PATH
    export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
    
    ###############################
    ## Export
    ###############################
    
    export EDITOR=emacs # Set default editor
    export MANPATH="/usr/share/man:/usr/local/man:/usr/local/local_dfs/man" # Where to search for manual pages
    export PAGER=less # Which pager to use.
    export TERM=xterm-color # Enables displaying colors in the terminal
    export JAVA_HOME=/usr/lib/jvm/java - 11 - openjdk - amd64
    
    # Tailoring 'less'
    export PAGER=less
    export LESSCHARSET='latin1'
    export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-' # Use this if lesspipe.sh exists.
    export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \
    :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'
    
    # LESS man page colors (makes Man pages more readable).
    export LESS_TERMCAP_mb=$'\E[01;31m'
    export LESS_TERMCAP_md=$'\E[01;31m'
    export LESS_TERMCAP_me=$'\E[0m'
    export LESS_TERMCAP_se=$'\E[0m'
    export LESS_TERMCAP_so=$'\E[01;44;33m'
    export LESS_TERMCAP_ue=$'\E[0m'
    export LESS_TERMCAP_us=$'\E[01;32m'
    
    ###############################
    ## Set options
    ###############################
    
    # Enable options:
    shopt -s cdspell # Automatically correct mistyped 'cd' directories
    shopt -s checkwinsize # Check window size after each command
    shopt -s cdable_vars
    shopt -s checkhash
    shopt -s sourcepath
    shopt -s no_empty_cmd_completion
    shopt -s extglob       # Necessary for programmable completion.
    
    # Disable options:
    shopt -u mailwarn
    unset MAILCHECK # Disable automatic mail checking
    tty -s && mesg n # If this is an interactive console, disable messaging
    ulimit -S -c 0 # Don't want coredumps.
    
    
    ###############################
    # History 
    ###############################

    # never ending history
    HISTSIZE= # Number of commands to remember in history
    HISTFILESIZE= # Max size of the history file
    export HISTTIMEFORMAT="[%F %T] "
    export HISTFILE=~/.bash_eternal_history
    PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
    # Avoid duplicates
    export HISTCONTROL=ignoredups:erasedups
    export HISTCONTROL=ignoreboth # Ignore duplicate and space-prefixed commands
    # After each command, append to the history file and reread it and also add the pwd
    # export PROMPT_COMMAND='hpwd=$(history 1); hpwd="${hpwd# *[0-9]*  }"; if [[ ${hpwd%% *} == "cd" ]]; then cwd=$OLDPWD; else cwd=$PWD; fi; hpwd="${hpwd% ### *} ### $cwd"; history -s "$hpwd"; history -a; history -c; history -r'
    # export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
    export HISTIGNORE="&:bg:fg:ll:h"
    
    # History settings
    shopt -s histverify # edit the command before executing it when using command history expansion.
    shopt -s histappend # Append to history file instead of overwriting
    shopt -s cmdhist
    shopt -s histreedit 
    
    ###############################
    ## Alias
    ###############################
    
    # Prevents accidentally clobbering files.
    alias rm='rm -i'
    alias cp='cp -i'
    alias mv='mv -i'
    
    alias debug="set -o nounset; set -o xtrace" # These  two options are useful for debugging.
    # turn off &&&
    
    alias table='column  -t | less -S'  # this produces better columns for output cat file | table
    alias whitespace="sed 's/ /·/g;s/\t/￫/g;s/\r/§/g;s/$/¶/g'"  # show the whitespaces in a file
    
    alias pwd='pwd -P'                  # always show the full path and not softlinked path to folder
    
    
    # File and folder size
    alias du='du -kh'                   # Makes a more readable output.
    alias df='df -kTh'
    alias dd='du -sch *'
    alias dG='du -hs * | awk '$1~"G"''  #show all files/folders with a size in the Gigabytes
    alias dT='du -hs * | awk '$1~"T"''  #show all files/folders with a size in the Terabytes
    
    #-------------------------------------------------------------
    # The 'ls' family (this assumes you use a recent GNU ls).
    #-------------------------------------------------------------
    
    alias ls='ls --color=auto -h -v' # Add colors for filetype and  human-readable sizes by default on 'ls':
    alias lx='ls -lXB'         #  Sort by extension.
    alias lk='ls -lSr'         #  Sort by size, biggest last.
    alias lt='ls -ltr'         #  Sort by date, most recent last.
    alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
    alias lu='ls -ltur'        #  Sort by/show access time,most recent last.
    
    # The ubiquitous 'll': directories first, with alphanumeric sorting:
    alias ll="ls -lv --group-directories-first"
    alias lm='ll |more'        #  Pipe through 'more'
    alias lr='ll -R'           #  Recursive ls.
    alias la='ll -A'           #  Show hidden files.
    alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...
    
    # shortcuts for ls
    alias l='ls -CF'
    alias ll='ls -l'
    alias lf='ls -algF'
    alias lh='ls -lh'          # sort in readable way
    alias la='ls -AlL'         # show hidden files and show size of files that are softlinked
    alias lx='ls -lXB'         # sort by extension
    alias lk='ls -lSr'         # sort by size, biggest last
    alias lc='ls -ltcr'        # sort by and show change time, most recent last
    alias lu='ls -ltur'        # sort by and show access time, most recent last
    alias lt='ls -ltr'         # sort by date, most recent last
    alias lm='ls -al |more'    # pipe through 'more'
    alias lr='ls -lR'          # recursive ls
    alias ld='ls -d */'        # list directories only
    alias lsr='tree -Csu'      # nice alternative to 'recursive ls'
    alias dirtree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"
    
    #git shortcuts
    alias git-commit-count="git log --pretty=format:'' | wc -l"
    alias gc='git commit -m'
    alias gpom='git push origin main'
    alias gpomr='git push origin master'
    alias ga='git add'
    alias gpr='find . -type d -name .git -exec sh -c "cd \"{}\"/../ && pwd && git pull" \;'
    alias gclone='git clone git clone git@github.com:GITHUBID/$1'  # update your gitorganization or ID here
    alias gittree="git log --all --decorate --oneline --graph"  # commandline push history
    
    # HPC
    alias si="sinfo -o \"%20P %5D %14F %8z %10m %10d %11l %16f %N\""
    alias sq="squeue -o \"%8i %30j %4t %10u %20q %20a %10g %20P %10Q %5D %11l %11L %R %Z\""
    alias sacct='sacct --format JobID,Partition,Timelimit,Start,Elapsed,NodeList%20,ExitCode,ReqMem,MaxRSS,MaxVMSize,AllocCPUS'
    
    # Aliases for common commands
    alias c='clear'
    alias h='history'
    alias j='jobs -l'
    alias grep='grep --color=auto' # add color to grep
    
    alias which='type -a'
    alias ..='cd ..'
    
    # Pretty-print of some PATH variables:
    alias path='echo -e ${PATH//:/\\n}'
    alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
    
    ###############################
    #  Colour defs
    ###############################
    
    # Color definitions (taken from Color Bash Prompt HowTo).
    # Some colors might look different of some terminals.
    # For example, I see 'Bold Red' as 'orange' on my screen,
    # hence the 'Green' 'BRed' 'Red' sequence I often use in my prompt.
    
    # Normal Colors
    Black='\e[0;30m'        # Black
    Red='\e[0;31m'          # Red
    Green='\e[0;32m'        # Green
    Yellow='\e[0;33m'       # Yellow
    Blue='\e[0;34m'         # Blue
    Purple='\e[0;35m'       # Purple
    Cyan='\e[0;36m'         # Cyan
    White='\e[0;37m'        # White
    
    # Bold
    BBlack='\e[1;30m'       # Black
    BRed='\e[1;31m'         # Red
    BGreen='\e[1;32m'       # Green
    BYellow='\e[1;33m'      # Yellow
    BBlue='\e[1;34m'        # Blue
    BPurple='\e[1;35m'      # Purple
    BCyan='\e[1;36m'        # Cyan
    BWhite='\e[1;37m'       # White
    
    # Background
    On_Black='\e[40m'       # Black
    On_Red='\e[41m'         # Red
    On_Green='\e[42m'       # Green
    On_Yellow='\e[43m'      # Yellow
    On_Blue='\e[44m'        # Blue
    On_Purple='\e[45m'      # Purple
    On_Cyan='\e[46m'        # Cyan
    On_White='\e[47m'       # White
    
    NC="\e[m"               # Color Reset
    
    ALERT=${BWhite}${On_Red} # Bold White on red background
    
    # Enable color support for `ls` 
    if [ -x /usr/bin/dircolors ]; then
        eval "$(dircolors -b)"
    fi
    
    ###############################
    # Shell Prompt 
    ###############################
    
    # must be after colour defs
    
    #-------------------------------------------------------------
    #       for many examples, see:
    #       http://www.debian-administration.org/articles/205
    #       http://www.askapache.com/linux/bash-power-prompt.html
    #       http://tldp.org/HOWTO/Bash-Prompt-HOWTO
    #       https://github.com/nojhan/liquidprompt
    #-------------------------------------------------------------
    
    # Current Format: [TIME USER@HOST PWD] >
    # TIME:
    #    Green     == machine load is low
    #    Orange    == machine load is medium
    #    Red       == machine load is high
    #    ALERT     == machine load is very high
    # USER:
    #    Cyan      == normal user
    #    Orange    == SU to user
    #    Red       == root
    # HOST:
    #    Cyan      == local session
    #    Green     == secured remote connection (via ssh)
    #    Red       == unsecured remote connection
    # PWD:
    #    Green     == more than 10% free disk space
    #    Orange    == less than 10% free disk space
    #    ALERT     == less than 5% free disk space
    #    Red       == current user does not have write privileges
    #    Cyan      == current filesystem is size zero (like /proc)
    # >:
    #    White     == no background or suspended jobs in this shell
    #    Cyan      == at least one background job in this shell
    #    Orange    == at least one suspended job in this shell
    #
    #    Command is added to the history file each time you hit enter,
    #    so it's available to all shells (using 'history -a').
    
    # Test connection type:
    if [ -n "${SSH_CONNECTION}" ]; then
        CNX=${Green}        # Connected on remote machine, via ssh (good).
    elif [[ "${DISPLAY%%:0*}" != "" ]]; then
        CNX=${ALERT}        # Connected on remote machine, not via ssh (bad).
    else
        CNX=${BCyan}        # Connected on local machine.
    fi
    
    # Test user type:
    if [[ ${USER} == "root" ]]; then
        SU=${Red}           # User is root.
    elif [[ ${USER} != $(logname) ]]; then
        SU=${BRed}          # User is not login user.
    else
        SU=${BCyan}         # User is normal (well ... most of us are).
    fi
    
    NCPU=$(grep -c 'processor' /proc/cpuinfo)    # Number of CPUs
    SLOAD=$(( 100*${NCPU} ))        # Small load
    MLOAD=$(( 200*${NCPU} ))        # Medium load
    XLOAD=$(( 400*${NCPU} ))        # Xlarge load
    
    # Returns system load as percentage, i.e., '40' rather than '0.40)'.
    function load()
    {
        local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')
        # System load of the current host.
        echo $((10#$SYSLOAD))       # Convert to decimal.
    }
    
    # Returns a color indicating system load.
    function load_color()
    {
        local SYSLOAD=$(load)
        if [ ${SYSLOAD} -gt ${XLOAD} ]; then
            echo -en ${ALERT}
        elif [ ${SYSLOAD} -gt ${MLOAD} ]; then
            echo -en ${Red}
        elif [ ${SYSLOAD} -gt ${SLOAD} ]; then
            echo -en ${BRed}
        else
            echo -en ${Green}
        fi
    }
    
    # Returns a color according to free disk space in $PWD.
    function disk_color()
    {
        if [ ! -w "${PWD}" ] ; then
            echo -en ${Red}
            # No 'write' privilege in the current directory.
        elif [ -s "${PWD}" ] ; then
            local used=$(command df -P "$PWD" |
                       awk 'END {print $5} {sub(/%/,"")}')
            if [ ${used} -gt 95 ]; then
                echo -en ${ALERT}           # Disk almost full (>95%).
            elif [ ${used} -gt 90 ]; then
                echo -en ${BRed}            # Free disk space almost gone.
            else
                echo -en ${Green}           # Free disk space is ok.
            fi
        else
            echo -en ${Cyan}
            # Current directory is size '0' (like /proc, /sys etc).
        fi
    }
    
    # Returns a color according to running/suspended jobs.
    function job_color()
    {
        if [ $(jobs -s | wc -l) -gt "0" ]; then
            echo -en ${BRed}
        elif [ $(jobs -r | wc -l) -gt "0" ] ; then
            echo -en ${BCyan}
        fi
    }
    
    # Adds some text in the terminal frame (if applicable).
    
    # Now we construct the prompt.
    PROMPT_COMMAND="history -a"
    case ${TERM} in
      *term | rxvt | linux)
            PS1="\[\$(load_color)\][\A\[${NC}\] "
            # Time of day (with load info):
            PS1="\[\$(load_color)\][\A\[${NC}\] "
            # User@Host (with connection type info):
            PS1=${PS1}"\[${SU}\]\u\[${NC}\]@\[${CNX}\]\h\[${NC}\] "
            # PWD (with 'disk space' info):
            PS1=${PS1}"\[\$(disk_color)\]\W]\[${NC}\] "
            # Prompt (with 'job' info):
            PS1=${PS1}"\[\$(job_color)\]>\[${NC}\] "
            # Set title of current xterm:
            PS1=${PS1}"\[\e]0;[\u@\h] \w\a\]"
            ;;
        *)
            PS1="(\A \u@\h \W) > " # --> PS1="(\A \u@\h \w) > "
                                   # --> Shows full pathname of current dir.
            ;;
    esac
    
    echo "Welcome, $USER! Today is $(date)."

fi  # end interactive_session

if (( ${noninteractive_session} )); 
then 
    : # NOOP in case of empty block
    # Only for non-interactive shells
    # MUST not create any output!
    # keep it light or subshells and pipes slow down 
fi

if (( ${nonlogin_session} )); 
then
    : # NOOP in case of empty block
    # executed only when it is NOT a login shell
    # should not produce any output
    # keep it light or script calls slow down
fi

#### Unguarded execution below 
#
# Always executed 
# General configuration 
# MUST not create any output!
#
#### function defs


#-------------------------------------------------------------
# File & strings related functions:
#-------------------------------------------------------------

# Make your directories and files access rights sane.
function sanitize() { chmod -R u=rwX,g=rX,o= "$@" ;}

# make and enter dir
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Creates an archive (*.tar.gz) from given directory.
function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }

# Create a ZIP archive of a file or folder.
function makezip() { zip -r "${1%%/}.zip" "$1" ; }


function extract() {
   if [ -f "$1" ]; then
       case "$1" in
           *.gz) gunzip "$1" ;;
           *.tar) tar xvf "$1" ;;
           *.tar.gz) tar xvzf "$1" ;;
           *.tar.bz2) tar xvjf "$1" ;;
           *.tar.xz) tar xJvf $1     ;;
           *.tbz2) tar xvjf "$1" ;;
           *.tgz) tar xvzf "$1" ;;
           *.bz2) bunzip2 "$1" ;;
           *.rar) unrar x "$1" ;;
           *.zip) unzip "$1" ;;
           *.Z) uncompress "$1" ;;
           *.7z) 7z x "$1" ;;
           *) echo "Cannot extract '$1'" ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
}

# Swap 2 filenames around, if they exist (from Uzi's bashrc).
function swap() { 
    local TMPFILE=tmp.$$

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

# Find a dir with a pattern in name:
function fd() { find $(pwd -P) -type d -iname '*'$*'*' -ls ; }

# Find a file with a pattern in name:
function ff() { find $(pwd -P) -type f -iname '*'$*'*' -ls ; }
# function ff() { find . -type f -iname '*'"$*"'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
function fe() { find . -type f -iname '*'"${1:-}"'*' \
-exec ${2:-file} {} \;  ; }

# Find a pattern in a set of files and highlight them: (needs a recent version of egrep).
function fstr() {
    OPTIND=1
    local mycase=""
    local usage="fstr: find string in files. Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "
    while getopts :it opt
    do
        case "$opt" in
           i) mycase="-i " ;;
           *) echo "$usage"; return ;;
        esac
    done
    shift $(( $OPTIND - 1 ))
    if [ "$#" -lt 1 ]; then
        echo "$usage"
        return;
    fi
    find . -type f -name "${2:-*}" -print0 | \
	    xargs -0 egrep --color=always -sn ${case} "$1" 2>&- | more
}

# puts line number for grep matches, but only when it is at the end of the pipe
function grep() {
      if [[ -t 1 ]]; then
          command grep -n "$@"
      else
          command grep "$@"
      fi
  }

#-------------------------------------------------------------
# Process/system related functions:
#-------------------------------------------------------------

session_type() {
    echo "Session Type"
    echo " every: ${every_session}"
    echo " interactive: ${interactive_session}"
    echo " noninteractive: ${noninteractive_session}"
    echo " login: ${login_session}"
    echo " nonlogin: ${nonlogin_session}"
}

function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }

function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }

function killps()   # kill by process name
{
    local pid pname sig="-TERM"   # default signal
    if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
        echo "Usage: killps [-SIGNAL] pattern"
        return;
    fi
    if [ $# = 2 ]; then sig=$1 ; fi
    for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat=${!#} )
    do
        pname=$(my_ps | awk '$1~var { print $5 }' var=$pid )
        if ask "Kill process $pid <$pname> with signal $sig?"
            then kill $sig $pid
        fi
    done
}

function mydf()         # Pretty-print of 'df' output.
{                       # Inspired by 'dfc' utility.
    for fs ; do

        if [ ! -d $fs ]
        then
          echo -e $fs" :No such file or directory" ; continue
        fi

        local info=( $(command df -P $fs | awk 'END{ print $2,$3,$5 }') )
        local free=( $(command df -Pkh $fs | awk 'END{ print $4 }') )
        local nbstars=$(( 20 * ${info[1]} / ${info[0]} ))
        local out="["
        for ((j=0;j<20;j++)); do
            if [ ${j} -lt ${nbstars} ]; then
               out=$out"*"
            else
               out=$out"-"
            fi
        done
        out=${info[2]}" "$out"] ("$free" free on "$fs")"
        echo -e $out
    done
}

function my_ip() # Get IP adress on ethernet.
{
    MY_IP=$(/sbin/ifconfig eth0 | awk '/inet/ { print $2 } ' |
      sed -e s/addr://)
    echo ${MY_IP:-"Not connected"}
}

function ii()   # Get current host related info.
{
    echo -e "\nYou are logged on ${BRed}$HOST"
    echo -e "\n${BRed}Additionnal information:$NC " ; uname -a
    echo -e "\n${BRed}Users logged on:$NC " ; w -hs |
             cut -d " " -f1 | sort | uniq
    echo -e "\n${BRed}Current date :$NC " ; date
    echo -e "\n${BRed}Machine stats :$NC " ; uptime
    echo -e "\n${BRed}Memory stats :$NC " ; free
    echo -e "\n${BRed}Diskspace :$NC " ; mydf / $HOME
    echo -e "\n${BRed}Local IP Address :$NC" ; my_ip
    echo -e "\n${BRed}Open connections :$NC "; netstat -pan --inet;
    echo
}

#-------------------------------------------------------------
# Misc utilities:
#-------------------------------------------------------------

function repeat()       # Repeat n times command.
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do  # --> C-like syntax
        eval "$@";
    done
}

# See 'killps' for example of use.
function ask()          
{
    echo -n "$@" '[y/n] ' ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *) return 1 ;;
    esac
}

# Get name of app that created a corefile.
function corename()   
{
    for file ; do
        echo -n $file : ; gdb --core=$file --batch | head -1
    done
}

# add the current path to your PATH variable; not permanent
pathadd() 
  { export PATH=$PATH:$1; }

function body()
  {
  # print the header (the first line of input)
  # and then run the specified command on the body (the rest of the input)
  # use it in a pipeline, e.g. ps | body grep somepattern
      IFS= read -r header
      printf '%s\n' "$header"
      "$@"
  }






    # correct 4 spaces to be compatible with ^^^ spacing
    : <<'BLOCKCOMMENT'
    
    #=========================================================================
    #
    #  PROGRAMMABLE COMPLETION
    #  Most are taken from the bash 2.05 documentation and from Ian McDonald's
    # 'Bash completion' package (http://www.caliban.org/bash/#completion)
    #  You will in fact need bash more recent then 3.0 for some features.
    #
    #  Note that most linux distributions now provide many completions
    # 'out of the box' - however, you might need to make your own one day,
    #  so I kept those here as examples.
    #=========================================================================
    
    if [ "${BASH_VERSION%.*}" \< "3.0" ]; then
        echo "You will need to upgrade to version 3.0 for full \
              programmable completion features"
        return
    fi
    
    shopt -s extglob        # Necessary.
    
    complete -A hostname   rsh rcp telnet rlogin ftp ping disk
    complete -A export     printenv
    complete -A variable   export local readonly unset
    complete -A enabled    builtin
    complete -A alias      alias unalias
    complete -A function   function
    complete -A user       su mail finger
    
    complete -A helptopic  help     # Currently same as builtins.
    complete -A shopt      shopt
    complete -A stopped -P '%' bg
    complete -A job -P '%'     fg jobs disown
    
    complete -A directory  mkdir rmdir
    complete -A directory   -o default cd
    
    # Compression
    complete -f -o default -X '*.+(zip|ZIP)'  zip
    complete -f -o default -X '!*.+(zip|ZIP)' unzip
    complete -f -o default -X '*.+(z|Z)'      compress
    complete -f -o default -X '!*.+(z|Z)'     uncompress
    complete -f -o default -X '*.+(gz|GZ)'    gzip
    complete -f -o default -X '!*.+(gz|GZ)'   gunzip
    complete -f -o default -X '*.+(bz2|BZ2)'  bzip2
    complete -f -o default -X '!*.+(bz2|BZ2)' bunzip2
    complete -f -o default -X '!*.+(zip|ZIP|z|Z|gz|GZ|bz2|BZ2)' extract
    
    # Documents - Postscript,pdf,dvi.....
    complete -f -o default -X '!*.+(ps|PS)'  gs ghostview ps2pdf ps2ascii
    complete -f -o default -X \
    '!*.+(dvi|DVI)' dvips dvipdf xdvi dviselect dvitype
    complete -f -o default -X '!*.+(pdf|PDF)' acroread pdf2ps
    complete -f -o default -X '!*.@(@(?(e)ps|?(E)PS|pdf|PDF)?\
    (.gz|.GZ|.bz2|.BZ2|.Z))' gv ggv
    complete -f -o default -X '!*.texi*' makeinfo texi2dvi texi2html texi2pdf
    complete -f -o default -X '!*.tex' tex latex slitex
    complete -f -o default -X '!*.lyx' lyx
    complete -f -o default -X '!*.+(htm*|HTM*)' lynx html2ps
    complete -f -o default -X \
    '!*.+(doc|DOC|xls|XLS|ppt|PPT|sx?|SX?|csv|CSV|od?|OD?|ott|OTT)' soffice
    
    # Multimedia
    complete -f -o default -X \
    '!*.+(gif|GIF|jp*g|JP*G|bmp|BMP|xpm|XPM|png|PNG)' xv gimp ee gqview
    complete -f -o default -X '!*.+(mp3|MP3)' mpg123 mpg321
    complete -f -o default -X '!*.+(ogg|OGG)' ogg123
    complete -f -o default -X \
    '!*.@(mp[23]|MP[23]|ogg|OGG|wav|WAV|pls|\
    m3u|xm|mod|s[3t]m|it|mtm|ult|flac)' xmms
    complete -f -o default -X '!*.@(mp?(e)g|MP?(E)G|wma|avi|AVI|\
    asf|vob|VOB|bin|dat|vcd|ps|pes|fli|viv|rm|ram|yuv|mov|MOV|qt|\
    QT|wmv|mp3|MP3|ogg|OGG|ogm|OGM|mp4|MP4|wav|WAV|asx|ASX)' xine
    
    complete -f -o default -X '!*.pl'  perl perl5
    
    #  This is a 'universal' completion function - it works when commands have
    #+ a so-called 'long options' mode , ie: 'ls --all' instead of 'ls -a'
    #  Needs the '-o' option of grep
    #+ (try the commented-out version if not available).
    
    #  First, remove '=' from completion word separators
    #+ (this will allow completions like 'ls --color=auto' to work correctly).
    
    COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
    
    _get_longopts()
    {
      #$1 --help | sed  -e '/--/!d' -e 's/.*--\([^[:space:].,]*\).*/--\1/'| \
      #grep ^"$2" |sort -u ;
        $1 --help | grep -o -e "--[^[:space:].,]*" | grep -e "$2" |sort -u
    }
    
    _longopts()
    {
        local cur
        cur=${COMP_WORDS[COMP_CWORD]}
    
        case "${cur:-*}" in
           -*)      ;;
            *)      return ;;
        esac
    
        case "$1" in
           \~*)     eval cmd="$1" ;;
             *)     cmd="$1" ;;
        esac
        COMPREPLY=( $(_get_longopts ${1} ${cur} ) )
    }
    complete  -o default -F _longopts configure bash
    complete  -o default -F _longopts wget id info a2ps ls recode
    
    _tar()
    {
        local cur ext regex tar untar
    
        COMPREPLY=()
        cur=${COMP_WORDS[COMP_CWORD]}
    
        # If we want an option, return the possible long options.
        case "$cur" in
            -*)     COMPREPLY=( $(_get_longopts $1 $cur ) ); return 0;;
        esac
    
        if [ $COMP_CWORD -eq 1 ]; then
            COMPREPLY=( $( compgen -W 'c t x u r d A' -- $cur ) )
            return 0
        fi
    
        case "${COMP_WORDS[1]}" in
            ?(-)c*f)
                COMPREPLY=( $( compgen -f $cur ) )
                return 0
                ;;
            +([^Izjy])f)
                ext='tar'
                regex=$ext
                ;;
            *z*f)
                ext='tar.gz'
                regex='t\(ar\.\)\(gz\|Z\)'
                ;;
            *[Ijy]*f)
                ext='t?(ar.)bz?(2)'
                regex='t\(ar\.\)bz2\?'
                ;;
            *)
                COMPREPLY=( $( compgen -f $cur ) )
                return 0
                ;;
    
        esac
    
        if [[ "$COMP_LINE" == tar*.$ext' '* ]]; then
            # Complete on files in tar file.
            #
            # Get name of tar file from command line.
            tar=$( echo "$COMP_LINE" | \
                            sed -e 's|^.* \([^ ]*'$regex'\) .*$|\1|' )
            # Devise how to untar and list it.
            untar=t${COMP_WORDS[1]//[^Izjyf]/}
    
            COMPREPLY=( $( compgen -W "$( echo $( tar $untar $tar \
                                    2>/dev/null ) )" -- "$cur" ) )
            return 0
    
        else
            # File completion on relevant files.
            COMPREPLY=( $( compgen -G $cur\*.$ext ) )
    
        fi
    
        return 0
    
    }
    
    complete -F _tar -o default tar
    
    _make()
    {
        local mdef makef makef_dir="." makef_inc gcmd cur prev i;
        COMPREPLY=();
        cur=${COMP_WORDS[COMP_CWORD]};
        prev=${COMP_WORDS[COMP_CWORD-1]};
        case "$prev" in
            -*f)
                COMPREPLY=($(compgen -f $cur ));
                return 0
                ;;
        esac;
        case "$cur" in
            -*)
                COMPREPLY=($(_get_longopts $1 $cur ));
                return 0
                ;;
        esac;
    
        # ... make reads
        #          GNUmakefile,
        #     then makefile
        #     then Makefile ...
        if [ -f ${makef_dir}/GNUmakefile ]; then
            makef=${makef_dir}/GNUmakefile
        elif [ -f ${makef_dir}/makefile ]; then
            makef=${makef_dir}/makefile
        elif [ -f ${makef_dir}/Makefile ]; then
            makef=${makef_dir}/Makefile
        else
           makef=${makef_dir}/*.mk         # Local convention.
        fi
    
        #  Before we scan for targets, see if a Makefile name was
        #+ specified with -f.
        for (( i=0; i < ${#COMP_WORDS[@]}; i++ )); do
            if [[ ${COMP_WORDS[i]} == -f ]]; then
                # eval for tilde expansion
                eval makef=${COMP_WORDS[i+1]}
                break
            fi
        done
        [ ! -f $makef ] && return 0
    
        # Deal with included Makefiles.
        makef_inc=$( grep -E '^-?include' $makef |
                     sed -e "s,^.* ,"$makef_dir"/," )
        for file in $makef_inc; do
            [ -f $file ] && makef="$makef $file"
        done
    
    
        #  If we have a partial word to complete, restrict completions
        #+ to matches of that word.
        if [ -n "$cur" ]; then gcmd='grep "^$cur"' ; else gcmd=cat ; fi
    
        COMPREPLY=( $( awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ \
                                   {split($1,A,/ /);for(i in A)print A[i]}' \
                                    $makef 2>/dev/null | eval $gcmd  ))
    
    }
    
    complete -F _make -X '+($*|*.[cho])' make gmake pmake
    
    _killall()
    {
        local cur prev
        COMPREPLY=()
        cur=${COMP_WORDS[COMP_CWORD]}
    
        #  Get a list of processes
        #+ (the first sed evaluation
        #+ takes care of swapped out processes, the second
        #+ takes care of getting the basename of the process).
        COMPREPLY=( $( ps -u $USER -o comm  | \
            sed -e '1,1d' -e 's#[]\[]##g' -e 's#^.*/##'| \
            awk '{if ($0 ~ /^'$cur'/) print $0}' ))
    
        return 0
    }
    
    complete -F _killall killall killps
    
    # Local Variables:
    # mode:shell-script
    # sh-shell:bash
    # End:
   

    ###############################
    # lesser Prompts
    ###############################
    
    PS1='[\u@\h \W]\$ '
    
    ## Set the prompt to display the current git branch
    ## and use pretty colors
    export PS1='$(git branch &>/dev/null; if [ $? -eq 0 ]; then \
    echo "\[\e[1m\]\u@\h\[\e[0m\]: \w [\[\e[34m\]$(git branch | grep ^* | sed s/\*\ //)\[\e[0m\]\
    $(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; if [ "$?" -ne "0" ]; then \
    echo "\[\e[1;31m\]*\[\e[0m\]"; fi)] \$ "; else \
    echo "\[\e[1m\]\u@\h\[\e[0m\]: \w \$ "; fi )'
    
    ###############
    # Function to parse git branch
    parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
    }
    
    # The prompt settings
    export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[0;31m\]\$(parse_git_branch)\[\033[00m\]\$ "
BLOCKCOMMENT





#### automatically appended by some programs (looking at you conda)

















