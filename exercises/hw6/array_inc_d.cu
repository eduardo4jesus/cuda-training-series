#include <cstdio>
#include <cstdlib>
// error checking macro
#define cudaCheckErrors(msg) \
    do { \
        cudaError_t __err = cudaGetLastError(); \
        if (__err != cudaSuccess) { \
            fprintf(stderr, "Fatal error: %s (%s at %s:%d)\n", \
                msg, cudaGetErrorString(__err), \
                __FILE__, __LINE__); \
            fprintf(stderr, "*** FAILED - ABORTING\n"); \
            exit(1); \
        } \
    } while (0)

template <typename T>
void alloc_bytes(T &ptr, size_t num_bytes){

  cudaMallocManaged(&ptr, num_bytes);
}

__global__ void inc(int *array, size_t n){
  size_t idx = threadIdx.x+blockDim.x*blockIdx.x;
  while (idx < n){
    array[idx]++;
    idx += blockDim.x*gridDim.x; // grid-stride loop
    }
}

const size_t  ds = 32ULL*1024ULL*1024ULL;

int main(){

  int *h_array;
  size_t ds_bytes = ds*sizeof(h_array[0]);
  alloc_bytes(h_array, ds_bytes);
  cudaCheckErrors("cudaMalloc Error");
  memset(h_array, 0, ds_bytes);
  cudaMemPrefetchAsync(h_array, ds_bytes, 0); // Copy to device
  for (int i=0; i < 10000; i++) inc<<<256, 256>>>(h_array, ds);
  cudaCheckErrors("kernel launch error");
  cudaMemPrefetchAsync(h_array, ds_bytes, cudaCpuDeviceId); // Copy back to host
  cudaDeviceSynchronize();
  for (int i = 0; i < ds; i++) 
    if (h_array[i] != 1) {printf("mismatch at %d, was: %d, expected: %d\n", i, h_array[i], 1); return -1;}
  printf("success!\n"); 
  return 0;
}
