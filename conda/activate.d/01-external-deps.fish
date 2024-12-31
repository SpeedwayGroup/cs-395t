#!/usr/bin/env fish

# Add external dependencies (mold, gcc 13.3.0).

function path_prepend
    set -l var_name $argv[1]
    set -l dir_to_prepend $argv[2]
    set -l path_var (eval echo \$$var_name)

    # Prepend the directory to the path variable
    set path_var $dir_to_prepend $path_var

    # Export the modified path variable
    set -x $var_name $path_var
end

#
# mold
#
set -l mold_version "2.35.1"
set -l mold_dir     "/scratch/cluster/speedway/opt/mold/$mold_version"

path_prepend fish_user_paths    "$mold_dir/bin"

#
# gcc
#
set -l gcc_version "13.3.0"
set -l gcc_dir     "/scratch/cluster/speedway/opt/gcc/$gcc_version"

path_prepend CPATH              "$gcc_dir/include"
path_prepend C_INCLUDE_PATH     "$gcc_dir/include"
path_prepend CPLUS_INCLUDE_PATH "$gcc_dir/include"
path_prepend LIBRARY_PATH       "$gcc_dir/lib"
path_prepend LD_LIBRARY_PATH    "$gcc_dir/lib64"
path_prepend LD_LIBRARY_PATH    "$gcc_dir/lib"
path_prepend fish_user_paths    "$gcc_dir/bin"