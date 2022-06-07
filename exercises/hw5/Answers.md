# Part 1

## Instruction 1
> This will run the code with the profiling in its most basic mode, which is
sufficient. We want to compare kernel execution times. **What do you notice
about kernel execution times?** Probably, you won't see much difference between
the parallel reduction with atomics and the warp shuffle with atomics kernel.
**Can you theorize why this may be?** Our objective with these will be to
approach theoretical limits. The theoretical limit for a typical reduction would
be determined by the memory bandwidth of the GPU. To calculate the attained
memory bandwidth of this kernel, divide the total data size in bytes (use N from
the code in your calculation) by the execution time (which you can get from the
profiler). **How does this number compare to the memory bandwidth of the GPU you
are running on?** (You could run bandwidthTest sample code to get a
proxy/estimate).

## Comparison 1

- $N = 8*1024*1024$

- DATA SIZE $=8*1024*1024*4=32$ MB $=1/32$ GB

|    Kernel    |    Duration    | Attained Mem. Bandwidth<br>(Data size / Duration) | Speedup |
|:------------:|:--------------:|:-------------------------------------------------:|:-------:|
| `atomic_red` | 30.51 msecond  |                     1.02 GB/s                     | 0.003x  |
|  `reduce_a`  | 114.85 usecond |                    272.09 GB/s                    |   1x    |
| `reduce_ws`  | 111.71 usecond |                    279.74 GB/s                    | 1.028x  |
    
## Output `bandwidthTest`

|  Transfer Mode   | Bandwitdh |
|:----------------:|:---------:|
|  Host to Device  |    4.8    |
|  Device to Host  |    5.1    |
| Device to Device |   351.6   |

## Answer 1

a. `atomic_red` is much slower than the other two kernels (`reduce_a` and
`reduce_ws`) given that `atomic_red` only relies on the atomic operation to
accumulate all the values. This imposes a sincronization among all the kernel
threads, on top all threads writing to global memory, on top of writing to the
same address. Overall, this approach can only yield an upsetting performance.

b. `reduce_a` and `reduce_ws` are much faster given that most of the computation
is done using shared memory along with the a sweep-reduction access pattern. At
this point, I am not sure why their performance is very similar. The `reduce_ws`
kernel decrease the use of shared memory. I could only imagine that there are
other limiting factors to kernel performance.

> PS: After [looking up occupancy
> limiters](https://on-demand.gputechconf.com/gtc-express/2011/presentations/cuda_webinars_WarpsAndOccupancy.pdf)
> I found out that there are three limiting factors for Warp Occupancy:
> - Register
> - Shared Memory
> - Block Size
>
> Occupancy however for both kernels is already pretty high (~90%). Probably
the bottle neck is something other than *Achived Occupancy*.

c. I either messed up my calculation for *Attained Memory Bandwidth*, or the
computed metric is regarding *Device to Device* bandwidth.

> PS2: From the exercise walk-through we have that,
>
> The grid-stride loop is comon for both approachs, and it will occour that if
the data is way bigger than what the grid can handle, the grid-stride will take
most of the computation. Thus, making both kernels similar on their heaviest
load and dominating the gain from the warp suffle approach.

## Instruction 2

> Now edit the code to change *N* from ~8M to 163840 (=640*256)
>
> Recompile and re-run the code with profiling. **Is there a bigger percentage
difference between the execution time of the reduce_a and reduce_ws kernel? Why
might this be?**

## Comparison 2

- $N = 640*256 = 640 * 256$

- DATA SIZE $=640 * 256 * 4 = 64$ KB $=64/1024$ GB

|    Kernel    |    Duration    | Attained Mem. Bandwidth<br>(Data size / Duration) | Speedup |
|:------------:|:--------------:|:-------------------------------------------------:|:-------:|
| `atomic_red` | 600.64 usecond |                     1.01 GB/s                     | 0.026x  |
|  `reduce_a`  | 15.78 usecond  |                    38.67 GB/s                     |   1x    |
| `reduce_ws`  | 10.66 usecond  |                    57.25 GB/s                     |  1.48x  |

## Answer 2

a. There is a huge difference (1.48x) between `reduce_a` and `reduce_ws`.

b. I am not fully sure, but if my numbers are right, the gains of `reduce_ws` is
dominated/deminished by the Memory Bandwidth bottleneck.

## Instruction Bonus

> Bonus: edit the code to change *N* from ~8M to ~32M.  recompile and run.
**What happened? Why?**

## Output

```
atomic sum reduction incorrect!
```

## Answer Bonus

a. Incorrect output.

b. I have no idea! =(

# Part 2

Done quite quickly.

# Part 3

I had two implementations:
  - `row_sums_slow`. This was my first attempt. I got a correct output in the
  first try. However the Duration increased (30+ msecond). I was too tired to
  wonder why. Then, I just keep reading the `readme.md` where I noticed it
  included tips on how to get to a good solution, described next.
  - `row_sums`. My second attempt. Coding was quite fast. However I had the
  wrong output, so it took me sometime to debug it. The issues I had is that I
  didn't consider one of the tips (highlighted below) properly, at first.
    - One block per row -> Block-loop
    - **Change kernel launching parameters**