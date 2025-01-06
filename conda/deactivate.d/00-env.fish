#!/usr/bin/env fish

# Remove this Conda environment's directories from the shell environment.

function __path_remove
    set -l var_name $argv[1]
    set -l dir_to_remove $argv[2]
    set -l path_var (eval echo \$$var_name)

    if not test -z "$path_var"
        # Remove the first occurence of the directory from the path variable
        set -l path_var (string replace -r "\s?$dir_to_remove\s?|$dir_to_remove\s?|\s?$dir_to_remove" "" $path_var)

        # Export the modified path variable
        set -gx $var_name $path_var
    end

    # Print result
    printf "%-20s: Remove %s\n" $var_name $dir_to_remove
end

# conda
__path_remove  fish_user_paths    "$CONDA_PREFIX/bin"
__path_remove  CPATH              "$CONDA_PREFIX/include"
__path_remove  C_INCLUDE_PATH     "$CONDA_PREFIX/include"
__path_remove  CPLUS_INCLUDE_PATH "$CONDA_PREFIX/include"
__path_remove  LIBRARY_PATH       "$CONDA_PREFIX/lib"
__path_remove  LD_LIBRARY_PATH    "$CONDA_PREFIX/lib"
__path_remove  PKG_CONFIG_PATH    "$CONDA_PREFIX/lib/pkgconfig"

# hdf5
set -l hdf5_dir "/scratch/cluster/speedway/opt/hdf5/1.14.5"
__path_remove  CPATH              "$hdf5_dir/include"
__path_remove  C_INCLUDE_PATH     "$hdf5_dir/include"
__path_remove  CPLUS_INCLUDE_PATH "$hdf5_dir/include"
__path_remove  LIBRARY_PATH       "$hdf5_dir/lib"
__path_remove  LD_LIBRARY_PATH    "$hdf5_dir/lib"

# capstone
set -l capstone_dir "/scratch/cluster/speedway/opt/capstone/5.0.3"
__path_remove  CPATH              "$capstone_dir/include"
__path_remove  C_INCLUDE_PATH     "$capstone_dir/include"
__path_remove  CPLUS_INCLUDE_PATH "$capstone_dir/include"
__path_remove  LIBRARY_PATH       "$capstone_dir/lib"
__path_remove  LD_LIBRARY_PATH    "$capstone_dir/lib"

# mold
set -l mold_dir "/scratch/cluster/speedway/opt/mold/2.35.1"
__path_remove  fish_user_paths    "$mold_dir/bin"

# gcc
set -l gcc_dir "/scratch/cluster/speedway/opt/gcc/13.3.0"
__path_remove  fish_user_paths    "$gcc_dir/bin"