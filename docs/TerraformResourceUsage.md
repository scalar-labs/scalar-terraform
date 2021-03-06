# Scalar-terraform Resource Usage

This document shows the resource usage and the monthly prices for the resources used by scalar-terraform.

## Azure

### Chiku
 
#### vCPU

| scalar-terraform (chiku) | Network | Cassandra | Scalardl | Envoy | Monitor | Cassy | Reaper | Total |
|:-------------------------|:--------|:----------|:---------|:------|:--------|:------|:-------|:------|
| D2s v3 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |
| E4s v3| 0 | 12 (4 vCPU per node) | 0 | 0 | 0 | 0 | 0 | 12 |
| B2s | 0 | 0 | 6 (2 vCPU per node)| 6 (2 vCPU per node) | 2 | 2 | 2 | 18 |
| Total | 2 | 12 | 6 | 6 | 2 | 2 | 2 | 32|
 
#### Disk Usage

| scalar-terraform (chiku) | Network | Cassandra | Scalardl | Envoy | Monitor | Cassy | Reaper | Total |
|:-------------------------|:--------|:----------|:---------|:------|:--------|:------|:-------|:------|
| OS Disk (Premium SSD) | 64 GB |  192 GB (64 GB per disk) |  192 GB (64 GB per disk) |  192 GB (64 GB per disk) | 64 GB | 64 GB | 64 GB | 832 GB |
| Data Disk (Premium SSD / Standard HDD) | 0 | 3072 GB (1024 GB per disk) (Premium SSD) | 0 | 0 | 500 GB (Standard HDD) | 0 | 0 | 3572 GB|
| Total | 64 GB | 3264 GB | 192 GB | 192 GB | 564 GB | 64 GB | 64 GB | 4404 GB |

#### Resource Price for Japan East Region

| Resource | Number of Instance | Virtual Machine | OS Disk | Data Disk | Load Balancer | Total |
|:---------|:-------------------|:----------------|:--------|:----------|:--------------|:------|
| Network | 1 | $94.17 | $11.74 | $0 | $0 | $105.91|
| Cassandra | 3 | $700.80 ($233.60 per node) | $35.22 ($11.74 per disk) | $466.32 ($155.44 per disk) | $0 | $1,202.34 |
| Scalardl | 3 | $119.14 ($39.71 per node) | $35.22 ($11.74 per disk) | $0 | $0 | $154.36 |
| Envoy | 3 | $119.14 ($39.71 per node) | $35.22 ($11.74 per disk) | $0 | $0 | $154.36 |
| Cassy | 1 | $39.71 | $11.74 | $0 | $0 | $51.45 |
| Monitor | 1 | $39.71 | $11.74 | $21.76 (For 10000 transactions) | $0 | $73.21 | 
| Reaper | 1 | $39.71 | $11.74 | $0 | $0 | $51.45 | 
| Envoy LB | 1 | $0 | $0 | $0 | $18.26 (Assuming 1Gb data processed) | $18.26 |
| Total | 14 | $1152.38 | $152.62 | $488.08 | $18.26 | $1811.34 |

Note: 
* _Load balancer cost will change according to network traffic._
* _Blob storage cost for cassy backup :- $0.02 per GB (For first 50 TB)_
 
#### Resource Price for West US 2 Region

| Resource | Number of Instance | Virtual Machine | OS Disk | Data Disk | Load Balancer | Total |
|:---------|:-------------------|:----------------|:--------|:----------|:--------------|:------|
| Network | 1 | $70.08 | $9.28 | $0 | $0 | $79.36 |
| Cassandra | 3 | $551.88 ($183.96 per node) | $27.84 ($9.28 per disk) | $368.64 ($122.88 per disk) | $0 | $948.36 |
| Scalardl | 3 | $91.10 ($30.37 per node) | $27.84 ($9.28 per disk) | $0 | $0 | $118.94 |
| Envoy | 3 | $91.10 ($30.37 per node) | $27.84 ($9.28 per disk) | $0 | $0 | $118.94 |
| Cassy | 1 | $30.37 | $9.28 | $0 | $0 | $39.65 |
| Monitor | 1 | $30.37 | $9.28 | $21.76 (For 10000 transactions) | $0 | $61.41 |
| Reaper | 1 | $30.37 | $9.28 | $0 | $0 | $39.65 |
| Envoy LB | 1 | $0 | $0 | $0 | $18.26 (Assuming 1Gb data processed) | $18.26 |
| Total | 14 | $895.27 | $120.64 | $390.4 | $18.26 | $1424.57 |

Note: 
* _Load balancer cost will change according to network traffic._
* _Blob storage cost for cassy backup :- $0.0184 per GB (For first 50 TB)_

### Bai

#### vCPU 

| scalar-terraform (bai) | Network | Cassandra | Scalardl | Envoy | Monitor | Cassy | Reaper | Total |
|:-----------------------|:--------|:----------|:---------|:------|:--------|:------|:-------|:------|
| D2s v3 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |
| E2s_v3 | 0 | 6 (2 vCPU per node) | 0 | 0 |0 | 0 | 0 | 6 |
| B2s | 0 | 0 | 6 (2 vCPU per node) | 6 (2 vCPU per node) | 2 | 2 | 2 | 18 |
| Total | 2 | 6 | 6 | 6 | 2 | 2 | 2 | 26 |

#### Disk Usage

| scalar-terraform (bai) | Network | Cassandra | Scalardl | Envoy | Monitor | Cassy | Reaper | Total |
|:-----------------------|:--------|:----------|:---------|:------|:--------|:------|:-------|:------|
| OS Disk (Premium SSD) | 64 GB |  192 GB (64 GB per disk) |  192 GB (64 GB per disk) |  192 GB (64 GB per disk) | 64 GB | 64 GB | 64 GB | 832 GB |
| Data Disk (Premium SSD / Standard HDD) | 0 | 3072 GB (1024 GB per disk) (Premium SSD) | 0 | 0 | 500 GB (Standard HDD) | 0 | 0 | 3572 GB|
| Total | 64 GB | 3264 GB | 192 GB | 192 GB | 564 GB | 64 GB | 64 GB | 4404 GB |

#### Resource Price for Japan East Region

| Resource | Number of Instance | Virtual Machine | OS Disk | Data Disk | Load Balancer | Total |
|:---------|:-------------------|:----------------|:--------|:----------|:--------------|:------|
| Network | 1 | $94.17 | $11.74 | $0 | $0 | $105.91 |
| Cassandra | 3 | $350.4 ($116.80 per node) | $35.22 ($11.74 per disk) | $466.32 ($155.44 per disk) | $0 | $851.94 |
| Scalardl | 3 | $119.14 ($39.71 per node) | $35.22 ($11.74 per disk) | $0 | $0 | $154.36 |
| Envoy | 3 | $119.14 ($39.71 per node) | $35.22 ($11.74 per disk) | $0 | $0 | $154.36 |
| Cassy | 1 | $39.71 | $11.74 | $0 | $0 |$51.45 |
| Monitor | 1 | $39.71 | $11.74 | $21.76 (For 10000 transactions) | $0 | $73.21 |
| Reaper | 1 | $39.71 | $11.74 | $0 | $0 | $51.45 |
| Envoy LB | 1 | $0 | $0 | $0 | $18.26 (Assuming 1Gb data processed) | $18.26 |
| Total | 14 | $801.98 | $152.62 | $488.08 | $18.26 | $1460.94 |

Note: 
* _Load balancer cost will change according to network traffic._
* _Blob storage cost for cassy backup :- $0.02 per GB (For first 50 TB)_

#### Resource Price for West US 2 Region

| Resource | Number of Instance | Virtual Machine | OS Disk | Data Disk | Load Balancer | Total |
|:---------|:-------------------|:----------------|:--------|:----------|:--------------|:------|
| Network | 1 | $70.08 | $9.28 | $0 | $0 | $79.36 |
| Cassandra | 3 | $275.94 ($91.98 per node) | $27.84 ($9.28 per disk) | $368.64 ($122.88 per disk) | $0 | $672.42 |
| Scalardl | 3 | $91.1 ($30.37 per node) | $27.84 ($9.28 per disk) | $0 | $0 | $118.94 |
| Envoy | 3 | $91.1 ($30.37 per node) | $27.84 ($9.28 per disk) | $0 | $0 | $118.94 |
| Cassy | 1 | $30.37 | $9.28 | $0 | $0 | $39.65 |
| Monitor | 1 | $30.37 | $9.28 | $21.76 (For 10000 transactions) | $0 | $61.41 |
| Reaper | 1 | $30.37 | $9.28 | $0 | $0 | $39.65 |
| Envoy LB | 1 | $0 | $0 | $0 | $18.26 (Assuming 1Gb data processed) | $18.26 |
| Total | 14 | $619.33 | $120.64 | $390.4 | $18.26 | $1148.63 |

Note: 
* _Load balancer cost will change according to network traffic._
* _Blob storage cost for cassy backup :- $0.0184 per GB (For first 50 TB)_


## AWS

### Chiku
 
#### vCPU
 
| scalar-terraform (chiku) | Network | Cassandra | Scalardl | Envoy | Monitor | Cassy | Reaper | Total |
|:-------------------------|:--------|:----------|:---------|:------|:--------|:------|:-------|:------|
| t3.micro (vCPU) | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |
| t3.medium (vCPU) | 0 | 0 | 0 | 6 (2 vCPU per node | 0 | 2 | 2 | 10 |
| t3.large (vCPU) | 0 | 0 | 6 (2 vCPU per node) | 0 | 2 | 0 | 0 | 8 |
| r5d.xlarge (vCPU) | 0 | 12 (4 vCPU per node) | 0 | 0 | 0 | 0 | 0 | 12 |
| Total | 2 | 12 | 6 | 6 | 2 | 2 | 2  | 32 |
 
#### Disk Usage

| scalar-terraform (chiku) | Network | Cassandra | Scalardl | Envoy | Monitor | Cassy | Reaper | Total |
|:-------------------------|:--------|:----------|:---------|:------|:--------|:------|:-------|:------|
| OS Disk (gp2) | 16 GB |  192 GB (64 GB per disk) |  192 GB (64 GB per disk) |  192 GB (64 GB per disk) | 64 GB | 64 GB | 64 GB | 784 GB |
| Data Disk (gp2 / sc1) | 0 | 3072 GB (1024 GB per disk) (gp2) | 0 | 0 | 500 GB (sc1) | 0 | 0 | 3572 GB|
| Total | 16 GB | 3264 GB | 192 GB | 192 GB | 564 GB | 64 GB | 64 GB | 4356 GB |

#### Resource Price for Tokyo Region

| Resource | Number of Instance | Virtual Machine | OS Disk | Data Disk | Load Balancer | Total |
|:---------|:-------------------|:----------------|:--------|:----------|:--------------|:------|
| Network | 1 | $9.93 | $1.92 | $0 | $0 | $11.85 |
| Cassandra | 3 | $762.12 ($254.04 per node) | $23.04 ($7.68per disk) | $368.64 ($122.88 per node) | $0 | $1153.8 |
| Scalardl | 3 | $238.27 ($79.42 per node) | $23.04 ($7.68 per disk) | $0 | $0 | $261.31 |
| Envoy | 3 | $119.14 ($39.71 per node) | $23.04 ($7.68 per disk) | $0 | $0 | $142.18 |
| Cassy | 1 | $39.71 | $7.68 | $0 | $0 | $47.39 |
| Monitor | 1 | $79.42 | $7.68 | $15 | $0 | $102.1 |
| Reaper | 1 | $39.71 | $7.68 | $0 | $0 | $47.39 |
| Envoy LB | 1 | $0 | $0 | $0 | $22.12 (Assuming 1 Gb processed bytes per hour) | $22.12 |
| Total | 14 | $1288.3 | $94.08 | $383.64 | $22.12 | $1788.14 |

Note: 
* _Load balancer cost will change according to network traffic._
* _S3 storage cost for cassy backup :- $0.025 per GB (For first 50 TB)_

#### Resource Price for West US 2 Region

| Resource | Number of Instance | Virtual Machine | OS Disk | Data Disk | Load Balancer | Total |
|:---------|:-------------------|:----------------|:--------|:----------|:--------------|:------|
| Network | 1 | $7.59 | $1.6 | $0 | $0 | $9.19 |
| Cassandra | 3 | $630.72 ($210.24 per node) | $19.2 ($6.40 per disk) | $307.2 ($102.40 per disk) | $0 | $957.12 |
| Scalardl | 3 | $182.21 ($60.74 per node) | $19.2 ($6.40 per disk) | $0 | $0 | $201.41 | 
| Envoy | 3 | $91.1 ($30.37 per node) | $19.2 ($6.40 per disk) | $0 | $0 | $110.3 |
| Cassy | 1 | $30.37 | $6.4 | $0 | $0 | $36.77 |
| Monitor | 1 | $60.74 | $6.4 | $12.5 | $0 | $79.64 |
| Reaper | 1 | $30.37 | $6.4 | $0 | $0 | $36.77 |
| Envoy LB | 1 | $0 | $0 | $0 | $20.81 (Assuming 1 Gb processed bytes per hour) | $20.81 |
| Total | 14 | $1033.1 | $78.4 | $319.7 | $20.81 | $1452.01 | 

Note: 
* _Load balancer cost will change according to network traffic._
* _S3 storage cost for cassy backup :- $0.023 per GB (For first 50 TB)_

### Bai

#### vCPU

| scalar-terraform (bai) | Network | Cassandra | Scalardl | Envoy | Monitor | Cassy | Reaper | Total |
|:-----------------------|:--------|:----------|:---------|:------|:--------|:------|:-------|:------|
| t3.micro (vCPU) | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |
| t3.medium (vCPU) | 0 | 0 | 6 (2 vCPU per node) | 6 (2 vCPU per node) | 2 | 2 | 2 | 18 |
| r5d.large (vCPU) | 0 | 6 (2 vCPU per node) | 0 | 0 | 0 | 0 | 0 | 6 |
| Total | 2 | 6 | 6 | 6 | 2 | 2 | 2 | 26 |

#### Disk Usage

| scalar-terraform (bai) | Network | Cassandra | Scalardl | Envoy | Monitor | Cassy | Reaper | Total |
|:-----------------------|:--------|:----------|:---------|:------|:--------|:------|:-------|:------|
| OS Disk (gp2) | 16 GB |  192 GB (64 GB per disk) |  192 GB (64 GB per disk) |  192 GB (64 GB per disk) | 64 GB | 64 GB | 64 GB | 784 GB |
| Data Disk (gp2 / sc1) | 0 | 3072 GB (1024 GB per disk) (gp2) | 0 | 0 | 500 GB (sc1) | 0 | 0 | 3572 GB|
| Total | 16 GB | 3264 GB | 192 GB | 192 GB | 564 GB | 64 GB | 64 GB | 4356 GB |

#### Resource Price for Tokyo Region

| Resource | Number of Instance | Virtual Machine | OS Disk | Data Disk | Load Balancer | Total |
|:---------|:-------------------|:----------------|:--------|:----------|:--------------|:------|
| Network | 1 | $9.93 | $1.92 | $0 | $0 | $11.85 |
| Cassandra | 3 | $381.06 ($127.02 per node) | $23.04 ($7.68 per disk) | $368.64 ($122.88 per disk) | $0 | $772.74 |
| Scalardl | 3 | $119.14 ($39.71 per node) | $23.04 ($7.68 per node) | $0 | $0 | $142.18 |
| Envoy | 3 | $119.14 ($39.71 per node) | $23.04 ($7.68 per node) | $0 | $0 | $142.18 |
| Cassy | 1 | $39.71 | $7.68 | $0 | $0 | $47.39 |
| Monitor | 1 | $39.71 | $7.68 | $15 | $0 | $62.39 |
| Reaper | 1 | $39.71 | $7.68 | $0 | $0 | $47.39 |
| Envoy LB | 1 | $0 | $0 | $0 | $22.12 (Assuming 1 Gb processed bytes per hour) | $20.81 |
| Total | 14 | $748.4 | $94.08 | 383.64 | $22.12 | $1248.24 |

Note: 
* _Load balancer cost will change according to network traffic._
* _S3 storage cost for cassy backup :- $0.025 per GB (For first 50 TB)_

#### Resource Price for West US 2 Region

| Resource | Number of Instance | Virtual Machine | OS Disk | Data Disk | Load Balancer | Total |
|:---------|:-------------------|:----------------|:--------|:----------|:--------------|:------|
| Network | 1 | $7.59 | $1.6 | $0 | $0 | $9.19 |
| Cassandra | 3 | $315.36 ($105.12 per node) | $19.2 ($6.40 per disk) | $307.2 ($102.40 per disk) | $0 | $641.76 |
| Scalardl | 3 | $91.1 ($30.37 per node) | $19.2 ($6.40 per disk) | $0 | $0 | $110.3 |
| Envoy | 3 | $91.1 ($30.37 per node) | $19.2 ($6.40 per disk) | $0 | $0 | $110.3 |
| Cassy | 1 | $30.37 | $6.4 | $0 | $0 | $36.77 |
| Monitor | 1 | $30.37 | $6.4 | $12.5 | $0 | $49.27 |
| Reaper | 1 | $30.37 | $6.4 | $0 | $0 | $36.77 |
| Envoy LB | 1 | $0 | $0 | $0 | $20.81 (Assuming 1 Gb processed bytes per hour) | $20.81 | 
| Total | 14 | $596.26 | $78.4 | $319.7 | $20.81 | $1015.17 |

Note: 
* _Load balancer cost will change according to network traffic._
* _S3 storage cost for cassy backup :- $0.023 per GB (For first 50 TB)_
