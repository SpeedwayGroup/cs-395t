# Activate the gem5-cs-395t environment on the pedagogical machines,
# for the bash shell.
#
# Run using:
# source ./activate-env.sh

__conda_dir="/var/local/speedway/miniforge3"
__conda_prefix="/var/local/speedway/envs/gem5-cs-395t"

#
# Set up Conda
#
if ! which conda > /dev/null; then
    # Conda not found, get it.
    echo "conda not found. Using installation at $__conda_dir..."

    __conda_setup="$("$__conda_dir/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"

    # Conda
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f $__conda_dir/etc/profile.d/conda.sh ]; then
            source $__conda_dir/etc/profile.d/conda.sh
        else
            export PATH="${__conda_dir}/bin:${PATH}"
        fi
    fi
else
    # Conda found.
    echo "conda found at "$(which conda)
fi

#
# Set up Mamba
#
if ! which mamba > /dev/null; then
    # Mamba not found, get it.
    echo "mamba not found. Using installation at $conda_dir..."

    if [ -f $conda_dir/etc/profile.d/mamba.sh ]; then
        source $conda_dir/etc/profile.d/mamba.sh
    fi
else
    # Mamba found.
    echo "mamba found at "$(which mamba)
fi

# Activate the gem5-cs-395t environment.
echo "Activating environment at $__conda_prefix"
mamba activate ${__conda_prefix}

unset __conda_prefix
unset __conda_dir
unset __conda_setup