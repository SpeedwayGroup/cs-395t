#!/usr/bin/env fish

# Remove external dependencies (mold, gcc 13.3.0).

function path_remove
    set -l var_name $argv[1]
    set -l dir_to_remove $argv[2]
    set -l path_var (eval echo \$$var_name)

    # Remove the first occurence of the directory from the path variable
    set path_var (string replace -r "\s?$dir_to_remove\s?|$dir_to_remove\s?|\s?$dir_to_remove" "" $path_var)

    # Export the modified path variable
    set -x $var_name $path_var
end

#
# mold
#
set -l mold_version "2.35.1"
set -l mold_dir     "/scratch/cluster/speedway/opt/mold/$mold_version"

path_remove  fish_user_paths    "$mold_dir/bin"

#
# gcc
#
set -l gcc_version "13.3.0"
set -l gcc_dir     "/scratch/cluster/speedway/opt/gcc/$gcc_version"

path_remove  CPATH              "$gcc_dir/include"
path_remove  C_INCLUDE_PATH     "$gcc_dir/include"
path_remove  CPLUS_INCLUDE_PATH "$gcc_dir/include"
path_remove  LIBRARY_PATH       "$gcc_dir/lib"
path_remove  LD_LIBRARY_PATH    "$gcc_dir/lib64"
path_remove  LD_LIBRARY_PATH    "$gcc_dir/lib"
path_remove  fish_user_paths    "$gcc_dir/bin"
