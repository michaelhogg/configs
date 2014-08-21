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



#-----------------------#
#  Git auto-completion  #
#-----------------------#

# github.com/git/git/blob/master/contrib/completion/git-completion.bash
source ~/.git-completion.sh



#--------------------------------#
#  Aliases and simple functions  #
#--------------------------------#

alias cls='tput reset; ls -la'

function cdl {
    cd "$1"
    cls
}

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
