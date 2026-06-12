param(
  [string]$ClusterName = "istio-api-gateway"
)

$ErrorActionPreference = "Stop"
$services = @("customer-service", "order-service", "payment-service")

foreach ($service in $services) {
  docker build -t "$service`:local" ".\services\$service"
  kind load docker-image "$service`:local" --name $ClusterName
}

kubectl apply -f .\k8s\base
kubectl apply -f .\k8s\istio
kubectl wait --for=condition=available deployment --all -n api-gateway-demo --timeout=180s

Write-Host "Application and Istio API gateway resources are deployed."
