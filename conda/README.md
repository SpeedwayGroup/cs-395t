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

> [!TODO]
> Also set prepend GCC 13.3.0 directories (`/scratch/cluster/speedway/opt/gcc/13.3.0`) 
> to the path/include/library variables to  to ensure gem5 compiles correctly.
> You might get a compiler error using the system's default GCC version (9.4.0).

### Manual setup

> [!TODO]
> Write how to set up your own installation of miniforge3, create an environment,
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