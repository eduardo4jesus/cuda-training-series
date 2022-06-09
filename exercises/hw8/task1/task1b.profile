==PROF== Connected to process 18028 (/home/eduardoj/Repo/cuda-training-series/exercises/hw8/task1/task1b)
==PROF== Profiling "naive_cuda_transpose" - 0: 0%....50%....100% - 5 passes
Matrix size is 4096
Total memory required per matrix is 134.217728 MB
Total time CPU is 0.250288 sec
Performance is 1.072506 GB/s
Total time GPU is 0.178345 sec
Performance is 1.505147 GB/s
PASS
==PROF== Disconnected from process 18028
[18028] task1b@127.0.0.1
  naive_cuda_transpose(int, const double *, double *), 2022-Jun-08 16:31:17, Context 1, Stream 7
    Section: Command line profiler metrics
    ---------------------------------------------------------------------- --------------- ------------------------------
    l1tex__average_t_sectors_per_request_pipe_lsu_mem_global_op_ld.ratio    sector/request                              8
    l1tex__average_t_sectors_per_request_pipe_lsu_mem_global_op_st.ratio    sector/request                             32
    l1tex__t_requests_pipe_lsu_mem_global_op_ld.sum                                request                        524,288
    l1tex__t_requests_pipe_lsu_mem_global_op_st.sum                                request                        524,288
    l1tex__t_sectors_pipe_lsu_mem_global_op_ld.sum                                  sector                      4,194,304
    l1tex__t_sectors_pipe_lsu_mem_global_op_st.sum                                  sector                     16,777,216
    smsp__sass_average_data_bytes_per_sector_mem_global_op_ld.pct                        %                            100
    smsp__sass_average_data_bytes_per_sector_mem_global_op_st.pct                        %                             25
    ---------------------------------------------------------------------- --------------- ------------------------------

