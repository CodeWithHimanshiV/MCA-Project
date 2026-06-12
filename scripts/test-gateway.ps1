param(
  [int]$LocalPort = 8080
)

$ErrorActionPreference = "Stop"

$portForwardJob = Start-Job -ScriptBlock {
  param($Port)
  kubectl port-forward -n istio-system svc/istio-ingressgateway "$Port`:80"
} -ArgumentList $LocalPort

try {
  Start-Sleep -Seconds 5

  $routes = @(
    "/api/customers",
    "/api/orders",
    "/api/payments"
  )

  foreach ($route in $routes) {
    $url = "http://localhost:$LocalPort$route"
    Write-Host "Testing $url"
    Invoke-RestMethod $url | ConvertTo-Json -Depth 5
  }
}
finally {
  Stop-Job $portForwardJob -ErrorAction SilentlyContinue
  Remove-Job $portForwardJob -Force -ErrorAction SilentlyContinue
}
