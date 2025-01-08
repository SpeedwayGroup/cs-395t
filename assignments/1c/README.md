# Assignment 1c: gem5 Experimentation
**Due TBD at 11:59pm CST**

In this assignment you will add either a branch predictor or a cache
replacement policy to the Gem5 simulator and evaluate its accuracy and
performance impact in full-system simulation mode. Like assignemnt 1b, you won't
have to write a lot of code, but you will need o understand different concepts 
in prediction and simulation and to carefully evaluate your design.

# Your Assignment

This assignment has three parts:
1.  You will implement a new branch predictor or cache replacement
    policy in gem5. This can be an implementation of a predictor we've
    discussed in class, an extension of a predictor we've discussed in
    class, or an entirely new idea.
2.  You will run experiments with your predictor to explore different
    design choices such as varying hardware budget or changing
    saturating counter sizes.
3.  You will write a report that describes what you've done, includes
    your results, and draws relevant conclusions from your experiments.

Note that if you implement an existing predictor, **it cannot be one of
the predictors that are already implemented in gem5**. This makes cache
replacement a bit difficult, as most of the policies we've discussed are
already implemented. But the upside is that you can look through their
implementations to see how to do set dueling, then use it as a basis to
experiment with a creative proposal of your own, if you want.

# Details
## Full system simulation
Unlike in Assignment 1a, we'll be using gem5 in full-system (fs) mode,
which simulates the interactions of the entire system and OS kernel,
rather than just the CPU and memory hierarchy. This means that you will
actually boot the Linux kernel inside the simulator before running your
benchmark. It also means that the kernel will interrupt your benchmark's
execution to handle syscalls, I/O, and run the scheduler just like
happens on real hardware. To boot the kernel, we'll use a fast
simulation core to save time, as it would take many hours on the
detailed out-of-order core model we used in 1A.

> [!NOTE]
> To be specific, the fast simulation core is actually using Kernel-based 
> Virtual Machine (KVM) to execute our system's instructions on the host 
> machine's bare metal CPU. This is *significantly* faster than a simulated 
> core, but has a couple of drawbacks:
>
> 1. The ISAs of the host and simulated system must match (unless you use a 
>    translation layer like QEMU)
> 2. You need significant access to the host system. 
>
> Drawback 2 is why we're running our gem5 simulations on the `pedagogical` 
> machines instead of other UTCS machines.

You'll be using a different Python config script from the one you used
in Assignment 1A. This time, we'll use `fs_spec06_gap_with_sampling.py`,
which is our top-level Python config for running simulations on SPEC06
and GAP workloads in full-system mode.

Before you start, clone a fresh copy of the `gem5-configs-395t`
repository and apply the following patch by running the following
command inside of the `gem5-configs-395t` directory:

```shell
git apply /scratch/cluster/speedway/cs395t/hw1c/gem5-config-soln.patch
```

`fs_spec06_gap_with_sampling.py` configures the same system as last
time, but this time it creates a board with a kernel binary and disk
image (as we have to provide everything a full system expects to have).
gem5 will look for the kernel binary you specify on your file system,
and if it doesn't find it, it'll download it from gem5 resources and put
it in $\sim$`/.cache/` in your home space. Since your quota in the home
directory is very small, we recommend you tell gem5 to put it somewhere
else by setting the following environment variable in your shell:

```shell
mkdir -p \
    /projects/coursework/2024-spring/cs395t-lin/$(whoami)/gem5_resources
export GEM5_RESOURCE_DIR=\
    /projects/coursework/2024-spring/cs395t-lin/$(whoami)/gem5_resources
```

We've built the disk image for you. It includes a copy of Ubuntu 18.04.6
LTS (the OS you'll boot in simulation) as well as a file system that
already has the benchmarks you'll use for your experimentation. We've
used `.bashrc` on that disk image to control what happens immediately
after the OS boots: in this case, it will read a text string
(`readfile_contents` specified in `fs_spec06_gap_with_sampling.py`) into
a file on the simulated file system, then execute that file. This is how
we invoke our benchmark. But first, a special **`m5` op** -- you can
think of these as hardware instructions the simulated hardware knows how
to execute but real hardware doesn't -- causes a trap into the simulator
to allow the Python config to change simulator behavior. These `m5` ops
are how we switch from our fast simulation core to our detailed core
model before executing our benchmark. You can also use them to start,
stop, and reset the collection of statistics.

Once you've read all of this handout, look through
`fs_spec06_gap_with_sampling.py` so you understand the basics of what
it's doing. You don't need to understand it in detail, as you don't need
to change anything about it for this assignment. But the way it's using
`m5` ops -- both those in the disk image and ones it schedules itself
(via\
`simulator.schedule_max_insts()`) -- and then defining custom behavior
that should happen on those "exit events\" is the heart of how you use
the Gem5 standard library to interact with simulations.\
At this point you should run a benchmark or two to try out full-system
simulation. (See the Benchmarks section below for the run command, but
since you're just playing, use smaller numbers for all of the
command-line options for shorter run time.)

Also remember to give Gem5 an `–outdir` flag so it puts output somewhere
you intend, not in the default `m5out` dir. Optionally, you can use
`-re` to redirect stderr and stdout to file -- though it's simulator
output only, not output from the simulated program, and leaving it
printing to console is a nice way to monitor what's going on.

Look through the files created in your output directory. All output from
the simulated system (including the OS boot log and any benchmark
output) will be in `board.pc.com_1.device`. If you want to watch the
kernel boot, you can follow this file while it's being written:

```shell
tail -f board.pc.com_1.device
```

Your run statistics will be in `stats.txt`. There are a couple
differences in this file compared to last time. First, you'll notice
there are statistics for two different processor cores:
`processor.start.core` is the core that simulation began in, in this
case the fast core; `processor.switch.core` is the detailed timing core
we switched to for stats collection. Second, there will be multiple
sections of statistics delimited by \"Begin Simulation Statistics\" and
\"End Simulation Statistics\". Each region of interest (see the
Benchmarks section below) will have its own stats section[^2].

Look at the handout for 1A for a reminder of some interesting statistics
you may want to look at to be able to calculate IPC, MPKI, etc.

## Adding A New Predictor

Now it's time to make our first modifications to Gem5 itself!

In the base directory of your `gem5` repo, apply the following patch:

```shell
git apply /scratch/cluster/speedway/cs395t/hw1c/gem5-pred-templates.patch
```

This creates some blank templates for new predictors and stitches them
into the build files so they're added to the simulator next time you
compile Gem5.

### Branch Predictor

The template files for adding a new branch predictor are in
`gem5/src/cpu/pred/`. You can grep for the string `CS395T` to find
everything we added. The new lines in `SConscript` tell the build system
about the new branch predictor type and cause the C++ files defining its
behavior to be compiled when you re-build Gem5. The changes in
`BranchPredictor.py` define the Python class for the new predictor.
`cs395t_bp.cc/.hh` specify the C++ class that actually implements the
simulator behavior. All your changes should go in the two new C++ files
(unless you want to add more than one new predictor type, in which case
you should mimic our changes in the other two files to add your other
predictors, too.)

There are 5 methods that you have to implement for a branch predictor.
We've written some comments (with `TODO FIXME`) in the C++
implementation file describing what each should do, but we encourage you
to read the code of some of the other branch predictors we talked about
in class to understand what each function should do.

If your predictor includes parameters (e.g., table size), we've included
an example in the cache replacement policy template for how to add
parameters to Gem5 SimObjects.

### Cache Replacement Policy

The template files for adding a new cache replacement policy are in\
`gem5/src/mem/cache/replacement_policies`. Again, you can grep for the
string `CS395T` to find our additions, which will be in analogous files
to the branch predictor templates.

There are 4 methods that you have to implement for a cache replacement
policy. Here, too, we've added comments in `cs395t_rp.cc` telling you
what each function should do, but we encourage you to explore existing
cache replacement policies for examples.

Note that our new cache replacement SimObject includes a size parameter,
as an example of how to parameterize new Gem5 predictors. You can remove
this if you don't need it.

## Benchmarks

We have provided the same 6 SPEC benchmarks and 2 GAP benchmarks for
this assignment as for part 1B. However, our script supports more SPEC
and GAP benchmarks, so you're welcome to try them out if you are
curious.

Recall from the last assignment that large programs typically run for
billions of instructions, which would be much too slow to simulate on a
microarchitectural simulator. In 1B, we gave you a SimPoint of each
benchmark (a representative region of the program determined by an
offline phase calculation algorithm). For Gem5, we're going to
accelerate simulation by using **statistical sampling**: we will do an
initial fast-forward (using a fast simulation core that doesn't model
microarchitectural structures like caches, pipelines, or predictors)
past the initialization phase of the program and then begin to iterate
through three simulation phases:

-   **Fast Forward:** Uses a fast simulation core to simulate `X`
    million instructions, during which no microarchitectural structure
    models are updated. We'll use the KVM core, which directly runs the
    simulated instructions on your host machine via a virtual machine,
    and is thus incredibly fast (i.e., we can boot the OS on the
    simulator in 30 seconds or less).

-   **Warmup:** Switches to the same detailed out-of-order core model
    and memory hierarchy models we used last time, and simulates `Y`
    million instructions to warm the state of microarchitectural
    structures like caches and predictors without collecting statistics.

-   **Region of Interest (ROI):** Still using the detailed core model,
    collect statistics for the next `Z` million instructions.

If we were evaluating an idea to publish, we'd want to run many
iterations of this (just as we'd want to run many more of the SimPoints
we used for 1B). For now, to save time, we will collect statistics for
the first few ROIs only.

The provided Python script will handle the statistical sampling for you
provided you specify on the command line the number of ROIs to run, the
numbers of instructions in the initial fast-forward period, and the
values of X, Y, and Z above. Here's the format of a run command:

```shell
/path/to/gem5/build/X86/gem5.opt --outdir=<dir_name> \
    /path/to/gem5-configs-395t/fs_spec06gap_with_sampling.py \
    --benchmark <benchmark name> \
    --init_ff NUM_INIT_INSTS --ff X --warmup Y --roi Z --max_rois NUM_ROIS
```

Note that NUM_INIT_INSTS, X, Y, and Z are all expressed in millions,
i.e. to run with a warmup interval of 25 million instructions, Y=25. For
this assignment, please use an initial fast-forward window of 50B
instructions, 3 ROIs, and sampling periods of X=10B (fast-forward),
Y=25M (warmup), and Z=50M (ROI).

The benchmarks you should run are:
- astar
- bfs
- cc
- mcf
- omnetpp
- soplex
- sphinx3
- xalancbmk

## Report

You should write a report that describes your experiments, the results
you got from these experiments (relative to LRU for cache replacement or
the LocalBP predictor for branch prediction) and your conclusions from
the results. If you've experimented with design points or against
baselines that were not described in the assignment, please include a
description of those with an explanation for why you chose to do those
experiments.

# What To Turn In

Upload a `.zip` file containing your predictors' code and your report to
Cnavas under "Assignemnt 1c", and leave a comment with the names of everyone 
in your group.

# Grading

Your grade will be based on three factors:
-   **Implementation:** Your code successfully simulates your predictor
    and your results noticeably differ from your baseline.
-   **Experiments:** You showed some relevant characteristic of your
    predictor using empirical results.
-   **Presentation:** Your experiments and analysis are concise and
    logically displayed.