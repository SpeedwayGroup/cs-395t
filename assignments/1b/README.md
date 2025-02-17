# Assignment 1b: ChampSim Experimentation
**Due TBD at 11:59pm CST**

In this assignment you will implement either a **branch predictor** or **cache
replacement policy** for **ChampSim**, and evaluate its accuracy
and performance impact. This assignment does not require you to write a
lot of code, but it does require you to understand concepts in
branch prediction/cache replacment, simulation, and evaluation.

> [!NOTE]
> In Programming Assignment 1c, you'll do the same thing in Gem5.
> You won't be required to implement the same predictor for both
> Assignments 1b and 1c, however it may be more interesting to do so.

> [!NOTE]
> Please note that Gem5 already includes implementations of most of the cache 
> replacement policies we've discussed in class. You can see which in 
> `gem5/src/mem/cache/replacement_policies/`. If you want to compare the same 
> design across simulators, you should choose a branch predictor or replacement
> policy which gem5 hasn't already implemented.

# Your Assignment

This assignment has three parts:
1.  You will implement a new branch predictor or cache replacement
    policy in ChampSim. This can be an implementation of a predictor
    we've discussed in class (e.g., the agree predictor, BIP, etc.), an
    extension of a predictor we've discussed in class, or an entirely
    new idea. Note that if you implement an existing predictor, it
    cannot be one of the predictors that are already implemented in
    ChampSim.
2.  You will run experiments with your predictor to explore different
    design choices such as varying hardware budget or changing
    saturating counter sizes.
3.  You will write a report that describes what you've done, includes
    your results, and draws relevant conclusions from your experiments.

# Details
## Simulator
ChampSim lets you track many useful statistics about the underlying
hardware's performance. For this assignment, you should particularly
consider these:

-   If you design a cache replacement policy, you should measure the
    replacement policy's MPKI (misses per kilo-instructions).
-   If you design a branch predictor, you should measure the predictor's
    MPKI (branch mispredictions per kilo-instructions).
-   For both, you should measure the average IPC over each program.

The previous assignment taught you how to compile and run ChampSim
simulations, but for this assignment we're providing some scripts to
simplify the process. Namely:

```shell
./build.sh <branch_predictor> <cache_replacement_policy>
./run.sh <branch_predictor> <cache_replacement_policy>
./run_cluster.sh <branch_predictor> <cache_replacement_policy>
```

These scripts do the following:
-   `build.sh` builds a ChampSim binary with the desired branch
    predictor and replacement policy.
-   `run.sh` runs your ChampSim binary on on one trace (`astar_313B`)
    and saves the output to the following path:
    `./out/<bpred>__<cacherp>__test/astar_313B.{json,txt}`.
-   `run_cluster.sh` runs your ChampSim binary on eight traces we've
    provided for you on UTCS's HTCondor cluster. See below for details.

They're all located in
` /scratch/cluster/speedway/cs395t/hw1b/champsim/scripts`. You can copy
them directly into your ChampSim folder. All three scripts take the name
of a branch predictor and cache replacement policy as defined by the
directory name in which the predictor's code is located. In particular,
you should use the following parameters:

-   If you design a cache replacement policy, use the default branch
    predictor, `bimodal`.
-   If you design a branch predictor, use the default cache replacement
    policy, `lru`.

We recommend you use `run.sh` first to debug your predictor's code and
ensure there's no errors. Once you're confident that your predictor is
working as intended, you can use `run_cluster.sh` to evaluate it on
eight traces from the SPEC CPU2006 and GAP benchmark suites. This will
submit jobs onto the HTCondor cluster for each of the 8 traces that we
have provided. Note that you can only submit jobs on cluster machines
using the submit notes `darmok.cs.utexas.edu` and `jalad.cs.utexas.edu`.
Please note that **the darmok and jalad nodes are specifically are for**
**job submission only!** Please don't build or run any computationally
intensive task on these machines!

Once you have submitted your jobs to the cluster, you can check their
status by running `condor_q` on the submit node you used. To break down
your batch by job, you can use `condor_q -nobatch`. To remove jobs, you
can use `condor_rm <JOBID>` to remove a specific job or all your jobs by
using `condor_rm <YOUR UTCS ID>`. For `run_cluster.sh`, the ChampSim
output files and Condor logs will be located in
`./out/<bpred>__<cacherp>`.

If you built ChampSim in either your home directory or in the
`/projects/coursework/...` directory for Assignment 1A, you should be
good to go. Otherwise, you should move ChampSim to one of these
directories (preferably your home directory), as other directories may
not be accessible from the darmok and jalad submit nodes.

Also, don't worry about the configuration script this time, because
`build.sh` handles it for you. It's up to you whether you want to
use the default build config or the Skylake-like one you created in
Assignment 1a.

> [!NOTE]
> `build.sh` will place your configured cache replacement
> policy in the LLC only, and use LRU elsewhere. You're welcome to
> change this if you wish. For example, you may see benefits from placing your
> policy in the L2 instead.

### Branch Predictor

Branch predictors are implemented inside of the `./branch` subdirectory
of ChampSim. In order to create a new branch predictor, you have to
create a new subdirectory inside of `./branch` named after your branch
predictor and then create a `.cc` file with the same name. For example,
for an agree predictor, you would edit the file
`./branch/agree/agree.cc`.

There are three methods that you have to implement for a branch
predictor:

```c++
/*
 * ChampSim calls this method once to initialize the state of your
 * branch predictor at the beginning of simulation. You'll want
 * to have all of your set up code here for anything you need for
 * your branch predictor such as tables, counters, etc.
 */
void O3_CPU::initialize_branch_predictor();

/*
 * This method is called whenever a branch instruction is encountered.
 * The only parameter is the IP address of the branch instruction.
 * You will implement the prediction part of
 * your predictor here.
 */
uint8_t O3_CPU::predict_branch(uint64_t ip, uint64_t predicted_target, \
    uint8_t always_taken, uint8_t branch_type);
    
/*
 * This method is called whenever the true result of the branch has been
 * resolved. Parameters include:
 * - IP address of the resolved branch instruction.
 * - The resolved branch's true target address.
 * - The resolved branch's true direction.
 * - The type of branch this instruction is (more information as to what
 *   the values correspond to can be found in ./inc/instruction.h).
 */
void O3_CPU::last_branch_result(uint64_t ip, uint64_t branch_target, \
    uint8_t taken, uint8_t branch_type);
```

You can also define your own custom functions and values (i.e. tables,
constants, integers, etc. by placing them inside a namespace block. For
example, the bimodal predictor (`branch/bimodal/bimodal.cc`) has this in
its namespace:

```c++
namespace 
{
constexpr std::size_t BIMODAL_TABLE_SIZE = 16384;
constexpr std::size_t BIMODAL_PRIME = 16381;
constexpr std::size_t COUNTER_BITS = 2;

std::map<
    O3_CPU*,
    std::array<champsim::msl::fwcounter<COUNTER_BITS>, BIMODAL_TABLE_SIZE>>
    bimodal_table;
} // namespace
```

> [!NOTE]
> The bimodal table here is a big scary template, but don't worry!
> It's just a map of arrays. Your CPU is the key and the value is an
> array of `BIMODAL_TABLE_SIZE` fixed-width counters, each of which is
> `COUNTER_BITS` bits wide. Why use a map indexed by CPU? In a
> multicore system, each core has its own branch predictor, and this
> is a global variable. So, we need to make sure each core's branch
> predictor metadata is distinct. You are strongly encouraged to
> consider how your predictor's code works with multiple cores or
> caches and implement it accordingly.


### Cache Replacement Policy

Cache replacement policies are implemented inside of the `./replacement`
subdirectory of ChampSim. In order to create a new cache replacement
policy, you have to create a new subdirectory inside of `./replacement`
named after your cache replacement policy and then create a `.cc` file
with the same name. For example, for BIP, you would edit the file
`./branch/bip/bip.cc`.

There are four methods that you have to implement for a cache
replacement policy. Also, just like branch predictors, you also have a
namespace section you should use to define global constants and
variables for your specific predictor.

```c++
/* ChampSim calls this method once to initialize the state of your
 * cache replacement policy at the beginning of simulation. You
 * will want to have all of your set up code here for anything you
 * need for your cache replacement policy such as tables, counters, etc.
 */
void CACHE::initialize_replacement();

/* This method is called whenever a cache line is coming into the
 * current cache level and either an eviction or a cache bypass needs
 * to occur.
 * You are given the following parameters:
 * - The CPU number that issued the associated memory instruction
 * - The unique instruction ID (each dynamic instruction is given a
 *   unique instruction ID when read from the trace)
 * - Which set the incoming line goes to
 * - A pointer to that set in the cache (more information on the BLOCK
 *   class can be found at inc/cache.h)
 * - The IP address of the associated memory instruction
 * - The full address of the incoming cache line
 * - The type of memory access of the incoming cache line (more
 *   information can be found at inc/channel.h)
 * This method expects a return value of the expected way for eviction.
 * If you do not want to evict a way and would rather bypass instead,
 * return NUM_WAY.
*/ 
uint32_t CACHE::find_victim(uint32_t triggering_cpu, uint64_t instr_id, \
uint32_t set, const BLOCK* current_set, uint64_t ip, \
uint64_t full_addr, uint32_t type);

/* This method is called on accesses. The parameters are the same as
 * find_victim except we now have:
 * - The way in which the access occurred
 * - The victim address (if anything was evicted)
 * - Whether this access hit in the cache
 * This method usually involves aging and promotion.
 */
void CACHE::update_replacement_state(uint32_t triggering_cpu, uint32_t set, \
uint32_t way, uint64_t full_addr, uint64_t ip,
uint64_t victim_addr, uint32_t type, uint8_t hit);

/* This method is called at the end of simulation to allow for
 * cache replacement policies to print out any statistics or metrics
 * that they kept track of on their own. Feel free to keep track of
 * whatever information you want such as table utilization and so
 * forth and output it here.
 */
void CACHE::replacement_final_stats();
```

### Further Reading

The latest version of ChampSim has a [small wiki](https://champsim.github.io/ChampSim/master/index.html) that covers the
interfaces for different kinds of predictors and more.

## Benchmarks

We have provided a set of 6 SPEC CPU2006 benchmarks and 2 GAP benchmarks
for this assignment. For each benchmark, we have provided a trace of 1
billion instructions from a representative region of the program (large
programs typically run for billions of instructions, which is too slow
to simulate on a microarchitectural simulator). For this assignment, you
are required to execute each trace for 100 million instructions after a
25 million instruction warm-up period. The provided run scripts will
specify that correctly.

### Further reading

-   This document describes the SPEC CPU2006 benchmarks:
    https://dl.acm.org/doi/pdf/10.1145/1186736.1186737

-   This document describes the GAP benchmarks:
    https://arxiv.org/pdf/1508.03619.pdf

## Report

You should write a report that describes your experiments, the results
you got from these experiments (relative to LRU for cache replacement or
the bimodal predictor for branch replacement) and your conclusions from
the results. If you've experimented with design points or against
baselines that were not described in the assignment, please include a
description of those with an explanation for why you chose to do those
experiments.

# What To Turn In

Upload a `.zip` file containing your predictors' code and your report to
Cnavas under "Assignemnt 1b", and leave a comment with the names of everyone 
in your group.

# Grading

Your grade will be based on three factors:
-   **Implementation**: Your code successfully simulates your predictor
    and your results noticeably differ from your baseline.
-   **Experiments**: You showed some relevant characteristic of your
    predictor using empirical results.
-   **Presentation**: Your experiments and analysis are concise and
    logically displayed.