==PROF== Connected to process 22686 (/home/eduardoj/Repo/cuda-training-series/exercises/hw8/task3/task3)
==PROF== Profiling "smem_cuda_transpose" - 0: 0%....50%....100% - 6 passes
Matrix size is 4096
Total memory required per matrix is 134.217728 MB
Total time CPU is 0.234855 sec
Performance is 1.142984 GB/s
Total time GPU is 0.195883 sec
Performance is 1.370389 GB/s
PASS
==PROF== Disconnected from process 22686
[22686] task3@127.0.0.1
  smem_cuda_transpose(int, const double *, double *), 2022-Jun-08 22:38:26, Context 1, Stream 7
    Section: Command line profiler metrics
    ---------------------------------------------------------------------- --------------- ------------------------------
    l1tex__average_t_sectors_per_request_pipe_lsu_mem_global_op_ld.ratio    sector/request                              8
    l1tex__average_t_sectors_per_request_pipe_lsu_mem_global_op_st.ratio    sector/request                              8
    l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_ld.sum                                                            0
    l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_st.sum                                                      241,690
    l1tex__data_pipe_lsu_wavefronts_mem_shared_op_ld.sum                                                        1,048,576
    l1tex__data_pipe_lsu_wavefronts_mem_shared_op_st.sum                                                        1,290,266
    l1tex__t_requests_pipe_lsu_mem_global_op_ld.sum                                request                        524,288
    l1tex__t_requests_pipe_lsu_mem_global_op_st.sum                                request                        524,288
    l1tex__t_sectors_pipe_lsu_mem_global_op_ld.sum                                  sector                      4,194,304
    l1tex__t_sectors_pipe_lsu_mem_global_op_st.sum                                  sector                      4,194,304
    smsp__sass_average_data_bytes_per_sector_mem_global_op_ld.pct                        %                            100
    smsp__sass_average_data_bytes_per_sector_mem_global_op_st.pct                        %                            100
    smsp__sass_average_data_bytes_per_wavefront_mem_shared.pct                           %                            100
    ---------------------------------------------------------------------- --------------- ------------------------------

