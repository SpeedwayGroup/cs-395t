# Assignment 2: gem5 Multicore Prefetching
**Due TBD at 11:59pm CST**

In this assignment you will add a prefetcher to the Gem5 simulator and
evaluate its accuracy and performance impact on multithreaded workloads
on a simulated full system with *multiple cores*. For this assignment,
we want you to be creative: rather than implementing a prefetcher we've
read about in class, we want you to do something novel.

**Before you start implementing your prefetcher, we would like to review
your proposed idea first. Please submit your idea in a Private Post on
Ed Discussion by [Sunday, March 10th at 11:59 PM CDT]{.underline}. Your
post should be titled "Assignment 2 Proposal: Your Names". Also, if you
submit it earlier, we'll review it sooner :)**. Regardless, you're
encouraged to go ahead and start collecting baseline numbers now and
figure out which experiments you'd like to run (see Section
[2.4](#sec:advice){reference-type="ref" reference="sec:advice"}).

# Your Assignment

This assignment has three parts:

1.  You will implement a new prefetcher in gem5. Your prefetcher should
    have some novel aspect: while you can start with an idea we've
    discussed in class, you should try out some ideas of your own. Feel
    free to bounce your ideas off of us!

2.  You will run experiments with your prefetcher to study its
    performance on a set of multithreaded benchmarks. The experiments
    you run are up to you: what baseline you compare against, what
    parameters of your prefetcher to vary, which cache level(s) to
    install your prefetcher in, what core counts you study, how to
    configure the rest of the system, etc. Your evaluation should be
    thorough and you should describe the rationale for the choices you
    made.

3.  You will write a report that describes what you've done and your
    reasoning, reports your results, and draws relevant conclusions from
    your experiments.

# Details

For Assignment 2, you should start with a fresh copy of gem5 and our
Python configuration files. You can `git clone` a fresh copy of both
repositories (or run `git checkout` then `git clean -df` then
`git pull`), and then apply both of the patches we provided for that
assignment [^1]. A set of example commands is provided below. **Make
sure you back up anything you want to keep in your old repos first if
you decide to delete them!**

        > rm gem5/ gem5-configs-395t/ -rf
        > git clone https://github.com/SpeedwayGroup/gem5-configs-395t.git
        > git clone https://github.com/gem5/gem5
        > cd gem5-configs-395t/
        > git apply /scratch/cluster/speedway/cs395t/hw1c/gem5-config-soln.patch
        > cd ../gem5/
        > git apply /scratch/cluster/speedway/cs395t/hw1c/gem5-pred-templates.patch

You can use the same `pedagogical` machine as before.

## Config script

The config repo contains a script `fs_gapparsec.py`, which lets you run
multi-threaded GAP and PARSEC workloads on a multi-core gem5 simulation.
This configuration script looks much like the ones we've used before,
but it uses a disk image with versions of the GAP and PARSEC parallel
benchmark suites that have their ROIs annotated with m5 ops. Since this
script runs multicore simulations, we also forego the Skylake CPU
configuration from earlier homeworks and instead use gem5's default
model.

We've also pushed a new commit that adds two new knobs for this script
and others, `–start_core_type` and `–switch_core_type`, which specify
which kind of core (e.g. KVM, O3, atomic, etc.) is run during the
startup phase and detailed simulation repsectively [^2].

For this assignment, we recommend using the KVM core for startup
(`–start_core_type kvm`) and the TIMING core
(`–switch_core_type timing`) for simulation. The TIMING core is similar
to the core modeled by ChampSim, in which all non-memory instructions
are executed with a fixed, one-cycle latency. This allows for
simulations that run $\sim$`<!-- -->`{=html}4x faster than with an O3
core. But, you are welcome to experiment with your prefetcher on O3
(`–switch_core_type o3`) and compare it to TIMING and report your
results. **Make sure to specify `–switch_core_type timing`, or else it
will run O3 by default!**

The config file instantiates the same memory hierarchy as we've used in
previous Gem5 assignments. You can investigate the cache hierarchy in
`components/cache_hierarchies/three_level_classic.py`. It sets up a
system with an L1 and L2 cache private to each core, and an LLC shared
by all cores.

Remember that to save home quota space, you may want to set
`GEM5_RESOURCE_DIR` in your shell.

## Adding your prefetcher

The template files for adding a new prefetcher are in
`gem5/src/mem/cache/prefetch`. Like last time, you can grep for the
string `CS395T` to find our additions.

There's only one method you have to implement, `calculatePrefetch`. But
you'll likely end up adding some helper functions as well. We encourage
you to explore the code for existing prefetchers for examples, as you
may be able to find existing implementations of some of the
functionality you want. While you're required to add some novel aspect
to your solution, that doesn't mean you can't re-use existing code for
some parts of your solution.

If you need to add parameters, you can follow the example provided by
`example_size` [^3].

## Benchmarks

For this assignment, we've provided parallel applications from the GAP
and PARSEC benchmark suites. Your evaluation should run your prefetcher
on **all of the benchmarks** in Table
[1](#tab:a2_benchmarks){reference-type="ref"
reference="tab:a2_benchmarks"} and compare them to a reasonable baseline
system of your choice.

::: {#tab:a2_benchmarks}
  **Suite**   **Description**         **Benchmarks**
  ----------- ----------------------- ----------------------------------------------------------------------------------------------------------------------------------
  GAP         Irregular graph codes   bc, bfs, cc, pr, sssp, tc
  PARSEC      Scientific workloads    blackscholes, bodytrack, canneal, dedup, facesim, ferret, fluidanimate, freqmine, raytrace, streamcluster, swaptions, vips, x264

  : All the benchmarks you should run for Assignment 2
:::

For each benchmark, we've provided a `small`, `medium`, and `large`
input. PARSEC comes with "sim"-sized inputs intended for use with
academic simulators; for GAP, we've tried to choose graphs that result
in similar instruction counts to the PARSEC inputs. These are mostly
road networks, with a few synthetic graphs for the applications that
take too long on real graphs. You can see how small, medium, and large
are defined for each benchmark inside `workloads/fs/gap_and_parsec.py`
in the config repo.

We won't worry about sampling for this assignment. Both benchmark suites
have `m5 workbegin` and `workend` hooks inserted into their source code.
The Python config script we've given you will use the KVM core for OS
boot and the initialization code of the benchmark, then switch to the
TIMING core when the ROI begins, assuming you passed the correct knobs.
Simulation will terminate at the ROI end.

## Advice for the assignment {#sec:advice}

-   **Make good choices about the sizes you choose** for your
    experiments. The small inputs are provided for testing your
    prefetcher, but for many benchmarks they result in ROIs with fewer
    than 100 million instruction, so they are not valuable for
    evaluation. (For others, like `tc`, small is fine.) Start with the
    smallinputs on each benchmark, and increase the input size if the
    ROI length is too short. A good ROI length is $\geq$
    $\sim$`<!-- -->`{=html}200M instructions.

-   **Start early**. Multicore runs on gem5 take a while! For instance,
    we ran `swaptions` on the `small` input on a 2- and 4-core
    simulation on `pedagogical` and it took 48 and 53 minutes
    respectively. Even before your prefetcher design is approved, you
    can begin collecting baseline results and figure out which input
    size you want to use for each benchmark in your final evaluation.

-   **Take advantage of automation when you can**. The script
    `run_cmds_locally.py` in the config repo lets you run a fixed number
    of gem5 jobs in parallel on `pedagogical`[^4]. You can run this
    script inside a `tmux` or `screen` session so that you don't have to
    stay logged in while these jobs execute. **Please make sure that
    there's some non-busy cores first with `htop`, and don't have more
    than $\sim$`<!-- -->`{=html}8 gem5 jobs running at a time so others
    can launch runs as well!**

## Report

You should write a report that describes your prefetcher design, what
cache level(s) you chose for your prefetcher to operate at and why,
whether you added built-in prefetchers or changed the replacement policy
at any other level of the cache (or anything else about the system
configuration you changed), your experiments and their rationale, the
results you got from these experiments (and the baseline you chose and
why), and your conclusions.

# What To Turn In

Please submit your prefetcher's code (and any Python configuration files
you changed) and your report in a .zip file as a Private Note on Ed
Discussion.

# Grading

Your grade will be based on a few principles:

-   `Implementation:` Your code successfully simulates your prefetcher,
    your design has novel elements, and your results noticeably differ
    from your baseline.

-   `Experiments:` You showed some relevant characteristics of your
    prefetcher using empirical results.

-   `Presentation:` Your experiments and analysis are concise and
    logically displayed.

[^1]: We updated these patches after releasing Assignment 1C to make
    implementing predictors easier. We also made the `mold` linker the
    default to speed up your compilations. See
    <https://edstem.org/us/courses/54047/discussion/4477223> for
    details.

[^2]: For some other scripts, such as `se_custom_binary.py` from
    Homework 1A, we instead only add one new knob, `–core_type`, which
    works similarly.

[^3]: See <https://edstem.org/us/courses/54047/discussion/4477223> for
    details.

[^4]: See <https://edstem.org/us/courses/54047/discussion/4440685> for
    details.
