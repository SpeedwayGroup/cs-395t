# Conda environment

Building gem5 and getting it to run can be tricky, in our experience! To help you get started quickly, we've set up a [Conda](https://docs.conda.io/projects/conda/en/latest/index.html) environment for you that works on the pedagogical machines.

> [!WARNING]
> Everything you do with gem5, including **building**, **running**, and **testing**, **must be done within the Conda environment!** Therefore, you **must activate the environment every time you open a new terminal**! Otherwise, you may get strange, unintuitive errors such as a missing Python installation or missing libraries.

## Setup
### Automatic setup (on pedagogical machines)

To use our gem5 Conda environment on the pedagogical-{1, 2, 3, 4} machines, we've already set it up for you. Run the following command to activate the environment for your shell:

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

The activate script does the following things:
1. If you don't already have your own installation of Conda, it automatically loads our installation at `/var/local/speedway/miniforge3`.
2. It activates the gem5-cs-395t Conda environment.

Inside the gem5-cs-395t Conda environment, hooks automatically set/unset the necessary environment variables for you when you activate/deactivate the environment. These hooks are located at `$CONDA_PREFIX/etc/conda/activate.d` and `$CONDA_PREFIX/etc/conda/deactivate.d` respectively. Essentially, these scripts add/remove our environment's libraries, a specific version of GCC, and the mold linker to/from your environment.

If you prefer, you can instead set up your own Conda environment manually by following the instructions below.

### Manual setup

> [!NOTE]
> **TODO**: Write how to set up your own installation of miniforge3, create an environment,
> copy over {de}activate.d scripts, and install the necessary packages from
> environment.yml.

## Verify

To verify that your environment is set up correctly, each of the following commands should return the following output:

```shell
> which python
/var/local/speedway/envs/gem5-cs-395t/bin/python3
```

```shell
> echo $CONDA_PREFIX
/var/local/speedway/envs/gem5-cs-395t
```

```shell
> echo $PATH
/var/local/speedway/envs/gem5-cs-395t/bin /scratch/cluster/speedway/opt/gcc/13.3.0/bin # <and possibly other paths...>
```

```shell
> echo $LD_LIBRARY_PATH
/var/local/speedway/envs/gem5-cs-395t/lib # <and possibly other paths...>
```

```shell
> echo $CPATH
/var/local/speedway/envs/gem5-cs-395t/include # <and possibly other paths...>
```

```shell
> g++ --version
g++ (GCC) 13.3.0 # <and other info>
```

```shell
> mold --version
mold 2.35.1 (3cb551424bfcfd41e0f21a821b45ded33d06a38b; compatible with GNU ld)
```