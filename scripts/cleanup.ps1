param(
  [string]$ClusterName = "istio-api-gateway"
)

$ErrorActionPreference = "Stop"

kind delete cluster --name $ClusterName
Write-Host "Deleted Kind cluster '$ClusterName'."
