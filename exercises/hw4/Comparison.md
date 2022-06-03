# Comparison and Annoucement Questions

|    Kernel     |   Duration   | GDDR Load Requests | GDDR Sectors Requests |
|:-------------:|:------------:|:------------------:|:---------------------:|
|  `row_sums`   | 11.7 msecond |     8,388,608      |      268,427,291      |
| `column_sums` | 3.02 msecond |     8,388,608      |      33,554,432       |

> - What does the output tell you? Can you locate the lines that identify the kernel durations? Are the kernel durations the same or different? Would you expect them to be the same or different?
>
> - What similarities or differences do you notice between the row_sum and column_sum kernels? Do the kernels (row_sum, column_sum) have the same or different efficiencies? Why? How does this correspond to the observed kernel execution times for the first profiling run?

The `column_sums` kernel is faster (3.02 vs 11.7 msecond). This is expected
given that each thread iterates over the rows. Hence, all together when the
threads of a warp loads the elements on a given iteration `i`, all the requested
address will hit the same sector in global memory, which gets stored in the
cache L1 and L2.