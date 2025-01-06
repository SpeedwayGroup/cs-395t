# Activate the gem5-cs-395t environment on the pedagogical machines,
# for the fish shell.
#
# Run using:
# source ./activate-env.fish

set -l conda_dir "/scratch/cluster/speedway/opt/miniforge3"
set -l conda_prefix "/scratch/cluster/speedway/opt/miniforge3/envs/gem5-cs-395t"

#
# Set up Conda
#
if not which conda > /dev/null
    # Conda not found, get it.
    echo "'conda' not found. Using Conda installation at $conda_dir..."

    if test -f $conda_dir/bin/conda
        eval $conda_dir/bin/conda "shell.fish" "hook" $argv | source
    else
        if test -f "$conda_dir/etc/fish/conf.d/conda.fish"
            eval "$conda_dir/etc/fish/conf.d/conda.fish" | source
        else
            set -x PATH "$conda_dir/bin" $PATH
        end
    end
else
    # Conda found.
    echo "conda found at "(which conda)
end

#
# Set up Mamba
#
if not which mamba > /dev/null
    # Mamba not found, get it.
    echo "'mamba' not found. Using Mamba installation at $conda_dir..."

    if test -f "$conda_dir/etc/fish/conf.d/mamba.fish"
        source "$conda_dir/etc/fish/conf.d/mamba.fish"
    end
else
    # Mamba found.
    echo "mamba found at "(which mamba)
end

#
# Activate the environment
#
echo "Activating environment at $conda_prefix"
mamba activate $conda_prefix
