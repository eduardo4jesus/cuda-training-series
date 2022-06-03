#include <stdio.h>

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


// In case of debugging
// const size_t DSIZE = 8;
// const int block_size = 4;  // CUDA maximum is 1024
const size_t DSIZE = 16384;      // matrix side dimension
const int block_size = 256;  // CUDA maximum is 1024
// matrix row-sum kernel
__global__ void row_sums(const float *A, float *sums, size_t ds) {

  /** 1. Each block will compute a row-sweep reduction sum */
  int idrow = blockIdx.x;
  
  /** 2. Allocating and reseting the shared memory values */
  __shared__ float sdata[block_size];
  size_t tid = threadIdx.x;
  sdata[tid] = 0;

  /** 3. Block loop to populate the shared memory with the row data */
  int idcol = tid;
  if (idrow < ds) {
    while (idcol < ds) {
      sdata[tid] += A[idrow*ds + idcol];
      idcol += blockDim.x;
    }
  }

  // printf("Processing row %d.\n", idrow);
  // if (idrow == 2 && tid == 0) {
  //   printf("sdata row %d:\n", idrow);
  //   for(int i=0; i<block_size; i++)
  //     printf("%.3f ", sdata[i]);
  //   printf("\n");
  // }

  /** 4. Now, let's compute the row (block) sum by doing a row-reduction sweep */
  // int s_width = min((size_t) blockDim.x, ds);
  for (unsigned int s = blockDim.x/ 2; s > 0; s >>= 1) {
    __syncthreads();
    if (tid < s) {
      sdata[tid] += sdata[tid + s];
    }
  }

  if (tid == 0 && idrow < ds) {
    sums[idrow] = sdata[0];
  }
}

__global__ void row_sums_slow(const float *A, float *sums, size_t ds) {

  /** 1. let's define a shared memory area */
  __shared__ float sdata[block_size];
  size_t tid = threadIdx.x;

  /** 2. Each thread will iterate over the rows, summing each one at a time */
  for (size_t idrow = 0; idrow < ds; idrow++) {
    __syncthreads();  
    sdata[tid] = 0;

    /** 3. Let's do a grid loop to populate the shared memory with the row data */
    int idcol = threadIdx.x + blockDim.x * blockIdx.x;
    while (idcol < ds) {
      sdata[tid] += A[idrow * ds + idcol];
      idcol += gridDim.x * blockDim.x;
    }

    /** 4. Now, let's compute the row partial sum for each block by doing a row-reduction sweep */
    for (int s = blockDim.x / 2; s > 0; s >>= 1) {
      __syncthreads();
      if (tid < s) {
        sdata[tid] += sdata[tid + s];
      }
    }

    if (tid == 0) {
      atomicAdd(&sums[idrow], sdata[0]);
    }
  }
}

__global__ void row_sums_original(const float *A, float *sums, size_t ds) {
  int idx = threadIdx.x+blockDim.x*blockIdx.x; // create typical 1D thread index from built-in variables
  if (idx < ds){
    float sum = 0.0f;
    for (size_t i = 0; i < ds; i++)
      sum += A[idx*ds+i];         // write a for loop that will cause the thread to iterate across a row, keeeping a running sum, and write the result to sums
    sums[idx] = sum;
  }
}

// matrix column-sum kernel
__global__ void column_sums(const float *A, float *sums, size_t ds){

  int idx = threadIdx.x+blockDim.x*blockIdx.x; // create typical 1D thread index from built-in variables
  if (idx < ds){
    float sum = 0.0f;
    for (size_t i = 0; i < ds; i++)
      sum += A[idx+ds*i];         // write a for loop that will cause the thread to iterate down a column, keeeping a running sum, and write the result to sums
    sums[idx] = sum;
}}
bool validate(float *data, size_t sz){
  for (size_t i = 0; i < sz; i++)
    if (data[i] != (float)sz) {printf("results mismatch at %lu, was: %f, should be: %f\n", i, data[i], (float)sz); return false;}
    return true;
}
int main(){

  float *h_A, *h_sums, *d_A, *d_sums;
  h_A = new float[DSIZE*DSIZE];  // allocate space for data in host memory
  h_sums = new float[DSIZE]();
  for (int i = 0; i < DSIZE*DSIZE; i++)  // initialize matrix in host memory
    h_A[i] = 1.0f;
  cudaMalloc(&d_A, DSIZE*DSIZE*sizeof(float));  // allocate device space for A
  cudaMalloc(&d_sums, DSIZE*sizeof(float));  // allocate device space for vector d_sums
  cudaCheckErrors("cudaMalloc failure"); // error checking
  // copy matrix A to device:
  cudaMemcpy(d_A, h_A, DSIZE*DSIZE*sizeof(float), cudaMemcpyHostToDevice);
  cudaCheckErrors("cudaMemcpy H2D failure");
  //cuda processing sequence step 1 is complete
  row_sums<<<DSIZE, block_size>>>(d_A, d_sums, DSIZE);
  // row_sums<<<(DSIZE+block_size-1)/block_size, block_size>>>(d_A, d_sums, DSIZE);
  cudaCheckErrors("kernel launch failure");
  //cuda processing sequence step 2 is complete
  // copy vector sums from device to host:
  cudaMemcpy(h_sums, d_sums, DSIZE*sizeof(float), cudaMemcpyDeviceToHost);
  //cuda processing sequence step 3 is complete
  cudaCheckErrors("kernel execution failure or cudaMemcpy H2D failure");
  if (!validate(h_sums, DSIZE)) return -1; 
  printf("row sums correct!\n");
  cudaMemset(d_sums, 0, DSIZE*sizeof(float));
  column_sums<<<(DSIZE+block_size-1)/block_size, block_size>>>(d_A, d_sums, DSIZE);
  cudaCheckErrors("kernel launch failure");
  //cuda processing sequence step 2 is complete
  // copy vector sums from device to host:
  cudaMemcpy(h_sums, d_sums, DSIZE*sizeof(float), cudaMemcpyDeviceToHost);
  //cuda processing sequence step 3 is complete
  cudaCheckErrors("kernel execution failure or cudaMemcpy H2D failure");
  if (!validate(h_sums, DSIZE)) return -1; 
  printf("column sums correct!\n");
  return 0;
}
  
