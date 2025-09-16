#include <stdio.h>
#include <cuda_runtime.h>

// Error-checking macro
#define cudaCheckError(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line)
{
    if (code != cudaSuccess) {
        fprintf(stderr, "CUDA Error: %s %s %d\n",
                cudaGetErrorString(code), file, line);
        exit(code);
    }
}

__global__ void add(int a, int b, int *c) {
    *c = a + b;
}

int main(void) {
    int c = 0;
    int *dev_c;

    // Allocate memory on GPU
    cudaCheckError(cudaMalloc((void **)&dev_c, sizeof(int)));

    // Launch kernel
    add<<<1, 1>>>(2, 7, dev_c);

    // Check for kernel launch errors
    cudaCheckError(cudaGetLastError());
    cudaCheckError(cudaDeviceSynchronize());

    // Copy result back
    cudaCheckError(cudaMemcpy(&c, dev_c, sizeof(int), cudaMemcpyDeviceToHost));

    printf("2 + 7 = %d\n", c);

    cudaCheckError(cudaFree(dev_c));
    return 0;
}


