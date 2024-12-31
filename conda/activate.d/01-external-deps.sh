#!/bin/sh

# Add this Conda's include and library directories to the search paths
# of C/C++ compilers.

path_prepend() {
    local var_name="$1"
    local dir_to_prepend="$2"
    local path_var="${!var_name}"

    # Prepend the directory to the path variable
    path_var="$dir_to_prepend:$path_var"

    # Export the modified path variable
    export "$var_name"="$path_var"
}

#
# mold
#
__mold_version="2.35.1"
__mold_dir="/scratch/cluster/speedway/opt/mold/$__mold_version"

path_prepend PATH                "$__mold_dir/bin"

unset __mold_version
unset __mold_dir

#
# gcc
#
__gcc_version="13.3.0"
__gcc_dir="/scratch/cluster/speedway/opt/gcc/$__gcc_version"

path_prepend CPATH              "$__gcc_dir/include"
path_prepend C_INCLUDE_PATH     "$__gcc_dir/include"
path_prepend CPLUS_INCLUDE_PATH "$__gcc_dir/include"
path_prepend LIBRARY_PATH       "$__gcc_dir/lib"
path_prepend LD_LIBRARY_PATH    "$__gcc_dir/lib64"
path_prepend LD_LIBRARY_PATH    "$__gcc_dir/lib"
path_prepend PATH               "$__gcc_dir/bin"

unset __gcc_version
unset __gcc_dir