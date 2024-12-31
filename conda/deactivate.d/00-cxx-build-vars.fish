#!/usr/bin/env fish

# Remove this Conda's include and library directories from the search paths
# of C/C++ compilers.

function path_remove
    set -l var_name $argv[1]
    set -l dir_to_remove $argv[2]
    set -l path_var (eval echo \$$var_name)

    # Remove the directory from the path variable
    set path_var (string replace -r ":?$dir_to_remove:?|$dir_to_remove:?|:?$dir_to_remove" "" $path_var)

    # Export the modified path variable
    set -x $var_name $path_var
end

path_remove CPATH              "$CONDA_PREFIX/include"
path_remove C_INCLUDE_PATH     "$CONDA_PREFIX/include"
path_remove CPLUS_INCLUDE_PATH "$CONDA_PREFIX/include"
path_remove LIBRARY_PATH       "$CONDA_PREFIX/lib"
path_remove LD_LIBRARY_PATH    "$CONDA_PREFIX/lib"

