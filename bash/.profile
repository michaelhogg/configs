#--------#
#  Path  #
#--------#

# MacPorts Installer addition: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.



#----------#
#  Prompt  #
#----------#

# Default: \h:\W \u\$
if [ $TERM = 'xterm-256color' ]
then
    #                           Username              @               Hostname              :              Directory              $
    #            [     pink      ]   [    yellow     ]  [     blue     ]   [    yellow     ]  [    green     ]   [    yellow     ]   [ reset ]
    export PS1="\[\033[38;5;127m\]\u\[\033[38;5;226m\]@\[\033[38;5;32m\]\H\[\033[38;5;226m\]:\[\033[38;5;48m\]\w\[\033[38;5;226m\]$ \[\033[m\]"
else
    export PS1="\u@\H:\w$ "
fi



#-----------#
#  History  #
#-----------#

# Defaults: 500
export HISTSIZE=5000      # When an interactive shell exits, the last HISTSIZE lines are saved from the history list to HISTFILE.
export HISTFILESIZE=5000  # After saving the history, the history file is truncated to contain no more than HISTFILESIZE lines.



#------------------------#
#  Node Version Manager  #
#------------------------#

# github.com/creationix/nvm
source ~/.nvm/nvm.sh



#-----------------------#
#  Git auto-completion  #
#-----------------------#

# github.com/git/git/blob/master/contrib/completion/git-completion.bash
source ~/.git-completion.sh



#--------------------------------#
#  Aliases and simple functions  #
#--------------------------------#

alias reloadbashprofile='source ~/.profile'

# List long
alias ll='ls -laG'          # OS X
#alias ll='ls -la --color'  # Linux

# List with octal permissions
alias lo='find . -maxdepth 1 -print0 | sort -z | xargs -0 -n 1 stat -f "%Sp  %OLp  %Su:%Sg  %N" | sed "s|  \./|  |"'    # OS X
#alias lo='find . -maxdepth 1 -print0 | sort -z | xargs -0 -n 1 stat --format="%A  %a  %U:%G  %n" | sed "s|  \./|  |"'  # Linux

# Clear terminal scrollback, then list long
alias cls='tput reset; ll'

# Change directory, then clear terminal scrollback and list long
function cdl {
    cd "$1"
    cls
}

# Grep history
alias hgr='history | grep -i --color=always $1'

# Atlassian SourceTree
alias st='stree'

# mysql5 from MacPorts
alias mysql='mysql5'

# Diffuse, ignoring all white space
alias diffusei='diffuse --ignore-all-space'

# NPM install
alias npmih='npm install --loglevel http'
alias npmii='npm install --loglevel info'

# Less, with long prompt, line numbers gutter, and chopped long lines
alias lessx='less -MNS'

# Hex Fiend -- ridiculousfish.com/hexfiend/
alias hexfiend='open -b com.ridiculousfish.HexFiend'

# Pretty-print JSON
alias ppjson='python -m json.tool'

# Load JSON from the clipboard, and pretty-print using Python
alias ppjsonpaste='pbpaste | python -m json.tool'

# Download JSON using cURL, and pretty-print using Python
function ppjsoncurl {
    curl "$1" | python -m json.tool
}

# Start a local PHP server on the specified port
function phpserver {
    php -S localhost:$1
}

# Display processes which are listening on the specified port
function portlistening {
    lsof -i :$1
}

# Live monitor of process tree, rooted at the specified PID
function livepstree {
    while true  ; do date "+%H:%M:%S %Z"    ; pstree -g 2   "$1" ; sleep 0.25 ; done  # Mac
    #while true ; do date "+%H:%M:%S.%N %Z" ; pstree -acnps "$1" ; sleep 0.25 ; done  # Linux
}



#---------------------#
#  rsync and fswatch  #
#---------------------#

function rsync_helper {

    # $1 = Local     eg: "~/Documents/Code/api/"
    # $2 = Remote    eg: "root@192.168.0.5:/var/www/api"
    # $3 = chown     eg: "root:apache"

    # rsync.samba.org

    # Install using MacPorts:
    #     sudo port install rsync

    # Options:
    #     --rsh=COMMAND         Specify the remote shell to use
    #     --recursive           Recurse into directories
    #     --links               Copy symlinks as symlinks
    #     --perms               Preserve permissions
    #     --executability       Preserve executability
    #     --times               Preserve modification times
    #     --chown=USER:GROUP    Force all files to be owned by USER with group GROUP
    #     --group               Required to make --chown work. See serverfault.com/a/656494
    #     --progress            Show progress during transfer
    #     --exclude=PATTERN     Exclude files matching PATTERN
    #     --verbose             Increase verbosity
    #     --delete              Delete extraneous files from the receiving side (ones that aren't on the sending side)

    echo "$1 --> $2 ($3)"

    rsync                     \
        --rsh='ssh'           \
        --recursive           \
        --links               \
        --perms               \
        --executability       \
        --times               \
        --chown="$3"          \
        --group               \
        --progress            \
        --exclude='.DS_Store' \
        "$1"                  \
        "$2"

}

export -f rsync_helper  # unix.stackexchange.com/questions/158564/how-to-use-defined-function-with-xargs

function watch_and_sync {

    # $1 = Local     eg: "~/Documents/Code/api/"
    # $2 = Remote    eg: "root@192.168.0.5:/var/www/api"
    # $3 = chown     eg: "root:apache"

    #----- fswatch -----#

    # emcrisostomo.github.io/fswatch/

    # Install using MacPorts:
    #     sudo port install fswatch

    # Options:
    #     --one-per-batch    Print a single message with the number of change events.
    #     --exclude=REGEX    Exclude paths matching REGEX.  Multiple exclude filters can be specified using this option multiple times.

    # From the README:
    #     To run a command when a set of change events is printed to standard output but no event details are required, then the following command can be used:
    #         fswatch --one-per-batch PATH | xargs -n1 -I{} COMMAND

    #----- xargs -----#

    # Options:
    #     -n NUM        Set the maximum number of arguments taken from standard input for each invocation of utility.
    #     -I REPLSTR    Execute utility for each input line, replacing one or more occurrences of REPLSTR in arguments to utility with the entire line of input.

    echo "Watching $1 for changes..."

    fswatch --one-per-batch --exclude='.DS_Store' "$1" | xargs -n 1 -I {} bash -c "rsync_helper '$1' '$2' '$3'"

}



#-------#
#  Git  #
#-------#

function gitltags {

    git show-ref --tags -d | grep -F -v '{}'

}

function gitrtags {

    # $1 = Name of remote

    git ls-remote --tags "$1" | grep -F -v '{}'

}

function gitdiffusethree {

    # $1 = First commit hash
    # $2 = Second commit hash
    # $3 = File path
    # $4 = (Optional)  -i  Ignore all space
    # $5 = (Optional)  -t  Launch two instances of diffuse instead of one

    CommonAncestor=$(git merge-base $1 $2)
    echo 'Common ancestor = '$CommonAncestor

    IgnoreAllSpace=''

    if [ "$4" == '-i' ] || [ "$5" == '-i' ]
    then
        IgnoreAllSpace='--ignore-all-space'
    fi

    if [ "$4" == '-t' ] || [ "$5" == '-t' ]
    then
        diffuse $IgnoreAllSpace -r "$CommonAncestor" -r "$1" "$3" &
        diffuse $IgnoreAllSpace -r "$CommonAncestor" -r "$2" "$3" &
    else
        diffuse $IgnoreAllSpace -r "$1" -r "$CommonAncestor" -r "$2" "$3"
    fi

}

function gitdiffusemergeverify {

    # $1 = Left commit hash
    # $2 = Right commit hash
    # $3 = Merged commit hash
    # $4 = File path
    # $5 = (Optional)  -i  Ignore all space

    CommonAncestor=$(git merge-base $1 $2)
    echo 'Common ancestor = '$CommonAncestor

    IgnoreAllSpace=''

    if [ "$5" == '-i' ]
    then
        IgnoreAllSpace='--ignore-all-space'
    fi

    diffuse $IgnoreAllSpace -r "$CommonAncestor" -r "$1" "$4" &
    diffuse $IgnoreAllSpace -r "$2"              -r "$3" "$4" &

    read -p 'Press Enter when ready to continue'

    diffuse $IgnoreAllSpace -r "$CommonAncestor" -r "$2" "$4" &
    diffuse $IgnoreAllSpace -r "$1"              -r "$3" "$4" &

}
