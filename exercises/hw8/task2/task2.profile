==PROF== Connected to process 19936 (/home/eduardoj/Repo/cuda-training-series/exercises/hw8/task2/task2)
==PROF== Profiling "smem_cuda_transpose" - 0: 0%....50%....100% - 6 passes
Matrix size is 4096
Total memory required per matrix is 134.217728 MB
Total time CPU is 0.249703 sec
Performance is 1.075020 GB/s
Total time GPU is 0.189652 sec
Performance is 1.415411 GB/s
PASS
==PROF== Disconnected from process 19936
[19936] task2@127.0.0.1
  smem_cuda_transpose(int, const double *, double *), 2022-Jun-08 17:30:31, Context 1, Stream 7
    Section: Command line profiler metrics
    ---------------------------------------------------------------------- --------------- ------------------------------
    l1tex__average_t_sectors_per_request_pipe_lsu_mem_global_op_ld.ratio    sector/request                              8
    l1tex__average_t_sectors_per_request_pipe_lsu_mem_global_op_st.ratio    sector/request                              8
    l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_ld.sum                                                           88
    l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_st.sum                                                   16,012,462
    l1tex__data_pipe_lsu_wavefronts_mem_shared_op_ld.sum                                                        1,048,664
    l1tex__data_pipe_lsu_wavefronts_mem_shared_op_st.sum                                                       17,061,038
    l1tex__t_requests_pipe_lsu_mem_global_op_ld.sum                                request                        524,288
    l1tex__t_requests_pipe_lsu_mem_global_op_st.sum                                request                        524,288
    l1tex__t_sectors_pipe_lsu_mem_global_op_ld.sum                                  sector                      4,194,304
    l1tex__t_sectors_pipe_lsu_mem_global_op_st.sum                                  sector                      4,194,304
    smsp__sass_average_data_bytes_per_sector_mem_global_op_ld.pct                        %                            100
    smsp__sass_average_data_bytes_per_sector_mem_global_op_st.pct                        %                            100
    smsp__sass_average_data_bytes_per_wavefront_mem_shared.pct                           %                          11.76
    ---------------------------------------------------------------------- --------------- ------------------------------

