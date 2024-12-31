#!/bin/sh

# Remove this Conda's include and library directories from the search paths
# of C/C++ compilers.

path_remove() {
    local var_name="$1"
    local dir_to_remove="$2"
    local path_var="${!var_name}"

    # Remove the directory from the path variable
    path_var=$(echo "$path_var" | /bin/sed -e "s#:$dir_to_remove##g" -e "s#$dir_to_remove:##g" -e "s#$dir_to_remove##g")

    # Export the modified path variable
    export "$var_name"="$path_var"
}

path_remove CPATH              "$CONDA_PREFIX/include"
path_remove C_INCLUDE_PATH     "$CONDA_PREFIX/include"
path_remove CPLUS_INCLUDE_PATH "$CONDA_PREFIX/include"
path_remove LIBRARY_PATH       "$CONDA_PREFIX/lib"
path_remove LD_LIBRARY_PATH    "$CONDA_PREFIX/lib"

