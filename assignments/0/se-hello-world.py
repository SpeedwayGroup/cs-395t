"""A simple gem5 config script which runs a simple CPU in syscall
emulation (SE) mode, and prints 'Hello World!'.

Usage
-----

```
scons build/X86/gem5.opt ./gem5-configs-395t/assignments/0/se-hello-world.py


Reference
---------
In the gem5 GitHub repo: gem5/configs/example/gem5_library/arm-hello.py
"""

import time

from gem5.components.boards.simple_board import SimpleBoard
from gem5.components.cachehierarchies.classic.no_cache import NoCache
from gem5.components.memory import SingleChannelDDR3_1600
from gem5.components.processors.cpu_types import CPUTypes
from gem5.components.processors.simple_processor import SimpleProcessor
from gem5.isas import ISA
from gem5.simulate.simulator import Simulator
from gem5.utils.requires import requires
from gem5.resources.resource import BinaryResource

# This check ensures the gem5 binary is compiled to the X86 ISA target. 
#
# If not, an exception will be thrown.
requires(
    isa_required = ISA.X86
)

# Use no cache hierarchy.
cache_hierarchy = NoCache()


# Use a simple, single-channel DDR3-1600 memory system.
memory = SingleChannelDDR3_1600(size="32MiB")

# Use a simple timing processor with one core.
processor = SimpleProcessor(
    cpu_type=CPUTypes.TIMING, 
    isa=ISA.X86, 
    num_cores=1
)


# Use a simple board which can run basic, SE-mode simulations.
board = SimpleBoard(
    clk_freq = "3GHz",
    processor = processor,
    cache_hierarchy = cache_hierarchy,
    memory = memory
)

# Set up the workload
binary = BinaryResource(
    "./tests/test-progs/hello/bin/x86/linux/hello"
)
board.set_se_binary_workload(
    binary
)

# Set up the simulator
simulator = Simulator(
    board = board
)

# Run the simulation!
start_time = time.time()
print("Beginning simulation!")

simulator.run()

total_time = time.time() - start_time
print(
    f"Exiting @ tick {simulator.get_current_tick()} "
    f"because {simulator.get_last_exit_event_cause()}."
)
print(
    f"Total wall clock time: {total_time:.2f} s "
    f"= {(total_time/60):.2f} min"
)
