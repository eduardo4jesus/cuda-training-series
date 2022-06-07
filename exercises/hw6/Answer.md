

|    kernel     | HtoD Ops | DtoH Ops | cudaMemPrefetchAsync |       inc        |
|:-------------:|:--------:|:--------:|:--------------------:|:----------------:|
| `array_inc_a` |    1     |    1     |                      |    883,936 ns    |
| `array_inc_b` |  4,694   |   768    |                      |  62,307,425 ns   |
| `array_inc_c` |    64    |    64    |    17,519,190 ns     |    892,384 ns    |
| `array_inc_d` |    64    |    64    |    30,625,834 ns     | 8,694,795,789 ns |

