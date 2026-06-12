# Architecture

The project uses Istio as the API gateway and service mesh control plane for Kubernetes workloads.

## Components

- `istio-ingressgateway`: Receives external HTTP traffic.
- `Gateway`: Defines the external listener on port 80.
- `VirtualService`: Maps URL paths to internal services.
- `DestinationRule`: Defines round-robin load balancing for each service.
- `PeerAuthentication`: Enables strict mutual TLS inside the namespace.
- `AuthorizationPolicy`: Allows inbound application traffic from the Istio ingress gateway.
- `customer-service`, `order-service`, `payment-service`: Internal services that are not directly exposed outside the cluster.

## Request Flow

1. A client sends an HTTP request to the Istio ingress gateway.
2. The `api-gateway` Istio `Gateway` accepts HTTP traffic on port 80.
3. The `api-routes` `VirtualService` matches the URL path and forwards traffic to the right Kubernetes service.
4. The destination service receives traffic through its Envoy sidecar.
5. Mesh policies enforce mTLS and restrict service access to traffic from the ingress gateway.

## API Routes

| Path | Destination |
| --- | --- |
| `/api/customers` | `customer-service` |
| `/api/orders` | `order-service` |
| `/api/payments` | `payment-service` |

## Service Endpoints

Each service exposes:

- `/health` for readiness and liveness probes
- `/api/<resource>` for gateway traffic
- `/internal/info` for simple service metadata

## Local Deployment

The Kind cluster maps container ports 80 and 443 to local host ports 8080 and 8443. The included test script uses `kubectl port-forward` to keep the workflow consistent across Docker Desktop networking setups.
