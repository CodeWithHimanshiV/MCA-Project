# Final Project Report

## Project Title

Istio API Gateway Service Mesh Project

## Submitted By

Name: __________________________  
Course/Department: __________________________  
Institution: __________________________  
Date: 15 June 2026

## Abstract

This project demonstrates the implementation of an API gateway using Istio service mesh on Kubernetes. The system contains three independent Node.js microservices for customers, orders, and payments. These services are deployed as containerized workloads inside a Kubernetes cluster and exposed externally through the Istio ingress gateway. The project shows path-based API routing, Kubernetes service discovery, health checks, local container image deployment, mutual TLS inside the mesh, and authorization rules that restrict application access through the ingress gateway.

The project is designed for a local development and demonstration environment using Docker Desktop, Kind, kubectl, Istioctl, Node.js, and PowerShell automation.

## Objectives

- Build a microservice-based API gateway demonstration.
- Deploy multiple backend services into Kubernetes.
- Use Istio Gateway and VirtualService resources for external routing.
- Apply service mesh security using strict mutual TLS.
- Restrict backend traffic using Istio AuthorizationPolicy.
- Automate setup, deployment, testing, and cleanup using PowerShell scripts.
- Provide a reproducible local environment for project evaluation.

## Problem Statement

In a microservice architecture, applications are split into multiple independently deployable services. Directly exposing every service to users increases security risk, routing complexity, and operational overhead. A centralized API gateway helps route client requests to the correct internal service while keeping backend services private.

This project solves that problem by using Istio as the API gateway and service mesh layer. External users call one gateway endpoint, and Istio routes each request to the appropriate internal Kubernetes service based on the request path.

## Technologies Used

| Technology | Purpose |
| --- | --- |
| Node.js | Runtime for backend microservices |
| Express.js | HTTP API framework for each service |
| Docker | Containerization of services |
| Kubernetes | Container orchestration platform |
| Kind | Local Kubernetes cluster for testing |
| Istio | API gateway, service mesh, routing, security |
| kubectl | Kubernetes command-line management |
| istioctl | Istio installation and management |
| PowerShell | Automation scripts for Windows environment |

## Repository Structure

```text
.
|-- docs/
|   |-- architecture.md
|   `-- prerequisites-windows.md
|-- k8s/
|   |-- base/
|   |   |-- customer-service.yaml
|   |   |-- namespace.yaml
|   |   |-- order-service.yaml
|   |   `-- payment-service.yaml
|   `-- istio/
|       |-- destination-rules.yaml
|       |-- gateway.yaml
|       |-- security.yaml
|       `-- virtual-service.yaml
|-- kind/
|   `-- cluster.yaml
|-- scripts/
|   |-- cleanup.ps1
|   |-- deploy.ps1
|   |-- setup-kind.ps1
|   `-- test-gateway.ps1
|-- services/
|   |-- customer-service/
|   |-- order-service/
|   `-- payment-service/
`-- Readme.md
```

## System Architecture

The system follows a gateway-based microservice architecture.

```text
Client
  |
  v
Istio Ingress Gateway
  |
  v
Istio VirtualService
  |
  +-- /api/customers -> customer-service
  +-- /api/orders    -> order-service
  +-- /api/payments  -> payment-service
```

### Main Components

1. **Client**  
   Sends HTTP requests to the local gateway endpoint.

2. **Istio Ingress Gateway**  
   Receives external traffic and acts as the single entry point into the system.

3. **Istio Gateway Resource**  
   Defines the external HTTP listener on port 80.

4. **Istio VirtualService Resource**  
   Performs path-based routing to internal Kubernetes services.

5. **DestinationRule Resource**  
   Defines round-robin load balancing for the customer, order, and payment services.

6. **Kubernetes Deployments and Services**  
   Run two replicas of each microservice and expose each service internally on port 8080.

7. **Istio Security Policies**  
   Enforce strict mutual TLS and allow application access from the Istio ingress gateway.

## Microservices

### Customer Service

Location: `services/customer-service`

Endpoints:

| Endpoint | Description |
| --- | --- |
| `/health` | Health check endpoint |
| `/api/customers` | Returns sample customer data |
| `/internal/info` | Returns service metadata |

Sample response from `/api/customers` includes customer IDs, names, and membership tiers.

### Order Service

Location: `services/order-service`

Endpoints:

| Endpoint | Description |
| --- | --- |
| `/health` | Health check endpoint |
| `/api/orders` | Returns sample order data |
| `/internal/info` | Returns service metadata |

Sample response from `/api/orders` includes order IDs, customer IDs, status, and amount.

### Payment Service

Location: `services/payment-service`

Endpoints:

| Endpoint | Description |
| --- | --- |
| `/health` | Health check endpoint |
| `/api/payments` | Returns sample payment data |
| `/internal/info` | Returns service metadata |

Sample response from `/api/payments` includes payment IDs, order IDs, status, and amount.

## API Routing

| Public Route | Internal Destination | Port |
| --- | --- | --- |
| `/api/customers` | `customer-service.api-gateway-demo.svc.cluster.local` | 8080 |
| `/api/orders` | `order-service.api-gateway-demo.svc.cluster.local` | 8080 |
| `/api/payments` | `payment-service.api-gateway-demo.svc.cluster.local` | 8080 |

All public routes are configured in the Istio `VirtualService`. The backend services are not directly exposed outside the Kubernetes cluster.

## Kubernetes Deployment Details

Each microservice is deployed as a Kubernetes `Deployment` with two replicas. Each deployment uses:

- Container image tagged as `<service-name>:local`.
- Container port `8080`.
- Readiness probe on `/health`.
- Liveness probe on `/health`.
- Internal Kubernetes `Service` for service discovery.

The namespace used by the application is `api-gateway-demo`. It is configured for Istio sidecar injection so that service mesh traffic management and security can be applied.

## Security Implementation

Security is implemented using Istio resources:

1. **PeerAuthentication**  
   Enables strict mutual TLS for workloads in the namespace.

2. **AuthorizationPolicy**  
   Allows inbound application traffic from the Istio ingress gateway service account.

This design prevents backend services from being treated as public entry points and keeps access controlled through the gateway layer.

## Setup and Execution

### Prerequisites

Install these tools before running the project:

- Docker Desktop
- Kind
- kubectl
- Istioctl
- Node.js
- PowerShell 5.1 or later

### Automated Execution

From the repository root, run:

```powershell
.\scripts\setup-kind.ps1
.\scripts\deploy.ps1
.\scripts\test-gateway.ps1
```

### What the Scripts Do

| Script | Purpose |
| --- | --- |
| `setup-kind.ps1` | Creates the local Kind cluster and installs Istio |
| `deploy.ps1` | Builds Docker images, loads them into Kind, and applies Kubernetes/Istio manifests |
| `test-gateway.ps1` | Port-forwards the Istio ingress gateway and tests all API routes |
| `cleanup.ps1` | Deletes the local Kind cluster and cleanup resources |

## Manual Testing

After deployment, the gateway can be tested using:

```powershell
Invoke-RestMethod http://localhost:8080/api/customers
Invoke-RestMethod http://localhost:8080/api/orders
Invoke-RestMethod http://localhost:8080/api/payments
```

Expected result: each command returns a JSON response from the matching backend service.

## Expected Output

The expected output includes:

- Customer service JSON response for `/api/customers`.
- Order service JSON response for `/api/orders`.
- Payment service JSON response for `/api/payments`.
- Kubernetes deployments reaching the available state.
- Istio ingress gateway successfully routing traffic to the correct service.

## Features Implemented

- Three independent REST microservices.
- Dockerized application services.
- Kubernetes deployments and services.
- Local Kind cluster setup.
- Istio ingress gateway configuration.
- Path-based API routing.
- Round-robin destination rules.
- Health checks using readiness and liveness probes.
- Strict mutual TLS in the mesh.
- Authorization policy for controlled ingress access.
- PowerShell automation for setup, deployment, testing, and cleanup.

## Limitations

- The project uses sample in-memory data instead of a database.
- The gateway uses HTTP for local demonstration; production should use HTTPS/TLS certificates.
- Container images are local Kind images, not pushed to a registry.
- Environment-specific overlays for dev, test, and production are not included.

## Future Enhancements

- Add a database for persistent customer, order, and payment data.
- Add JWT authentication at the gateway.
- Configure HTTPS with certificates.
- Add CI/CD pipeline integration.
- Add monitoring dashboards using Prometheus, Grafana, and Kiali.
- Add Kubernetes overlays using Kustomize or Helm.
- Add automated unit and integration tests.

## Conclusion

This project successfully demonstrates how Istio can be used as an API gateway and service mesh layer for Kubernetes microservices. It provides a practical example of routing external API traffic to internal services, applying mesh-level security, and automating local deployment. The project is suitable for academic demonstration because it covers source code, deployment configuration, executable scripts, testing workflow, and documentation in a reproducible structure.
