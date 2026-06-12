param(
  [string]$ClusterName = "istio-api-gateway"
)

$ErrorActionPreference = "Stop"

function Require-Command {
  param([string]$Name)
  if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
    throw "Required command '$Name' was not found. Install it and retry."
  }
}

Require-Command docker
Require-Command kind
Require-Command kubectl
Require-Command istioctl

$existingCluster = kind get clusters | Where-Object { $_ -eq $ClusterName }
if (-not $existingCluster) {
  kind create cluster --name $ClusterName --config .\kind\cluster.yaml
}

kubectl config use-context "kind-$ClusterName"
istioctl install --set profile=demo -y
kubectl rollout status deployment/istiod -n istio-system --timeout=180s
kubectl rollout status deployment/istio-ingressgateway -n istio-system --timeout=180s

Write-Host "Kind cluster and Istio are ready."
