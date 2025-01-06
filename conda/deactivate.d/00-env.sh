#!/bin/sh

# Remove this Conda environment's directories from the shell environment.

__path_remove() {
    local var_name="$1"
    local dir_to_remove="$2"
    local path_var="${!var_name}"

    if [ ! -z "$path_var" ]; then
        # Remove the first occurence of the directory from the path variable
        IFS=: read -r -a path_segments <<< "${path_var}"

        # Remove the first matching segment
        for i in "${!path_segments[@]}"; do
            if [ "${path_segments[i]}" = "${dir_to_remove}" ]; then
                unset 'path_segments[i]'
                break
            fi
        done

        # Rebuild the path variable
        path_var="$(IFS=:; echo "${path_segments[*]}")"

        # Export the modified path variable
        export "${var_name}"="${path_var}"
    fi

    # Print result
    printf "%-20s: Remove %s\n" ${var_name} ${dir_to_remove}
}

# conda
__path_remove  PATH               "${CONDA_PREFIX}/bin"
__path_remove  CPATH              "${CONDA_PREFIX}/include"
__path_remove  C_INCLUDE_PATH     "${CONDA_PREFIX}/include"
__path_remove  CPLUS_INCLUDE_PATH "${CONDA_PREFIX}/include"
__path_remove  LIBRARY_PATH       "${CONDA_PREFIX}/lib"
__path_remove  LD_LIBRARY_PATH    "${CONDA_PREFIX}/lib"
__path_remove  PKG_CONFIG_PATH    "${CONDA_PREFIX}/lib/pkgconfig"

# hdf5
hdf5_dir="/scratch/cluster/speedway/opt/hdf5/1.14.5"
__path_remove  CPATH              "${hdf5_dir}/include"
__path_remove  C_INCLUDE_PATH     "${hdf5_dir}/include"
__path_remove  CPLUS_INCLUDE_PATH "${hdf5_dir}/include"
__path_remove  LIBRARY_PATH       "${hdf5_dir}/lib"
__path_remove  LD_LIBRARY_PATH    "${hdf5_dir}/lib"

# capstone
capstone_dir="/scratch/cluster/speedway/opt/capstone/5.0.3"
__path_remove  CPATH              "${capstone_dir}/include"
__path_remove  C_INCLUDE_PATH     "${capstone_dir}/include"
__path_remove  CPLUS_INCLUDE_PATH "${capstone_dir}/include"
__path_remove  LIBRARY_PATH       "${capstone_dir}/lib"
__path_remove  LD_LIBRARY_PATH    "${capstone_dir}/lib"

# gcc
gcc_dir="/scratch/cluster/speedway/opt/gcc/13.3.0"
__path_remove  PATH               "${gcc_dir}/bin"

# mold
mold_dir="/scratch/cluster/speedway/opt/mold/2.35.1"
__path_remove  PATH               "${mold_dir}/bin"
