#!/bin/sh

# Remove this Conda's include and library directories from the search paths
# of C/C++ compilers.

path_remove() {
    local var_name="$1"
    local dir_to_remove="$2"
    local path_var="${!var_name}"

    # Remove the first occurence of the directory from the path variable
    IFS=: read -r -a path_segments <<< "$path_var"

    # Remove the first matching segment
    for i in "${!path_segments[@]}"; do
        if [ "${path_segments[i]}" = "$dir_to_remove" ]; then
            unset 'path_segments[i]'
            break
        fi
    done

    # Rebuild the path variable
    path_var="$(IFS=:; echo "${path_segments[*]}")"
    
    # Export the modified path variable
    export "$var_name"="$path_var"
}

#
# mold
#
__mold_version="2.35.1"
__mold_dir="/scratch/cluster/speedway/opt/mold/$__mold_version"

path_remove  PATH                "$__mold_dir/bin"

unset __mold_version
unset __mold_dir

#
# gcc
#
__gcc_version="13.3.0"
__gcc_dir="/scratch/cluster/speedway/opt/gcc/$__gcc_version"

path_remove  CPATH              "$__gcc_dir/include"
path_remove  C_INCLUDE_PATH     "$__gcc_dir/include"
path_remove  CPLUS_INCLUDE_PATH "$__gcc_dir/include"
path_remove  LIBRARY_PATH       "$__gcc_dir/lib"
path_remove  LD_LIBRARY_PATH    "$__gcc_dir/lib64"
path_remove  LD_LIBRARY_PATH    "$__gcc_dir/lib"
path_remove  PATH               "$__gcc_dir/bin"

unset __gcc_version
unset __gcc_dir
