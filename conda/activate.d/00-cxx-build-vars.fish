#!/usr/bin/env fish

# Add this Conda's include and library directories to the search paths
# of C/C++ compilers.

function path_prepend
    set -l var_name $argv[1]
    set -l dir_to_prepend $argv[2]
    set -l path_var (eval echo \$$var_name)

    # Remove duplicates of the directory
    set path_var (string replace -r ":?$dir_to_remove:?|$dir_to_remove:?|:?$dir_to_remove" "" $path_var)

    # Prepend the directory to the path variable
    set path_var $dir_to_prepend:$path_var

    # Export the modified path variable
    set -x $var_name $path_var
end

path_prepend CPATH              "$CONDA_PREFIX/include"
path_prepend C_INCLUDE_PATH     "$CONDA_PREFIX/include"
path_prepend CPLUS_INCLUDE_PATH "$CONDA_PREFIX/include"
path_prepend LIBRARY_PATH       "$CONDA_PREFIX/lib"
path_prepend LD_LIBRARY_PATH    "$CONDA_PREFIX/lib"

