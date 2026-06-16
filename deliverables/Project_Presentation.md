# Istio API Gateway Service Mesh Project

Final Project Presentation  
Submitted by: ____________________

---

## Project Overview

- Demonstrates an API gateway using Istio service mesh.
- Uses three Node.js microservices: customer, order, and payment.
- Runs on Kubernetes using a local Kind cluster.
- Provides automated setup, deployment, testing, and cleanup scripts.

---

## Problem Statement

- Microservice systems contain multiple backend services.
- Exposing every service directly increases routing and security complexity.
- A gateway is required to provide one controlled entry point.
- This project uses Istio to route external requests to internal services.

---

## Objectives

- Create containerized backend microservices.
- Deploy services on Kubernetes.
- Configure Istio ingress gateway routing.
- Apply service mesh security using mutual TLS.
- Automate the local execution workflow.

---

## Technology Stack

- Node.js and Express.js for REST APIs.
- Docker for container images.
- Kubernetes and Kind for orchestration.
- Istio for gateway, routing, and mesh security.
- PowerShell for automation.

---

## System Architecture

Client requests enter through the Istio ingress gateway. Istio checks the URL path and forwards the request to the correct Kubernetes service.

Routes:

- `/api/customers` to customer service
- `/api/orders` to order service
- `/api/payments` to payment service

---

## Microservices

Customer Service:

- Provides customer records.
- Endpoint: `/api/customers`

Order Service:

- Provides order records.
- Endpoint: `/api/orders`

Payment Service:

- Provides payment records.
- Endpoint: `/api/payments`

---

## Kubernetes Deployment

- Each service has a Kubernetes Deployment.
- Each service runs with two replicas.
- Each service exposes port 8080 internally.
- Readiness and liveness probes use `/health`.
- Services communicate through Kubernetes service discovery.

---

## Istio Routing

- `Gateway` accepts external HTTP traffic on port 80.
- `VirtualService` performs path-based routing.
- `DestinationRule` applies round-robin load balancing.
- Backend services remain private inside the cluster.

---

## Security Features

- Strict mutual TLS is enabled in the namespace.
- Authorization policy allows traffic from the Istio ingress gateway.
- Backend services are not directly exposed publicly.
- Gateway provides a single controlled access point.

---

## Automation Scripts

- `setup-kind.ps1`: creates Kind cluster and installs Istio.
- `deploy.ps1`: builds images and deploys manifests.
- `test-gateway.ps1`: tests all gateway routes.
- `cleanup.ps1`: removes the local environment.

---

## Testing

Test commands:

```powershell
Invoke-RestMethod http://localhost:8080/api/customers
Invoke-RestMethod http://localhost:8080/api/orders
Invoke-RestMethod http://localhost:8080/api/payments
```

Expected output: JSON data from the correct backend service.

---

## Results

- All three services are reachable through one gateway endpoint.
- Istio routes requests based on API path.
- Kubernetes health probes support service availability.
- Mesh security policies protect backend service access.

---

## Limitations

- Uses sample in-memory data.
- Uses local Docker images instead of a remote registry.
- HTTP is used for local demonstration.
- No persistent database is included.

---

## Future Scope

- Add database integration.
- Add JWT authentication and authorization.
- Configure HTTPS certificates.
- Add CI/CD pipeline deployment.
- Add monitoring with Prometheus, Grafana, and Kiali.

---

## Conclusion

The project demonstrates a complete local API gateway and service mesh workflow using Istio, Kubernetes, Docker, and Node.js microservices. It is reproducible, script-driven, and suitable for demonstrating microservice routing and mesh security concepts.

---

## Thank You

Questions?
