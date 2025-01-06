#!/usr/bin/env fish

# Add this Conda environment's directories to the shell environment.

function __path_prepend
    set -l var_name $argv[1]
    set -l dir_to_prepend $argv[2]
    set -l path_var (eval echo \$$var_name)

    set -gxp $var_name $dir_to_prepend

    # Print result
    printf "%-20s: Prepend %s\n" $var_name $dir_to_prepend
end

function __path_append
    set -l var_name $argv[1]
    set -l dir_to_append $argv[2]

    set -gxa $var_name $dir_to_prepend

    # Print result
    printf "%-20s: Append %s\n" $var_name $dir_to_append
end

# conda
__path_prepend fish_user_paths    "$CONDA_PREFIX/bin"
__path_prepend CPATH              "$CONDA_PREFIX/include"
__path_prepend C_INCLUDE_PATH     "$CONDA_PREFIX/include"
__path_prepend CPLUS_INCLUDE_PATH "$CONDA_PREFIX/include"
__path_prepend LIBRARY_PATH       "$CONDA_PREFIX/lib"
__path_prepend LD_LIBRARY_PATH    "$CONDA_PREFIX/lib"
__path_prepend PKG_CONFIG_PATH    "$CONDA_PREFIX/lib/pkgconfig" 

# hdf5
set -l hdf5_dir "/scratch/cluster/speedway/opt/hdf5/1.14.5"
__path_prepend CPATH              "$hdf5_dir/include"
__path_prepend C_INCLUDE_PATH     "$hdf5_dir/include"
__path_prepend CPLUS_INCLUDE_PATH "$hdf5_dir/include"
__path_prepend LIBRARY_PATH       "$hdf5_dir/lib"
__path_prepend LD_LIBRARY_PATH    "$hdf5_dir/lib"

# capstone
set -l capstone_dir "/scratch/cluster/speedway/opt/capstone/5.0.3"
__path_prepend CPATH              "$capstone_dir/include"
__path_prepend C_INCLUDE_PATH     "$capstone_dir/include"
__path_prepend CPLUS_INCLUDE_PATH "$capstone_dir/include"
__path_prepend LIBRARY_PATH       "$capstone_dir/lib"
__path_prepend LD_LIBRARY_PATH    "$capstone_dir/lib"

# mold
set -l mold_dir "/scratch/cluster/speedway/opt/mold/2.35.1"
__path_prepend fish_user_paths    "$mold_dir/bin"

# gcc
set -l gcc_dir "/scratch/cluster/speedway/opt/gcc/13.3.0"
__path_prepend fish_user_paths    "$gcc_dir/bin"