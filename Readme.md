# Istio API Gateway Service Mesh Project

This repository demonstrates an API gateway implementation using Istio service mesh. It includes three containerized microservices, Kubernetes deployment manifests, Istio ingress routing, mesh security policies, and PowerShell automation for a local Kind-based environment.

## What This Project Shows

- API gateway using Istio `Gateway` and `VirtualService`
- Path-based routing for multiple backend services
- Kubernetes service discovery inside the mesh
- Automatic sidecar injection through namespace labels
- Strict mutual TLS between in-mesh workloads
- Authorization policy that allows traffic to services only from the Istio ingress gateway
- Local developer workflow using Docker, Kind, kubectl, and Istioctl

## Architecture

Client traffic enters through the Istio ingress gateway and is routed by path:

| Public Path | Internal Service | Port |
| --- | --- | --- |
| `/api/customers` | `customer-service` | `8080` |
| `/api/orders` | `order-service` | `8080` |
| `/api/payments` | `payment-service` | `8080` |

```text
Client
  |
  v
Istio Ingress Gateway
  |
  v
VirtualService path routing
  |
  +-- /api/customers -> customer-service
  +-- /api/orders    -> order-service
  +-- /api/payments  -> payment-service
```

## Prerequisites

Install these tools before running locally:

- Docker Desktop
- Kind
- kubectl
- Istioctl
- PowerShell 5.1 or later

Verify them:

```powershell
docker version
kind version
kubectl version --client
istioctl version
```

See [docs/prerequisites-windows.md](docs/prerequisites-windows.md) for Windows installation commands.

## Quick Start

From the repository root, run:

```powershell
.\scripts\setup-kind.ps1
.\scripts\deploy.ps1
.\scripts\test-gateway.ps1
```

The scripts create a local Kubernetes cluster, install Istio, build the service images, deploy the application, and test the gateway routes.

## Manual Commands

Create a Kind cluster:

```powershell
kind create cluster --name istio-api-gateway --config .\kind\cluster.yaml
```

Install Istio:

```powershell
istioctl install --set profile=demo -y
```

Build and load service images:

```powershell
docker build -t customer-service:local .\services\customer-service
docker build -t order-service:local .\services\order-service
docker build -t payment-service:local .\services\payment-service

kind load docker-image customer-service:local --name istio-api-gateway
kind load docker-image order-service:local --name istio-api-gateway
kind load docker-image payment-service:local --name istio-api-gateway
```

Deploy Kubernetes and Istio resources:

```powershell
kubectl apply -f .\k8s\base
kubectl apply -f .\k8s\istio
kubectl wait --for=condition=available deployment --all -n api-gateway-demo --timeout=180s
```

Port-forward the Istio ingress gateway:

```powershell
kubectl port-forward -n istio-system svc/istio-ingressgateway 8080:80
```

In another terminal, test the routes:

```powershell
Invoke-RestMethod http://localhost:8080/api/customers
Invoke-RestMethod http://localhost:8080/api/orders
Invoke-RestMethod http://localhost:8080/api/payments
```

## Repository Layout

```text
.
|-- docs/
|   `-- architecture.md
|-- k8s/
|   |-- base/
|   `-- istio/
|-- kind/
|   `-- cluster.yaml
|-- scripts/
|-- services/
|   |-- customer-service/
|   |-- order-service/
|   `-- payment-service/
`-- README.md
```

## Cleanup

```powershell
.\scripts\cleanup.ps1
```

## Notes for a Live Environment

For production or a shared live environment, replace local image tags with images from a container registry, configure TLS certificates on the Istio gateway, use external DNS for the gateway host, and define environment-specific overlays for dev, test, and production.
