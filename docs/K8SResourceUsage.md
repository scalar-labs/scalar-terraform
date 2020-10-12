# Scalar-k8s Resource Usage

This document shows the resource usage and the monthly prices for the resources used by scalar-k8s.

## Azure

### Chiku
 
#### vCPU
 
| scalar-terraform (chiku) | Network | Cassandra | Node pool - Scalar Apps | Node pool - Other Apps | Monitor | Cassy | Reaper | Total |
|:-------------------------|:--------|:----------|:------------------------|:-----------------------|:--------|:------|:-------|:------|
| D2s v3 | 2 | 0 | 6 (2 vCPU per node) | 6 (2 vCPU per node) | 0 | 0 | 0 | 14 |
| E4s v3| 0 | 12 (4 vCPU per node) | 0 | 0 | 0 | 0| 0 | 12 |
| B2s | 0 | 0 | 0 | 0 | 2 | 2 | 2 | 6 |
| Total | 2 | 12 | 6 | 6 | 2 | 2 | 2 | 32 
 
#### Disk Usage

| scalar-terraform (chiku) | Network | Cassandra | Node pool - Scalar Apps | Node pool - Other Apps | Monitor | Cassy | Reaper | Total |
|:-------------------------|:--------|:----------|:------------------------|:-----------------------|:--------|:------|:-------|:------|
| OS Disk (Premium SSD) | 64 GB | 192 GB(64 GB per node) | 192 GB(64 GB per node) | 192 GB(64 GB per node) | 64 GB | 64 GB | 64 GB | 832 GB |
| Data Disk (Premium SSD / Standard HDD) | 0 | 3072 GB(1024 GB per node) (Premium SSD) | 0 | 10 GB (Standard SSD) | 500 GB (Standard HDD) | 0 | 0 | 3582 GB |
| Total | 64 GB | 3264 GB | 192 GB | 202 GB | 564 GB | 64 GB | 64 GB | 4414 GB |

#### Resource Price for Japan East Region

| Resource | Number of Instance | Virtual Machine | OS Disk | Data Disk | Load Balancer | Total |
|:---------|:-------------------|:----------------|:--------|:----------|:--------------|:------|
| Network | 1 | $94.17 | $11.74 | $0 | $0 | $105.91|
| Cassandra | 3 | $700.80 ($233.60 per node) | $35.22 ($11.74 per disk) | $466.32 ($155.44 per disk) | $0 | $1,202.34 |
| Node pool - Scalar Apps | 3 | $282.51 ($94.17 per node) | $35.22 ($11.74  per disk) | $0 | $0 | $317.73 |
| Node pool - Other Apps | 3 | $282.51 ($94.17 per node) | $35.22 ($11.74  per disk) | $0.75 | $0 | $318.48 |
| Cassy | 1 | $39.71 | $11.74 | $0 | $0 | $51.45 |
| Monitor | 1 | $39.71 | $11.74 | $21.76 (For 10000 transactions) | $0 | $73.21 | 
| Reaper | 1 | $39.71 | $11.74 | $0 | $0 | $51.45 | 
| Envoy LB | 1 | $0 | $0 | $0 | $0.01(Assuming 1Gb data processed) | $0.01 |
| Total | 14 | $1479.12 | $152.62 | $488.83 | $0.01 | $2120.58 |

Note: 
* _Load balancer cost will change according to network traffic._
* _Blob storage cost for cassy backup :- $0.02 per GB (For first 50 TB)_

#### Resource Price for West US 2 Region

| Resource | Number of Instance | Virtual Machine | OS Disk | Data Disk | Load Balancer | Total |
|:---------|:-------------------|:----------------|:--------|:----------|:--------------|:------|
| Network | 1 | $70.08 | $9.28 | $0 | $0 | $79.36 |
| Cassandra | 3 | $551.88 ($183.96 per node) | $27.84 ($9.28 per disk) | $368.64 ($122.88 per disk) | $0 | $948.36 |
| Node pool - Scalar Apps | 3 | $210.24 ($70.08 per node) | $27.84 ($9.28 per disk) | $0 | $0 | $238.08 |
| Node pool - Other Apps | 3 | $210.24 ($70.08 per node) | $27.84 ($9.28 per disk) | $0.75 | $0 | $238.83 |
| Cassy | 1 | $30.37 | $9.28 | $0 | $0 | $39.65 |
| Monitor | 1 | $30.37 | $9.28 | $21.76 (For 10000 transactions) | $0 | $61.41 |
| Reaper | 1 | $30.37 | $9.28 | $0 | $0 | $39.65 |
| Envoy LB | 1 | $0 | $0 | $0 | $0.01(Assuming 1GB processed bytes) | $0.01 |
| Total | 14 | $1133.55 | $120.64 | $391.15 | $0.01 | $1645.35 |

Note: 
* _Load balancer cost will change according to network traffic._
* _Blob storage cost for cassy backup :- $0.0184 per GB (For first 50 TB)_

### Bai

#### vCPU 

| scalar-terraform (bai) | Network | Cassandra | Node pool - Scalar Apps | Node pool - Other Apps | Monitor | Cassy | Reaper | Total |
|:-----------------------|:--------|:----------|:------------------------|:-----------------------|:--------|:------|:-------|:------|
| D2s v3 | 2 | 0 | 6 (2 vCPU per node) | 6 (2 vCPU per node) | 0 | 0 | 0 | 14 |
| E2s_v3 | 0 | 6 (2 vCPU per node) | 0 | 0 |0 | 0 | 0 | 6 |
| B2s | 0 | 0 | 0 | 0 | 2 | 2 | 2 | 6 |
| Total | 2 | 6 | 6 | 6 | 2 | 2 | 2 | 26 |

#### Disk Usage

| scalar-terraform (bai) | Network | Cassandra | Node pool - Scalar Apps | Node pool - Other Apps | Monitor | Cassy | Reaper | Total |
|:-----------------------|:--------|:----------|:------------------------|:-----------------------|:--------|:------|:-------|:------|
| OS Disk (Premium SSD) | 64 GB |  192 GB (64 GB per disk) |  192 GB (64 GB per disk) |  192 GB (64 GB per disk) | 64 GB | 64 GB | 64 GB | 832 GB |
| Data Disk (Premium SSD / Standard HDD) | 0 | 3072 GB (1024 GB per disk) (Premium SSD) | 0 | 0 | 500 GB (Standard HDD) | 0 | 0 | 3572 GB|
| Total | 64 GB | 3264 GB | 192 GB | 192 GB | 564 GB | 64 GB | 64 GB | 4404 GB |

#### Resource Price for Japan East Region

| Resource | Number of Instance | Virtual Machine | OS Disk | Data Disk | Load Balancer | Total |
|:---------|:-------------------|:----------------|:--------|:----------|:--------------|:------|
| Network | 1 | $94.17 | $11.74 | $0 | $0 | $105.91 |
| Cassandra | 3 | $350.4 ($116.80 per node) | $35.22 ($11.74 per disk) | $466.32 ($155.44 per disk) | $0 | $851.94 |
| Node pool - Scalar Apps | 3 | $282.51 ($94.17 per node) | $35.22 ($11.74 per disk) | $0 | $0 | $317.73 |
| Node pool - Other Apps | 3 | $282.51 ($94.17 per node) | $35.22 ($11.74 per disk) | $0 |$0.75 |$318.48 |
| Cassy | 1 | $39.71 | $11.74 | $0 | $0 | $51.45 |
| Monitor | 1 | $39.71 | $11.74 | $21.76 (For 10000 transactions) | $0 |$73.25 |
| Reaper | 1 | $39.71 | $11.74 | $0 | $0 | $51.45 |
| Envoy LB | 1 | $0 | $0 | $0 | $0.01(Assuming 1Gb data processed) | $0.01 |
| Total | 14 | $1128.72 | $152.62 | $488.83 | $0.01 | $1770.18 |

Note: 
* _Load balancer cost will change according to network traffic._
* _Blob storage cost for cassy backup :- $0.02 per GB (For first 50 GB)_

#### Resource Price for West US 2 Region

| Resource | Number of Instance | Virtual Machine | OS Disk | Data Disk | Load Balancer | Total |
|:---------|:-------------------|:----------------|:--------|:----------|:--------------|:------|
| Network | 1 | $70.08 | $9.28 | $0 | $0 | $79.36 |
| Cassandra | 3 | $275.94 ($91.98 per node) | $27.84 ($9.28 per disk) | $368.64 ($122.88 per disk) | $0 | $672.42 |
| Node pool - Scalar Apps | 3 | $210.24 ($70.08 per node) | $27.84($9.28 per node) | $0 | $0 | $238.08 |
| Node pool - Other Apps | 3 | $210.24 ($70.08 per node) | $27.84($9.28 per node) | $0.75 | $0 | $238.83 |
| Cassy | 1 | $30.37 | $9.28 | $0 | $0 | $39.65 |
| Monitor | 1 | $30.37 | $9.28 | $21.76 (For 10000 transactions) | $0 | $61.41 |
| Reaper | 1 | $30.37 | $9.28 | $0 | $0 | $39.65 |
| Envoy LB | 1 | $0 | $0 | $0 | $0.01 (Assuming 1Gb data processed) | $0.01 |
| Total | 14 | $857.61 | $120.64| $391.15 | $0.01 | $1369.41 |

Note: 
* _Load balancer cost will change according to network traffic._
* _Blob storage cost for cassy backup:- $0.0184 per GB (For first 50 TB)_