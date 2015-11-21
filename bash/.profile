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

alias cls='tput reset; ls -laG'

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


#----- Git -----#

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
