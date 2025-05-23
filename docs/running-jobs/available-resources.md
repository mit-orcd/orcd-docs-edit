# Engaging Public Partitions

#### mit_normal

| Nodes | Cores | Memory | CPU model                       | Misc. features | Node list                    |
| ---------- | ----- | ------ | -------------------------------- | ------------- | --------------------------- |
| 6          | 2x96  | 1510GB | AMD EPYC 9654 96-Core Processor  |               | node1620-1625               |
| 2          | 2x32  | 376GB  | AMD EPYC 9384X 32-Core Processor | high_l3       | node2704-2705               |
| 19         | 2x48  | 376GB  | AMD EPYC 9474F 48-Core Processor |               | node1600-1616;node1618-1619 |

#### mit_preemptable (CPU)

| Nodes | Cores | Memory | CPU model                       | Misc. features | Node list                                                                                          |
| ---------- | ----- | ------ | -------------------------------- | ------------- | ------------------------------------------------------------------------------------------------- |
| 2          | 2x48  | 1510GB | AMD EPYC 9474F 48-Core Processor |               | node9810-9811                                                                                     |
| 6          | 2x96  | 1510GB | AMD EPYC 9654 96-Core Processor  |               | node1620-1625                                                                                     |
| 47         | 2x48  | 376GB  | AMD EPYC 9474F 48-Core Processor |               | node1600-1616;node1618-1619;node1626-1631;node2503-2513;node2523-2525;node9800-9805;node9808-9809 |
| 2          | 2x48  | 754GB  | AMD EPYC 9474F 48-Core Processor |               | node9806-9807                                                                                     |

#### mit_normal_gpu

| NODE_COUNT | OS     | CORES_PER_SOCKET | SOCKETS | MEMORY  | MODEL_NAME                   | GPU_COUNT | GPU_TYPE              | GPU_MEMORY |
| ---------- | ------ | ---------------- | ------- | ------- | ---------------------------- | --------- | --------------------- | ---------- |
| 49          | rocky8 | 32               | 2       | 1031000 | INTELR XEONR PLATINUM 8562Y+ | 4         | NVIDIA L40S           | 46068 MiB  |
| 8          | rocky8 | 60               | 2       | 2063000 | INTELR XEONR PLATINUM 8580   | 8         | NVIDIA H200           | 143771 MiB |
| 1          | rocky8 | 32               | 2       | 1031000 | IntelR XeonR Platinum 8462Y+ | 4         | NVIDIA H100 80GB HBM3 | 81559 MiB  |

#### mit_preemptable (GPU)

| Nodes | Cores | Memory | CPU model                             | GPUs | GPU type              | GPU memory | Misc. features | Node list                                                    |
| ---------- | ----- | ------ | -------------------------------------- | --------- | --------------------- | ---------- | ------------- | ----------------------------------------------------------- |
| 3          | 2x32  | 1006GB | INTELR XEONR PLATINUM 8562Y+           | 4         | NVIDIA L40S           | 44GB       |               | node2643-2644;node2804                                      |
| 4          | 2x32  | 1006GB | IntelR XeonR Platinum 8462Y+           | 4         | NVIDIA H100 80GB HBM3 | 79GB       |               | node2640-2642;node2906                                      |
| 8          | 2x32  | 2014GB | IntelR XeonR Platinum 8462Y+           | 4         | NVIDIA H100 80GB HBM3 | 79GB       |               | node1702-1703;node1802-1803;node2702-2703;node2802-2803     |
| 2          | 2x60  | 2014GB | INTELR XEONR PLATINUM 8580             | 8         | NVIDIA H200           | 140GB      |               | node2433-2434                                               |
| 4          | 2x20  | 502GB  | IntelR XeonR Silver 4316 CPU @ 2.30GHz | 4         | NVIDIA A100 80GB PCIe | 80GB       |               | node2414-2417                                               |
| 14         | 2x64  | 502GB  | AMD EPYC 7763 64-Core Processor        | 4         | NVIDIA A100-SXM4-80GB | 80GB       |               | node1917-1918;node2100-2104;node2119;node2300-2304;node2319 |

#### mit_quicktest

| Nodes | Cores | Memory | CPU model                       | Misc. features | Node list                    |
| ---------- | ----- | ------ | -------------------------------- | ------------- | --------------------------- |
| 6          | 2x96  | 1510GB | AMD EPYC 9654 96-Core Processor  |               | node1620-1625               |
| 19         | 2x48  | 376GB  | AMD EPYC 9474F 48-Core Processor |               | node1600-1616;node1618-1619 |




