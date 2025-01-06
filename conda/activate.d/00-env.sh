#!/bin/sh

# Add this Conda environment's directories to the shell environment.

__path_prepend() {
    local var_name="$1"
    local dir_to_prepend="$2"
    local path_var="${!var_name}"

    # Prepend the directory to the path variable
    if [ -z "$path_var" ]; then
        export "${var_name}"="${dir_to_prepend}"
    else
        export "${var_name}"="${dir_to_prepend}:${path_var}"
    fi

    # Print result
    printf "%-20s: Prepend %s\n" ${var_name} ${dir_to_prepend}
}

# conda
__path_prepend PATH               "${CONDA_PREFIX}/bin"
__path_prepend CPATH              "${CONDA_PREFIX}/include"
__path_prepend C_INCLUDE_PATH     "${CONDA_PREFIX}/include"
__path_prepend CPLUS_INCLUDE_PATH "${CONDA_PREFIX}/include"
__path_prepend LIBRARY_PATH       "${CONDA_PREFIX}/lib"
__path_prepend LD_LIBRARY_PATH    "${CONDA_PREFIX}/lib"
__path_prepend PKG_CONFIG_PATH    "${CONDA_PREFIX}/lib/pkgconfig"

# hdf5
hdf5_dir="/scratch/cluster/speedway/opt/hdf5/1.14.5"
__path_prepend CPATH              "${hdf5_dir}/include"
__path_prepend C_INCLUDE_PATH     "${hdf5_dir}/include"
__path_prepend CPLUS_INCLUDE_PATH "${hdf5_dir}/include"
__path_prepend LIBRARY_PATH       "${hdf5_dir}/lib"
__path_prepend LD_LIBRARY_PATH    "${hdf5_dir}/lib"

# capstone
capstone_dir="/scratch/cluster/speedway/opt/capstone/5.0.3"
__path_prepend CPATH              "${capstone_dir}/include"
__path_prepend C_INCLUDE_PATH     "${capstone_dir}/include"
__path_prepend CPLUS_INCLUDE_PATH "${capstone_dir}/include"
__path_prepend LIBRARY_PATH       "${capstone_dir}/lib"
__path_prepend LD_LIBRARY_PATH    "${capstone_dir}/lib"

# gcc
gcc_dir="/scratch/cluster/speedway/opt/gcc/13.3.0"
__path_prepend PATH               "${gcc_dir}/bin"

# mold
mold_dir="/scratch/cluster/speedway/opt/mold/2.35.1"
__path_prepend PATH               "${mold_dir}/bin"
