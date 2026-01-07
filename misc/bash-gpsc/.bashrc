#
# >>> DO NOT EDIT >>>
# teamrc file hook added automatically to .bashrc
TEAMRC=~/quick_access/badeaa_lab/code/hook-system/.teamrc
if [ -f $TEAMRC ]; then
	source $TEAMRC
fi
# <<< DO NOT EDIT <<< 
#

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/gpfs/fs7/aafc/common/miniforge/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/gpfs/fs7/aafc/common/miniforge/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/gpfs/fs7/aafc/common/miniforge/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/gpfs/fs7/aafc/common/miniforge/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

