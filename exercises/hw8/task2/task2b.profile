==PROF== Connected to process 19957 (/home/eduardoj/Repo/cuda-training-series/exercises/hw8/task2/task2b)
==PROF== Profiling "smem_cuda_transpose" - 0: 0%....50%....100% - 6 passes
Matrix size is 4096
Total memory required per matrix is 134.217728 MB
Total time CPU is 0.264663 sec
Performance is 1.014252 GB/s
Total time GPU is 0.204860 sec
Performance is 1.310339 GB/s
PASS
==PROF== Disconnected from process 19957
[19957] task2b@127.0.0.1
  smem_cuda_transpose(int, const double *, double *), 2022-Jun-08 17:30:39, Context 1, Stream 7
    Section: Command line profiler metrics
    ---------------------------------------------------------------------- --------------- ------------------------------
    l1tex__average_t_sectors_per_request_pipe_lsu_mem_global_op_ld.ratio    sector/request                              8
    l1tex__average_t_sectors_per_request_pipe_lsu_mem_global_op_st.ratio    sector/request                              8
    l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_ld.sum                                                   15,830,121
    l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_st.sum                                                      272,746
    l1tex__data_pipe_lsu_wavefronts_mem_shared_op_ld.sum                                                       16,878,697
    l1tex__data_pipe_lsu_wavefronts_mem_shared_op_st.sum                                                        1,321,322
    l1tex__t_requests_pipe_lsu_mem_global_op_ld.sum                                request                        524,288
    l1tex__t_requests_pipe_lsu_mem_global_op_st.sum                                request                        524,288
    l1tex__t_sectors_pipe_lsu_mem_global_op_ld.sum                                  sector                      4,194,304
    l1tex__t_sectors_pipe_lsu_mem_global_op_st.sum                                  sector                      4,194,304
    smsp__sass_average_data_bytes_per_sector_mem_global_op_ld.pct                        %                            100
    smsp__sass_average_data_bytes_per_sector_mem_global_op_st.pct                        %                            100
    smsp__sass_average_data_bytes_per_wavefront_mem_shared.pct                           %                          11.76
    ---------------------------------------------------------------------- --------------- ------------------------------

