# Retail Store V3 – VPC Architecture

## 1. Current Network Design

The Retail Store V3 VPC follows the network architecture established in Retail Store V2.

| Component | Configuration |
|---|---|
| AWS Region | us-east-1 |
| VPC CIDR | 10.0.0.0/16 |
| Availability Zones | 3 |
| Public Subnets | 3 |
| Private Subnets | 3 |
| Subnet CIDR | /24 |
| Internet Gateway | 1 |
| NAT Gateways | 1 |
| Elastic IPs | 1 |
| DNS Support | Enabled |
| DNS Hostnames | Enabled |

### Network Traffic Flow

- Public subnets use the Internet Gateway for internet connectivity.
- Private subnets use the NAT Gateway for outbound internet access.
- EKS worker nodes are deployed in private subnets.
- Public-facing application traffic enters through the application load balancer.

## 2. NAT Gateway Architecture

### Current V3 Implementation: Single NAT Gateway

The current implementation uses one NAT Gateway located in the first public subnet.

All three private subnets route outbound internet traffic through this shared NAT Gateway.

**Advantages**
- Lower infrastructure cost.
- Simpler routing configuration.
- Suitable for a learning and demonstration environment.

**Limitations**
- The NAT Gateway is a shared outbound connectivity dependency.
- A NAT Gateway failure interrupts outbound internet access for all private subnets using it.
- Private subnet traffic may cross Availability Zones, creating additional data transfer costs.

A NAT Gateway failure does not automatically mean that the VPC or internal application communication is unavailable. The impact is primarily on traffic that depends on that NAT Gateway.

## 3. Production NAT Gateway Considerations

Production environments commonly deploy NAT Gateways across multiple Availability Zones to improve availability and reduce cross-AZ dependencies.

| Architecture | NAT Gateways | Design Consideration |
|---|---:|---|
| Current V3 | 1 | Shared outbound dependency |
| Two-NAT design | 2 | Improved redundancy, but one AZ may share a NAT |
| Three-NAT design | 3 | One NAT Gateway per AZ |

### Example: Three-AZ Production Design

- AZ-A private subnet → NAT Gateway A
- AZ-B private subnet → NAT Gateway B
- AZ-C private subnet → NAT Gateway C

Each private subnet uses a NAT Gateway in its own Availability Zone.

This design provides better AZ-level isolation for outbound connectivity and avoids routine cross-AZ NAT traffic.

## 4. Cost and Availability Tradeoff

Additional NAT Gateways increase infrastructure costs through hourly charges and data processing fees.

The architecture should balance:

- Availability requirements
- Fault isolation
- Cross-AZ data transfer
- Operational complexity
- Monthly infrastructure budget

## 5. V3 Architecture Decision

For the current Retail Store V3 implementation, the existing V2 single-NAT design is preserved.

The multi-NAT production architecture is documented as a future infrastructure enhancement rather than an immediate Terraform change.

Any future implementation should update the NAT Gateway resources, private route tables, and associated Terraform variables and outputs together.

---

**Project:** Retail Store V3 – Production Platform Engineering on AWS  
**Infrastructure:** Terraform  
**Network Architecture:** Three-AZ VPC with public and private subnets