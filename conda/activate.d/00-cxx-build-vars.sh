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

path_prepend CPATH              "$CONDA_PREFIX/include"
path_prepend C_INCLUDE_PATH     "$CONDA_PREFIX/include"
path_prepend CPLUS_INCLUDE_PATH "$CONDA_PREFIX/include"
path_prepend LIBRARY_PATH       "$CONDA_PREFIX/lib"
path_prepend LD_LIBRARY_PATH    "$CONDA_PREFIX/lib"
