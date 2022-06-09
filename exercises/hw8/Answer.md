
# Metrics

Here's a breakdown of the metrics we are requesting from the profiler:

 - *l1tex__average_t_sectors_per_request_pipe_lsu_mem_global_op_ld.ratio*: The number of global load transactions per request
 - *l1tex__average_t_sectors_per_request_pipe_lsu_mem_global_op_st.ratio*: The number of global store transactions per request
 - *l1tex__t_requests_pipe_lsu_mem_global_op_ld.sum*: The number of global load requests
 - *l1tex__t_requests_pipe_lsu_mem_global_op_st.sum*: The number of global store requests
 - *l1tex__t_sectors_pipe_lsu_mem_global_op_ld.sum*: The number of global load transactions
 - *l1tex__t_sectors_pipe_lsu_mem_global_op_st.sum*: The number of global store transactions
 - *smsp__sass_average_data_bytes_per_sector_mem_global_op_ld.pct*: The global load efficiency
 - *smsp__sass_average_data_bytes_per_sector_mem_global_op_st.pct*: The global store efficiency

# Task 1

> Using these metrics, we can easily observe various characteristics of our
kernel. Many of these metrics are self-explanatory, but it may not be
immediately obvious how global load and store *efficiency* is calculated. We can
also calculate our global load and store efficiences by dividing the theoretical
minimum number of transactions per request by the actual number of transactions
per request we calculated from the above metrics.
>
> How do we know what the theoretical minimum number of transactions per request
actually is? A cache line is 128 bytes, and there are 32 threads in a warp. If
the 32 threads are accessing consecutive 4 byte words (i.e. single precision
floats), then there should be 4 transactions in that request (we are just asking
for four consecutive 32-byte sectors of DRAM). In our case, we are using double
precision floats, so the 32 threads would be accessing consecutive 8 byte words
(256 bytes total). Therefore, the theoretical minimum number of transactions per
request in our case would be 8 (eight consecutive 32-byte sectors of DRAM).

|         Kernel         |   `task1`    |   `task1b`    |
|:----------------------:|:------------:|:-------------:|
| Load (sector/request)  |      32      |       8       |
| Store (sector/request) |      8       |      32       |
|    Load (requests)     |   524,288    |    524,288    |
|    Store (requests)    |   524,288    |    524,288    |
|     Load (sectors)     |  16,777,216  |   4,194,304   |
|    Store (sectors)     |  4,194,304   |  16,777,216   |
|  Load (efficiency %)   |      25      |      100      |
|  Store (efficiency %)  |     100      |      25       |
|      Performance       | 311.450 GB/s | 172.1304 GB/s |
|        GPU Time        |   0.862 ms   |   1.559 ms    |

Notice that:

- Matrix size is $4096 \times 4096 = 2^{24}$, which requires $2^{19}=524,288$
warps ($2^5$ threads each). This is the same number of requests, hence we have 1
request load and store per warp.
- A sector is a 32 byte-chunk of memory in a cache line.
- A cache line is four sectors, i.e. 128 bytes.
- Store request is coalesced per warp; Load is not.
  - Coalesced Store: $32 \times 8$ bytes $= 8$ sectors $= 2$ cache-lines $=256$
  consecutive bytes.
  - Non-coaledced Load: $32$ threads $\therefore 32$ sectors $\therefore 32$
  cache-lines, up to $4096$ bytes moved to cache.
- Swapping the access patter from

  ```c[INDX(myRow, myCol, m)] = a[INDX(myCol, myRow, m)];```

  to

  ```c[INDX(myCol, myRow, m)] = a[INDX(myRow, myCol, m)];```

  could also swap the coalesce effect from Load to Store, as it can be seen in
  `task1b`
- Non-Coalesced store operation yields to worse effects to time and performance
than non-coalesced load operations.



# Task 2

- *l1tex__average_t_sectors_per_request_pipe_lsu_mem_global_op_ld.ratio*: The number of global load transactions per request
- *l1tex__average_t_sectors_per_request_pipe_lsu_mem_global_op_st.ratio*: The number of global store transactions per request
- *l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_ld.sum*: The number of shared load bank conflicts
- *l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_st.sum*: The number of shared store bank conflicts
- *l1tex__data_pipe_lsu_wavefronts_mem_shared_op_ld.sum*: The number of shared load transactions
- *l1tex__data_pipe_lsu_wavefronts_mem_shared_op_st.sum*: The number of shared store transactions
- *l1tex__t_requests_pipe_lsu_mem_global_op_ld.sum*: The number of global load requests
- *l1tex__t_requests_pipe_lsu_mem_global_op_st.sum*: The number of global store requests
- *l1tex__t_sectors_pipe_lsu_mem_global_op_ld.sum*: The number of global load transactions
- *l1tex__t_sectors_pipe_lsu_mem_global_op_st.sum*: The number of global store transactions
- *smsp__sass_average_data_bytes_per_sector_mem_global_op_ld.pct*: The global load efficiency
- *smsp__sass_average_data_bytes_per_sector_mem_global_op_st.pct*: The global store efficiency
- *smsp__sass_average_data_bytes_per_wavefront_mem_shared.pct*: Shared Memory efficiency

|            Kernel            |   `task1`    |   `task1b`    |     `task2`     |    `task2b`     |
|:----------------------------:|:------------:|:-------------:|:---------------:|:---------------:|
|    Load (sector/request)     |      32      |       8       |        8        |        8        |
|    Store (sector/request)    |      8       |      32       |        8        |        8        |
|  Shared Load Bank Conflicts  |              |               |       88        |   15,830,121    |
| Shared Store Bank Conflicts  |              |               |   16,012,462    |     272,746     |
|   Shared Load Transactions   |              |               |    1,048,664    |   16,878,697    |
|  Shared Store Transactions   |              |               |   17,061,038    |    1,321,322    |
|       Load (requests)        |   524,288    |    524,288    |     524,288     |     524,288     |
|       Store (requests)       |   524,288    |    524,288    |     524,288     |     524,288     |
|        Load (sectors)        |  16,777,216  |   4,194,304   |    4,194,304    |    4,194,304    |
|       Store (sectors)        |  4,194,304   |  16,777,216   |    4,194,304    |    4,194,304    |
|     Load (efficiency %)      |      25      |      100      |       100       |       100       |
|     Store (efficiency %)     |     100      |      25       |       100       |       100       |
| Shared Memory (efficiency %) |              |               |      11.76      |      11.76      |
|         Performance          | 311.450 GB/s | 172.1304 GB/s | 342.896010 GB/s | 315.005942 GB/s |
|           GPU Time           |   0.862 ms   |   1.559 ms    |    0.783 ms     |    0.852 ms     |


**Notes**
- I am not sure why Shared Load/Store Transactions are larger than the number of
elements.

**Recall**

- Matrix size: $4096 \times 4096 = 2^{12} \times 2^{12} = 16,777,216$
- Block size: $32 \times 32 = 2^{5} \times 2^{5} = 1024$
- Grid size: $128 \times 128 = 2^{7} \times 2^{7} = 16,384$

**`task2`**
```
[...]
smemArray[threadIdx.x][threadIdx.y] = \
    a[INDX(tileX+threadIdx.x, tileY+threadIdx.y, m)]; // Transposing on loading
[...]
c[INDX(tileY+threadIdx.x, tileX+threadIdx.y, m)] = \
    smemArray[threadIdx.y][threadIdx.x];
[...]
```

**`task2b`**
```
[...]
smemArray[threadIdx.y][threadIdx.x] = \
    a[INDX(tileX+threadIdx.x, tileY+threadIdx.y, m)];
[...]
c[INDX(tileY+threadIdx.x, tileX+threadIdx.y, m)] = \
    smemArray[threadIdx.x][threadIdx.y]; // Transposing on assignment
[...]
```

# Task 3

|            Kernel            |   `task1`    |   `task1b`   |   `task2`    |   `task2b`   |   `task3`    |
|:----------------------------:|:------------:|:------------:|:------------:|:------------:|:------------:|
|    Load (sector/request)     |      32      |      8       |      8       |      8       |      8       |
|    Store (sector/request)    |      8       |      32      |      8       |      8       |      8       |
|  Shared Load Bank Conflicts  |              |              |      88      |  15,830,121  |      0       |
| Shared Store Bank Conflicts  |              |              |  16,012,462  |   272,746    |   241,690    |
|   Shared Load Transactions   |              |              |  1,048,664   |  16,878,697  |  1,048,576   |
|  Shared Store Transactions   |              |              |  17,061,038  |  1,321,322   |  1,290,266   |
|       Load (requests)        |   524,288    |   524,288    |   524,288    |   524,288    |   524,288    |
|       Store (requests)       |   524,288    |   524,288    |   524,288    |   524,288    |   524,288    |
|        Load (sectors)        |  16,777,216  |  4,194,304   |  4,194,304   |  4,194,304   |  4,194,304   |
|       Store (sectors)        |  4,194,304   |  16,777,216  |  4,194,304   |  4,194,304   |  4,194,304   |
|     Load (efficiency %)      |      25      |     100      |     100      |     100      |     100      |
|     Store (efficiency %)     |     100      |      25      |     100      |     100      |     100      |
| Shared Memory (efficiency %) |              |              |    11.76     |    11.76     |     100      |
|         Performance          | 311.450 GB/s | 172.130 GB/s | 342.896 GB/s | 315.005 GB/s | 342.531 GB/s |
|           GPU Time           |   0.862 ms   |   1.559 ms   |   0.783 ms   |   0.852 ms   |   0.784 ms   |