# Conda environment

Building and running gem5 can be tricky, in our experience. To help you get started, we've set up a [Conda](https://docs.conda.io/projects/conda/en/latest/index.html) environment for you that works on the UTCS pedagogical machines.

> [!WARNING]
> Everything you do with gem5, including **building**, **running**, and **testing**, **must be done within the Conda environment!** Therefore, you **must activate the environment every time you open a new terminal**! Otherwise, you may get strange, unintuitive errors such as a missing Python installation or missing libraries.

## Setup

To use our gem5 Conda environment on the pedagogical-{1, 2, 3, 4} machines, we've written some scripts that activate it for you. For your particular shell, **run the following command to activate the environment**:

<details>
<summary>bash</summary>

```shell
source ./conda/activate.bash
```

</details>

<details>
<summary>zsh</summary>

```shell
source ./conda/activate.zsh
```

</details>

<details>
<summary>fish</summary>

```shell
source ./conda/activate.fish
```

</details>
<br>

If you're using another shell, reach out to the TAs and we can write a script for you.

### Details

The activate script does the following things:
1. If you don't already have your own installation of Conda, it automatically loads our installation at `/var/local/speedway/miniforge3`.
2. It activates the gem5-cs-395t Conda environment.

Inside the gem5-cs-395t Conda environment, hooks automatically set/unset the necessary environment variables for you when you activate/deactivate the environment. These hooks are located at `$CONDA_PREFIX/etc/conda/activate.d` and `$CONDA_PREFIX/etc/conda/deactivate.d` respectively. Essentially, these scripts add/remove required libraries and programs to/from your shell's path variables.

## Verify

To verify that your environment is set up correctly, each of the following commands should return the following output:

```shell
> echo $CONDA_PREFIX
/scratch/cluster/speedway/opt/miniforge3/envs/gem5-cs-395t
```

```shell
> which python
/scratch/cluster/speedway/opt/miniforge3/envs/gem5-cs-395t/bin/python3
```

```shell
> echo $PATH
/scratch/cluster/speedway/opt/gcc/13.3.0/bin 
/scratch/cluster/speedway/opt/mold/2.35.1/bin
/scratch/cluster/speedway/opt/miniforge3/envs/gem5-cs-395t/bin
# <and possibly other paths...>
```

```shell
> echo $LD_LIBRARY_PATH
/scratch/cluster/speedway/opt/capstone/5.0.3/lib
/scratch/cluster/speedway/opt/hdf5/1.14.5/lib
/scratch/cluster/speedway/opt/miniforge3/envs/gem5-cs-395t/lib 
# <and possibly other paths...>
```

```shell
> echo $CPATH
/scratch/cluster/speedway/opt/capstone/5.0.3/include 
/scratch/cluster/speedway/opt/hdf5/1.14.5/include 
/scratch/cluster/speedway/opt/miniforge3/envs/gem5-cs-395t/include
# <and possibly other paths...>
```

```shell
> g++ --version
g++ (GCC) 13.3.0 # <and other info>
```

```shell
> mold --version
mold 2.35.1 (3cb551424bfcfd41e0f21a821b45ded33d06a38b; compatible with GNU ld)
```

Finally, building gem5 should just "work" without any warnings.
```
cd path/to/gem5
scons build/X86/gem5.fast -j8 --linker=mold
```

## Creating your own environment

Instead of using our environment, you can create your own. This could be useful
if you're using another machine besides the UTCS pedagogicals, or want to
change the packages that are included. Follow these steps:

### 1. Install conda

If you don't have your own copy of Conda installed, you can follow it using
the steps from the Conda website. There are several variants of Conda, but we
recommmend [miniforge](https://github.com/conda-forge/miniforge), which includes
`mamba`, a version of the `conda` executable that's written in C++. In our experience,
it runs much faster.

```
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh
```
If you choose to use `mamba` instead of `conda`, you can substitue `conda` for
`mamba` in each of the following commands.

### 2. Create a new environment

```
conda create -n gem5
conda activate gem5
```

### 3. Install the packages
```
conda install -c conda-forge python=3.13 pre-commit mypy
```

Or, whichever packages are listed in `enviornment.yml`.

### 4. Copy the hooks
```
mkdir -p $CONDA_PREFIX/etc/conda/activate.d
mkdir -p $CONDA_PREFIX/etc/conda/deactivate.d
cp ./conda/activate.d/* $CONDA_PREFIX/etc/conda/activate.d
cp ./conda/deactivate.d/* $CONDA_PREFIX/etc/conda/deactivate.d
```

### 5. Test the environment

Close the current terminal and open a new one. Then, activate the
environment again, and [verify](#Verify) that the environment is set up correctly.