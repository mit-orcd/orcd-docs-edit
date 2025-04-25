# Engaging Public Partitions

#### mit_normal

| NODE_COUNT | OS     | CORES_PER_SOCKET | SOCKETS | MEMORY  | MODEL_NAME                       | NODELIST                    |
| ---------- | ------ | ---------------- | ------- | ------- | -------------------------------- | --------------------------- |
| 2          | rocky8 | 32               | 2       | 386000  | AMD EPYC 9384X 32-Core Processor | node2704-2705               |
| 19         | rocky8 | 48               | 2       | 386000  | AMD EPYC 9474F 48-Core Processor | node1600-1616;node1618-1619 |
| 6          | rocky8 | 96               | 2       | 1547000 | AMD EPYC 9654 96-Core Processor  | node1620-1625               |

#### mit_preemptable

| NODE_COUNT | OS     | CORES_PER_SOCKET | SOCKETS | MEMORY  | MODEL_NAME                       | NODELIST                                                                                          |
| ---------- | ------ | ---------------- | ------- | ------- | -------------------------------- | ------------------------------------------------------------------------------------------------- |
| 47         | rocky8 | 48               | 2       | 386000  | AMD EPYC 9474F 48-Core Processor | node1600-1616;node1618-1619;node1626-1631;node2503-2513;node2523-2525;node9800-9805;node9808-9809 |
| 2          | rocky8 | 48               | 2       | 773000  | AMD EPYC 9474F 48-Core Processor | node9806-9807                                                                                     |
| 2          | rocky8 | 48               | 2       | 1547000 | AMD EPYC 9474F 48-Core Processor | node9810-9811                                                                                     |
| 6          | rocky8 | 96               | 2       | 1547000 | AMD EPYC 9654 96-Core Processor  | node1620-1625                                                                                     |

#### sched_mit_hill (CPU nodes)

| NODE_COUNT | OS      | CORES_PER_SOCKET | SOCKETS | MEMORY | MODEL_NAME                            | NODELIST                                                                                    |
| ---------- | ------- | ---------------- | ------- | ------ | ------------------------------------- | ------------------------------------------------------------------------------------------- |
| 31         | centos7 | 10               | 2       | 63000  | IntelR XeonR CPU E5-2660 v3 @ 2.60GHz | node331-337;node360-361;node363-374;node379-381;node383-389                                 |
| 2          | centos7 | 14               | 2       | 64000  | IntelR XeonR CPU E5-2680 v4 @ 2.40GHz | node967-968                                                                                 |
| 15         | centos7 | 8                | 2       | 64000  | IntelR XeonR CPU E5-2650 0 @ 2.00GHz  | node113-114;node116-117;node122;node125-126;node131;node133;node135-137;node139;node143-144 |

#### sched_mit_hill (GPU nodes)

| NODE_COUNT | OS      | CORES_PER_SOCKET | SOCKETS | MEMORY | MODEL_NAME                           | GPU_COUNT | GPU_TYPE   | GPU_MEMORY | NODELIST                                                                                    |
| ---------- | ------- | ---------------- | ------- | ------ | ------------------------------------ | --------- | ---------- | ---------- | ------------------------------------------------------------------------------------------- |
| 14         | centos7 | 8                | 2       | 64000  | IntelR XeonR CPU E5-2650 0 @ 2.00GHz | 1         | Tesla K20m | 4743 MiB   | node073;node146;node149;node152;node154;node156;node158-160;node168-169;node172-173;node177 |


<!-- #### mit_normal_gpu

| NODE_COUNT | OS     | CORES_PER_SOCKET | SOCKETS | MEMORY  | MODEL_NAME                   | GPU_COUNT | GPU_TYPE              | GPU_MEMORY | NODELIST      |
| ---------- | ------ | ---------------- | ------- | ------- | ---------------------------- | --------- | --------------------- | ---------- | ------------- |
| 1          | rocky8 | 32               | 2       | 1031000 | INTELR XEONR PLATINUM 8562Y+ | 4         | NVIDIA L40S           | 46068 MiB  | node2804      |
| 1          | rocky8 | 32               | 2       | 1031000 | IntelR XeonR Platinum 8462Y+ | 4         | NVIDIA H100 80GB HBM3 | 81559 MiB  | node2906      |
| 2          | rocky8 | 60               | 2       | 2063000 | INTELR XEONR PLATINUM 8580   | 8         | NVIDIA H200           | 143771 MiB | node2433-2434 | -->

