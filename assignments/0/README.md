# Assignment 0: Setup

**TODO**: Write assignment to help students set up, compile, and run
"hello world"-level simulations on gem5 and ChampSim.

This assignment won't be graded and isn't worth any points, but will help
**set you up for success in later assignments**. You will be getting your
workspace set up on the UTCS machines so that you can work with two popular
microarchitectural simulators: gem5 and ChampSim. We'll simply get them to run
for this assignment. In the coming weeks, you'll begin experimenting with these
two simulators!

# Part 1: Initial Setup

## Prerequisites

Before we begin, you should:
1. Have a **UTCS account**
2. Have access to the `pedagogical` UTCS machines.

If you're missing one or both of these, please reach out to the TAs.

## Creating your workspace

**First, SSH into to one of the `pedagogical` machines** (numbered 1
through 4) with your CS ID. It doesn't matter which specific machine, as your
workspace will be available on all of them.

```shell
ssh pedagogical-1.cs.utexas.edu
```

For this class, we allocated some scratch space on the UT machines for you at
at `/projects/coursework/2025-spring/cs395t-lin/`. This directory should be
accessible on all the pedagogical machines as well as most other UTCS machines.

**Second, create your workspace directory** inside this folder, naming it with 
your UTCS ID.

```shell
mkdir /projects/coursework/2025-spring/cs395t-lin/$(whoami)
cd /projects/coursework/2025-spring/cs395t-lin/$(whoami)
```

> [!NOTE]
> If you can't access this folder, please reach out to the TAs.

> [!WARNING]
> This scratch space is NOT backed up, so, please keep copies of any files you 
> actually change or want to turn in somewhere else, too!

## Setting up the environment

Finally, we will set up an [Conda](https://docs.conda.io/en/latest/) environment
which helps you compile and run both of our simulators on the UTCS machines.
Without this environment, you will likely run into warnings and errors when
trying to build or run either simulator.

> [!WARNING]
> Everything you do with gem5 and ChampSim, including **building**, **running**, 
> and  **testing**, **should be done within the Conda environment!** Therefore, 
> you **must activate the environment every time you open a new terminal**! 
> Otherwise, you may get strange, unintuitive errors and warnings.

The simplest way to set up our environment is to use the activation scripts 
we've written for you. You can read more about it [here](../conda/README.md).
Depending on your shell, run one of the following commands:

<details>
<summary>bash</summary>

```shell
source ./gem5-configs-395t/conda/activate.bash
```

</details>

<details>
<summary>zsh</summary>

```shell
source /gem5-configs-395t/conda/activate.zsh
```

</details>

<details>
<summary>fish</summary>

```shell
source ./gem5-configs-395t/conda/activate.fish
```

</details>
<br>

Now, you're ready to start setting up the two simulators!

# Part 2: gem5

In this part, we'll set up [gem5](https://www.gem5.org/), a popular 
microarchitectural simulator. It's arguably the most powerful open-source 
microarchitectural simulator available, offering great flexibility, 
extensibility, and features, but can be tricky to set up and use.

## Getting gem5

Inside your personal folder, clone a fresh copy of gem5 from its 
[GitHub repository](https://github.com/gem5/gem5).

```shell
git clone https://github.com/gem5/gem5
```

Also, clone a copy of our configs repository, which will help you set up
and run gem5 on the pedagogical machines.

```shell
git clone https://github.com/SpeedwayGroup/gem5-configs-395t
```

## Building gem5

Next, activate the environment as described above. With the environment 
correctly activated, building gem5 should hopefully be a breeze.

```shell
cd gem5
scons build/X86/gem5.opt -j16 --linker=mold
```

Inside your personal gem5 directory, build gem5 with the following command.
```shell
scons build/X86/gem5.opt -j16 --linker=mold
```

Grab a coffee, water, etc., as building will take a while!

gem5 uses [SCons](https://scons.org/) to build itself, which we access
using the `scons` command. Here's what each argument means:
1. `build/X86/gem5.opt`: The type of gem5 binary to build.
    - `X86` supports the X86 ISA.
    - `opt` has optimizations enabled, and keeps basic debugging symbols.
2. `-j`: The number of cores to use to build the binary in parallel.
3. `--linker`: Which linker to use. 
    - The default linker, `ld`, is 
    [quite slow](https://www.gem5.org/project/2023/02/16/benchmarking-linkers.html),
    so our environment provides a much faster linker called 
    `mold` ([source code](https://github.com/rui314/mold)).

<details>
<summary>Troubleshooting</summary>

You may encounter some concerning messages or errors when trying to
build gem5:

-   The first time you build, you'll have to give approval to download a 
    pre-commit hooks file. Press Enter.
-   You may see a warning about not being able to find 'pre-commit'.
    Enter `y` as you don't need this.
-   You may see warnings about, deprecated namespaces, missing libraries, or
    other issues. These can be ignored as long the program compiles.
-   If you have any warnings or compilation errors, it's likely a problem with
    the Conda environment. Make sure you activated the environment by following
    the steps above or [here](../conda/README.md).

</details>

## Running gem5

Finally, we'll run a simple "Hello World!" simulation baked into gem5. The next
assignment will go into more detail about how gem5 works under the hood, so
don't worry too much about the specific command for now.

Make sure you're inside your gem5 directory. Then, run the following command:

```shell
build/X86/gem5.opt ../gem5-configs-395t/assignments/0/se-hello-world.py
```

You're welcome to look at `se-hello-world.py` to see how the simulation
is set up, but we'll go into more detail about this in Assignment 1a.

If all goes well, you should see some output like below. 

<details>
<summary>Sample output</summary>

```
gem5 Simulator System.  https://www.gem5.org
gem5 is copyrighted software; use the --copyright option for details.

gem5 version 24.1.0.1
gem5 compiled Jan  8 2025 08:42:21
gem5 started Jan  8 2025 08:47:56
gem5 executing on pedagogical-4, pid 1810550
command line: ./build/X86/gem5.opt ../gem5-configs-395t/assignments/0/se-hello-world.py

Beginning simulation!
Global frequency set at 1000000000000 ticks per second
warn: No dot file generated. Please install pydot to generate the dot file and pdf.
src/mem/dram_interface.cc:690: warn: DRAM device capacity (8192 Mbytes) does not match the address range assigned (32 Mbytes)
src/base/statistics.hh:279: warn: One of the stats is a legacy stat. Legacy stat is a stat that does not belong to any statistics::Group. Legacy stat is deprecated.
board.remote_gdb: Listening for connections on port 7000
src/sim/simulate.cc:199: info: Entering event queue @ 0.  Starting simulation...
Hello world!
Exiting @ tick 392766840 because exiting with last active thread context.
Total wall clock time: 0.06 s = 0.00 min
```

</details>

<details>
<summary>Troubleshooting</summary>

If you get the following exception:

```shell
Exception: Local path specified for resource, './tests/test-progs/hello/bin/x86/linux/hello', does not exist.
```

Make sure you're in the gem5 directory which you cloned from GitHub.

</details>

# Part 3: ChampSim

In this part, we'll set up [ChampSim](https://github.com/ChampSim/ChampSim),
another popular microarchitectural simulator. It's less powerful than gem5, but
it's easier to set up and experiment with.

## Getting ChampSim

Inside your personal folder, clone a fresh copy of ChampSim from its 
[GitHub repository](https://github.com/ChampSim/ChampSim).

```shell
git clone https://github.com/ChampSim/ChampSim
```

## Building ChampSim

Before we can compile ChampSim, we need to set up the C++ packages it
requires. ChampSim uses the [vcpkg](https://vcpkg.io/) package manager to
manage its C++ dependencies. You can examine `vcpkg.json` to see what packages 
that ChampSim requires.

To keep things simple and save storage space, we've provided a pre-built
`vcpkg` repository for you. To access this respository, run the following
commands in your ChampSim directory:

```shell
rm vcpkg -rf
ln -s /scratch/cluster/speedway/cs395t/champsim_vcpkg/vcpkg
ln -s /scratch/cluster/speedway/cs395t/champsim_vcpkg/vcpkg_installed
```

You can instead download the dependencies yourself by following the steps
[here](https://github.com/ChampSim/ChampSim?tab=readme-ov-file#download-dependencies),
but be warned that this takes a while and will require 350+ MB of storage space.

You should also **activate same environment we used for Part 2**. Otherwise,
you might get some build or runtime errors.

After doing everything above, build ChampSim:

```shell
./config.sh champsim_config.json
make -j16
```

This should build much faster than gem5!

## Running ChampSim

Let's first check that you built ChampSim correctly. Run:

```shell
./bin/champsim --help
```

You should get this output:

<details>
<summary>Sample output</summary>

```
[VMEM] WARNING: physical memory size is smaller than virtual memory size.
A microarchitecture simulator for research and education
Usage: ./bin/champsim [OPTIONS] traces

Positionals:
  traces TEXT:FILE REQUIRED   The paths to the traces

Options:
  -h,--help                   Print this help message and exit
  -c,--cloudsuite             Read all traces using the cloudsuite format
  --hide-heartbeat            Hide the heartbeat output
  -w,--warmup-instructions INT Excludes: --warmup_instructions
                              The number of instructions in the warmup phase
  --warmup_instructions INT Excludes: --warmup-instructions
                              [deprecated] use --warmup-instructions instead
  -i,--simulation-instructions INT Excludes: --simulation_instructions
                              The number of instructions in the detailed phase. If not specified, run to the end of the trace.
  --simulation_instructions INT Excludes: --simulation-instructions
                              [deprecated] use --simulation-instructions instead
  --json TEXT                 The name of the file to receive JSON output. If no name is specified, stdout will be used
```


> [!NOTE] The warning after `[VMEM]` can be safely ignored.

</details>



Now, let's run a simple simulation:

```shell
./bin/champsim -w 1000000 -i 1000000 \
   /scratch/cluster/speedway/cs395t/hw1a/champsim/matmul_small.xz
```

This simulation runs a trace of a simple benchmark called `matmul_small`. It warms
up the caches for 1,000,000 instructions (`-w 1000000`) and then simulates the
system and collects stats for the next 1,000,000 instructions (`-i 1000000`).

After a few minutes, you should get output similar to the one below. We'll
discuss how to analyze these results further in Assignment 1a.

<details>
<summary>Sample output</summary>

```
[VMEM] WARNING: physical memory size is smaller than virtual memory size.

*** ChampSim Multicore Out-of-Order Simulator ***
Warmup Instructions: 100000
Simulation Instructions: 100000
Number of CPUs: 1
Page size: 4096

Off-chip DRAM Size: 16 GiB Channels: 1 Width: 64-bit Data Rate: 3205 MT/s
Warmup finished CPU 0 instructions: 100002 cycles: 38837 cumulative IPC: 2.575 (Simulation time: 00 hr 00 min 04 sec)
Warmup complete CPU 0 instructions: 100002 cycles: 38837 cumulative IPC: 2.575 (Simulation time: 00 hr 00 min 04 sec)
Simulation finished CPU 0 instructions: 100002 cycles: 262277 cumulative IPC: 0.3813 (Simulation time: 00 hr 00 min 08 sec)
Simulation complete CPU 0 instructions: 100002 cycles: 262277 cumulative IPC: 0.3813 (Simulation time: 00 hr 00 min 08 sec)

ChampSim completed all CPUs

=== Simulation ===
CPU 0 runs /scratch/cluster/speedway/cs395t/hw1a/champsim/matmul_small.xz

Region of Interest Statistics

CPU 0 cumulative IPC: 0.3813 instructions: 100002 cycles: 262277
CPU 0 Branch Prediction Accuracy: 85.74% MPKI: 25.02 Average ROB Occupancy at Mispredict: 12.45
Branch type MPKI
BRANCH_DIRECT_JUMP: 0.41
BRANCH_INDIRECT: 0.1
BRANCH_CONDITIONAL: 23.32
BRANCH_DIRECT_CALL: 0.49
BRANCH_INDIRECT_CALL: 0.12
BRANCH_RETURN: 0.58

cpu0->cpu0_STLB TOTAL        ACCESS:         38 HIT:          8 MISS:         30 MSHR_MERGE:          0
cpu0->cpu0_STLB LOAD         ACCESS:         38 HIT:          8 MISS:         30 MSHR_MERGE:          0
cpu0->cpu0_STLB RFO          ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_STLB PREFETCH     ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_STLB WRITE        ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_STLB TRANSLATION  ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_STLB PREFETCH REQUESTED:          0 ISSUED:          0 USEFUL:          0 USELESS:          0
cpu0->cpu0_STLB AVERAGE MISS LATENCY: 464.2 cycles
cpu0->cpu0_L2C TOTAL        ACCESS:       1854 HIT:        491 MISS:       1363 MSHR_MERGE:          0
cpu0->cpu0_L2C LOAD         ACCESS:       1442 HIT:        280 MISS:       1162 MSHR_MERGE:          0
cpu0->cpu0_L2C RFO          ACCESS:        204 HIT:         33 MISS:        171 MSHR_MERGE:          0
cpu0->cpu0_L2C PREFETCH     ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L2C WRITE        ACCESS:        174 HIT:        174 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L2C TRANSLATION  ACCESS:         34 HIT:          4 MISS:         30 MSHR_MERGE:          0
cpu0->cpu0_L2C PREFETCH REQUESTED:          0 ISSUED:          0 USEFUL:          0 USELESS:          0
cpu0->cpu0_L2C AVERAGE MISS LATENCY: 183 cycles
cpu0->cpu0_L1I TOTAL        ACCESS:       5389 HIT:       5131 MISS:        258 MSHR_MERGE:         42
cpu0->cpu0_L1I LOAD         ACCESS:       5389 HIT:       5131 MISS:        258 MSHR_MERGE:         42
cpu0->cpu0_L1I RFO          ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L1I PREFETCH     ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L1I WRITE        ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L1I TRANSLATION  ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L1I PREFETCH REQUESTED:          0 ISSUED:          0 USEFUL:          0 USELESS:          0
cpu0->cpu0_L1I AVERAGE MISS LATENCY: 200 cycles
cpu0->cpu0_L1D TOTAL        ACCESS:      24015 HIT:      19367 MISS:       4648 MSHR_MERGE:       3184
cpu0->cpu0_L1D LOAD         ACCESS:      19560 HIT:      17097 MISS:       2463 MSHR_MERGE:       1237
cpu0->cpu0_L1D RFO          ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L1D PREFETCH     ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L1D WRITE        ACCESS:       4418 HIT:       2267 MISS:       2151 MSHR_MERGE:       1947
cpu0->cpu0_L1D TRANSLATION  ACCESS:         37 HIT:          3 MISS:         34 MSHR_MERGE:          0
cpu0->cpu0_L1D PREFETCH REQUESTED:          0 ISSUED:          0 USEFUL:          0 USELESS:          0
cpu0->cpu0_L1D AVERAGE MISS LATENCY: 150.8 cycles
cpu0->cpu0_ITLB TOTAL        ACCESS:       4347 HIT:       4315 MISS:         32 MSHR_MERGE:         12
cpu0->cpu0_ITLB LOAD         ACCESS:       4347 HIT:       4315 MISS:         32 MSHR_MERGE:         12
cpu0->cpu0_ITLB RFO          ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_ITLB PREFETCH     ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_ITLB WRITE        ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_ITLB TRANSLATION  ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_ITLB PREFETCH REQUESTED:          0 ISSUED:          0 USEFUL:          0 USELESS:          0
cpu0->cpu0_ITLB AVERAGE MISS LATENCY: 417.2 cycles
cpu0->cpu0_DTLB TOTAL        ACCESS:      21951 HIT:      21914 MISS:         37 MSHR_MERGE:         19
cpu0->cpu0_DTLB LOAD         ACCESS:      21951 HIT:      21914 MISS:         37 MSHR_MERGE:         19
cpu0->cpu0_DTLB RFO          ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_DTLB PREFETCH     ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_DTLB WRITE        ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_DTLB TRANSLATION  ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_DTLB PREFETCH REQUESTED:          0 ISSUED:          0 USEFUL:          0 USELESS:          0
cpu0->cpu0_DTLB AVERAGE MISS LATENCY: 322.4 cycles
cpu0->LLC TOTAL        ACCESS:       1363 HIT:          0 MISS:       1363 MSHR_MERGE:          0
cpu0->LLC LOAD         ACCESS:       1162 HIT:          0 MISS:       1162 MSHR_MERGE:          0
cpu0->LLC RFO          ACCESS:        171 HIT:          0 MISS:        171 MSHR_MERGE:          0
cpu0->LLC PREFETCH     ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->LLC WRITE        ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->LLC TRANSLATION  ACCESS:         30 HIT:          0 MISS:         30 MSHR_MERGE:          0
cpu0->LLC PREFETCH REQUESTED:          0 ISSUED:          0 USEFUL:          0 USELESS:          0
cpu0->LLC AVERAGE MISS LATENCY: 167 cycles

DRAM Statistics

Channel 0 RQ ROW_BUFFER_HIT:        156
  ROW_BUFFER_MISS:       1205
  AVG DBUS CONGESTED CYCLE: 2.855
Channel 0 WQ ROW_BUFFER_HIT:          0
  ROW_BUFFER_MISS:          0
  FULL:          0
Channel 0 REFRESHES ISSUED:         22
[+] pedagogical-4 /v/l/c/ChampSim >
./bin/champsim -w 1000000 -i 1000000 /scratch/cluster/speedway/cs395t/hw1a/champsim/matmul_small.xz
[+] pedagogical-4 /v/l/c/ChampSim >
./bin/champsim -w 1000000 -i 1000000 /scratch/cluster/speedway/cs395t/hw1a/champsim/matmul_small.xz
[VMEM] WARNING: physical memory size is smaller than virtual memory size.

*** ChampSim Multicore Out-of-Order Simulator ***
Warmup Instructions: 1000000
Simulation Instructions: 1000000
Number of CPUs: 1
Page size: 4096

Off-chip DRAM Size: 16 GiB Channels: 1 Width: 64-bit Data Rate: 3205 MT/s
^C⏎                                                                                                     [+] pedagogical-4 /v/l/c/ChampSim >                                         [🐙 master][🐍 gem5-cs-395t]
[+] pedagogical-4 /v/l/c/ChampSim >
./bin/champsim -w 1000000 -i 1000000 /scratch/cluster/speedway/cs395t/hw1a/champsim/matmul_small.xz
[VMEM] WARNING: physical memory size is smaller than virtual memory size.

*** ChampSim Multicore Out-of-Order Simulator ***
Warmup Instructions: 1000000
Simulation Instructions: 1000000
Number of CPUs: 1
Page size: 4096

Off-chip DRAM Size: 16 GiB Channels: 1 Width: 64-bit Data Rate: 3205 MT/s
Warmup finished CPU 0 instructions: 1000001 cycles: 269261 cumulative IPC: 3.714 (Simulation time: 00 hr 00 min 27 sec)
Warmup complete CPU 0 instructions: 1000001 cycles: 269261 cumulative IPC: 3.714 (Simulation time: 00 hr 00 min 27 sec)
Simulation finished CPU 0 instructions: 1000002 cycles: 255971 cumulative IPC: 3.907 (Simulation time: 00 hr 00 min 48 sec)
Simulation complete CPU 0 instructions: 1000002 cycles: 255971 cumulative IPC: 3.907 (Simulation time: 00 hr 00 min 48 sec)

ChampSim completed all CPUs

=== Simulation ===
CPU 0 runs /scratch/cluster/speedway/cs395t/hw1a/champsim/matmul_small.xz

Region of Interest Statistics

CPU 0 cumulative IPC: 3.907 instructions: 1000002 cycles: 255971
CPU 0 Branch Prediction Accuracy: 99.92% MPKI: 0.026 Average ROB Occupancy at Mispredict: 349.5
Branch type MPKI
BRANCH_DIRECT_JUMP: 0
BRANCH_INDIRECT: 0
BRANCH_CONDITIONAL: 0.026
BRANCH_DIRECT_CALL: 0
BRANCH_INDIRECT_CALL: 0
BRANCH_RETURN: 0

cpu0->cpu0_STLB TOTAL        ACCESS:         68 HIT:          0 MISS:         68 MSHR_MERGE:          0
cpu0->cpu0_STLB LOAD         ACCESS:         68 HIT:          0 MISS:         68 MSHR_MERGE:          0
cpu0->cpu0_STLB RFO          ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_STLB PREFETCH     ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_STLB WRITE        ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_STLB TRANSLATION  ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_STLB PREFETCH REQUESTED:          0 ISSUED:          0 USEFUL:          0 USELESS:          0
cpu0->cpu0_STLB AVERAGE MISS LATENCY: 207.6 cycles
cpu0->cpu0_L2C TOTAL        ACCESS:       8614 HIT:       4304 MISS:       4310 MSHR_MERGE:          0
cpu0->cpu0_L2C LOAD         ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L2C RFO          ACCESS:       4310 HIT:          0 MISS:       4310 MSHR_MERGE:          0
cpu0->cpu0_L2C PREFETCH     ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L2C WRITE        ACCESS:       4304 HIT:       4304 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L2C TRANSLATION  ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L2C PREFETCH REQUESTED:          0 ISSUED:          0 USEFUL:          0 USELESS:          0
cpu0->cpu0_L2C AVERAGE MISS LATENCY: 226.2 cycles
cpu0->cpu0_L1I TOTAL        ACCESS:     154985 HIT:     154985 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L1I LOAD         ACCESS:     154985 HIT:     154985 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L1I RFO          ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L1I PREFETCH     ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L1I WRITE        ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L1I TRANSLATION  ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L1I PREFETCH REQUESTED:          0 ISSUED:          0 USEFUL:          0 USELESS:          0
cpu0->cpu0_L1I AVERAGE MISS LATENCY: - cycles
cpu0->cpu0_L1D TOTAL        ACCESS:     254117 HIT:     185173 MISS:      68944 MSHR_MERGE:      64634
cpu0->cpu0_L1D LOAD         ACCESS:     150610 HIT:     150610 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L1D RFO          ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L1D PREFETCH     ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L1D WRITE        ACCESS:     103439 HIT:      34495 MISS:      68944 MSHR_MERGE:      64634
cpu0->cpu0_L1D TRANSLATION  ACCESS:         68 HIT:         68 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_L1D PREFETCH REQUESTED:          0 ISSUED:          0 USEFUL:          0 USELESS:          0
cpu0->cpu0_L1D AVERAGE MISS LATENCY: 235.2 cycles
cpu0->cpu0_ITLB TOTAL        ACCESS:     120933 HIT:     120933 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_ITLB LOAD         ACCESS:     120933 HIT:     120933 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_ITLB RFO          ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_ITLB PREFETCH     ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_ITLB WRITE        ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_ITLB TRANSLATION  ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_ITLB PREFETCH REQUESTED:          0 ISSUED:          0 USEFUL:          0 USELESS:          0
cpu0->cpu0_ITLB AVERAGE MISS LATENCY: - cycles
cpu0->cpu0_DTLB TOTAL        ACCESS:     214212 HIT:     213668 MISS:        544 MSHR_MERGE:        476
cpu0->cpu0_DTLB LOAD         ACCESS:     214212 HIT:     213668 MISS:        544 MSHR_MERGE:        476
cpu0->cpu0_DTLB RFO          ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_DTLB PREFETCH     ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_DTLB WRITE        ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_DTLB TRANSLATION  ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->cpu0_DTLB PREFETCH REQUESTED:          0 ISSUED:          0 USEFUL:          0 USELESS:          0
cpu0->cpu0_DTLB AVERAGE MISS LATENCY: 213.6 cycles
cpu0->LLC TOTAL        ACCESS:       5591 HIT:       1281 MISS:       4310 MSHR_MERGE:          0
cpu0->LLC LOAD         ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->LLC RFO          ACCESS:       4310 HIT:          0 MISS:       4310 MSHR_MERGE:          0
cpu0->LLC PREFETCH     ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->LLC WRITE        ACCESS:       1281 HIT:       1281 MISS:          0 MSHR_MERGE:          0
cpu0->LLC TRANSLATION  ACCESS:          0 HIT:          0 MISS:          0 MSHR_MERGE:          0
cpu0->LLC PREFETCH REQUESTED:          0 ISSUED:          0 USEFUL:          0 USELESS:          0
cpu0->LLC AVERAGE MISS LATENCY: 210.2 cycles

DRAM Statistics

Channel 0 RQ ROW_BUFFER_HIT:          0
  ROW_BUFFER_MISS:       4305
  AVG DBUS CONGESTED CYCLE: 2.858
Channel 0 WQ ROW_BUFFER_HIT:          0
  ROW_BUFFER_MISS:          0
  FULL:          0
Channel 0 REFRESHES ISSUED:         21
```

</details>

# Submission

You have nothing to submit for this assigment! Just make sure that everything
works correctly. If you have any issues, please reach out to the TAs. With
this setup work complete, you should be prepared to start Assignment 1a!