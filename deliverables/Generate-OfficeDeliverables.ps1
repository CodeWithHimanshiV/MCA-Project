$ErrorActionPreference = "Stop"

$deliverablesPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$reportPath = Join-Path $deliverablesPath "Project_Report.docx"
$presentationPath = Join-Path $deliverablesPath "Project_Presentation.pptx"

function Add-WordParagraph {
  param(
    [object]$Document,
    [string]$Text,
    [int]$Bold = 0,
    [int]$Size = 11,
    [string]$Style = "Normal"
  )

  $paragraph = $Document.Paragraphs.Add()
  $paragraph.Range.Text = $Text
  $paragraph.Range.Font.Bold = $Bold
  $paragraph.Range.Font.Size = $Size
  $paragraph.Range.Style = $Style
  $paragraph.Range.InsertParagraphAfter() | Out-Null
}

$word = New-Object -ComObject Word.Application
$word.Visible = $false
try {
  $document = $word.Documents.Add()
  $selection = $word.Selection

  Add-WordParagraph $document "Final Project Report" 1 20 "Title"
  Add-WordParagraph $document "Istio API Gateway Service Mesh Project" 1 16 "Subtitle"
  Add-WordParagraph $document "Submitted By: __________________________" 0 11
  Add-WordParagraph $document "Course/Department: __________________________" 0 11
  Add-WordParagraph $document "Institution: __________________________" 0 11
  Add-WordParagraph $document "Date: 15 June 2026" 0 11

  $sections = @(
    @{ Heading = "Abstract"; Body = "This project demonstrates the implementation of an API gateway using Istio service mesh on Kubernetes. The system contains three independent Node.js microservices for customers, orders, and payments. These services are deployed as containerized workloads inside a Kubernetes cluster and exposed externally through the Istio ingress gateway. The project shows path-based API routing, Kubernetes service discovery, health checks, local container image deployment, mutual TLS inside the mesh, and authorization rules that restrict application access through the ingress gateway." },
    @{ Heading = "Objectives"; Body = "Build a microservice-based API gateway demonstration; deploy multiple backend services into Kubernetes; use Istio Gateway and VirtualService resources for external routing; apply strict mutual TLS; restrict backend traffic using Istio AuthorizationPolicy; automate setup, deployment, testing, and cleanup using PowerShell scripts." },
    @{ Heading = "Problem Statement"; Body = "In a microservice architecture, applications are split into multiple independently deployable services. Directly exposing every service to users increases security risk, routing complexity, and operational overhead. This project solves that problem by using Istio as the API gateway and service mesh layer. External users call one gateway endpoint, and Istio routes each request to the appropriate internal Kubernetes service based on the request path." },
    @{ Heading = "Technology Stack"; Body = "Node.js and Express.js are used for REST APIs. Docker is used for containerization. Kubernetes and Kind are used for orchestration. Istio provides gateway routing and service mesh security. kubectl and istioctl are used for cluster and Istio management. PowerShell scripts automate the Windows local workflow." },
    @{ Heading = "Repository Structure"; Body = "The repository contains docs for architecture and prerequisites, Kubernetes manifests under k8s, Kind cluster configuration under kind, automation scripts under scripts, and three backend services under services: customer-service, order-service, and payment-service." },
    @{ Heading = "System Architecture"; Body = "Client traffic enters through the Istio ingress gateway. The Istio Gateway accepts HTTP traffic on port 80. The VirtualService maps URL paths to internal Kubernetes services. DestinationRules define round-robin load balancing. Backend services run as private workloads inside the api-gateway-demo namespace." },
    @{ Heading = "Microservices"; Body = "Customer Service exposes /health, /api/customers, and /internal/info. Order Service exposes /health, /api/orders, and /internal/info. Payment Service exposes /health, /api/payments, and /internal/info. Each service is implemented with Node.js and Express and listens on port 8080." },
    @{ Heading = "API Routing"; Body = "The public route /api/customers is routed to customer-service. The public route /api/orders is routed to order-service. The public route /api/payments is routed to payment-service. All services are addressed internally using Kubernetes DNS names in the api-gateway-demo namespace." },
    @{ Heading = "Kubernetes Deployment"; Body = "Each service has a Kubernetes Deployment with two replicas, container port 8080, readiness probe on /health, and liveness probe on /health. Each service also has an internal Kubernetes Service for discovery and routing." },
    @{ Heading = "Security Implementation"; Body = "Istio PeerAuthentication enables strict mutual TLS in the namespace. Istio AuthorizationPolicy allows inbound application traffic from the Istio ingress gateway service account. This keeps backend services controlled through the gateway layer." },
    @{ Heading = "Execution Steps"; Body = "Run .\scripts\setup-kind.ps1 to create the Kind cluster and install Istio. Run .\scripts\deploy.ps1 to build Docker images, load them into Kind, and apply Kubernetes and Istio manifests. Run .\scripts\test-gateway.ps1 to test all gateway routes. Run .\scripts\cleanup.ps1 to remove the local environment." },
    @{ Heading = "Testing"; Body = "The gateway can be tested with Invoke-RestMethod http://localhost:8080/api/customers, Invoke-RestMethod http://localhost:8080/api/orders, and Invoke-RestMethod http://localhost:8080/api/payments. Each command should return JSON data from the correct backend service." },
    @{ Heading = "Features Implemented"; Body = "The project includes three REST microservices, Dockerized services, Kubernetes deployments and services, local Kind setup, Istio ingress routing, round-robin destination rules, health checks, strict mutual TLS, authorization policy, and PowerShell automation." },
    @{ Heading = "Limitations"; Body = "The project uses sample in-memory data instead of a database. The gateway uses HTTP for local demonstration. Container images are local Kind images and are not pushed to a registry. Environment-specific overlays are not included." },
    @{ Heading = "Future Enhancements"; Body = "Future improvements can include database integration, JWT authentication, HTTPS certificates, CI/CD pipeline integration, monitoring with Prometheus and Grafana, Kiali service mesh visualization, Helm charts, and automated unit or integration tests." },
    @{ Heading = "Conclusion"; Body = "This project successfully demonstrates how Istio can be used as an API gateway and service mesh layer for Kubernetes microservices. It provides a practical example of routing external API traffic to internal services, applying mesh-level security, and automating local deployment in a reproducible structure." }
  )

  foreach ($section in $sections) {
    Add-WordParagraph $document $section.Heading 1 14 "Heading 1"
    Add-WordParagraph $document $section.Body 0 11
  }

  $document.SaveAs2($reportPath, 16)
  $document.Close()
}
finally {
  $word.Quit()
}

function Add-PresentationSlide {
  param(
    [object]$Presentation,
    [string]$Title,
    [string[]]$Bullets
  )

  $slide = $Presentation.Slides.Add($Presentation.Slides.Count + 1, 2)
  $slide.Shapes.Title.TextFrame.TextRange.Text = $Title
  $body = $slide.Shapes.Item(2).TextFrame.TextRange
  $body.Text = ($Bullets -join "`r`n")
  $body.Font.Size = 24
  $body.ParagraphFormat.Bullet.Visible = -1
}

$powerPoint = New-Object -ComObject PowerPoint.Application
$powerPoint.Visible = 1
try {
  $presentation = $powerPoint.Presentations.Add()

  $titleSlide = $presentation.Slides.Add(1, 1)
  $titleSlide.Shapes.Title.TextFrame.TextRange.Text = "Istio API Gateway Service Mesh Project"
  $titleSlide.Shapes.Item(2).TextFrame.TextRange.Text = "Final Project Presentation`r`nSubmitted by: ____________________"

  Add-PresentationSlide $presentation "Project Overview" @(
    "API gateway demonstration using Istio service mesh",
    "Three Node.js microservices: customer, order, and payment",
    "Runs locally on Kubernetes using Kind",
    "Includes setup, deployment, testing, and cleanup automation"
  )
  Add-PresentationSlide $presentation "Problem Statement" @(
    "Microservice systems contain multiple backend services",
    "Direct exposure increases routing and security complexity",
    "A gateway provides one controlled entry point",
    "Istio routes external requests to internal services"
  )
  Add-PresentationSlide $presentation "Objectives" @(
    "Create containerized backend microservices",
    "Deploy services on Kubernetes",
    "Configure Istio ingress gateway routing",
    "Apply service mesh security using mutual TLS"
  )
  Add-PresentationSlide $presentation "Technology Stack" @(
    "Node.js and Express.js for REST APIs",
    "Docker for container images",
    "Kubernetes and Kind for orchestration",
    "Istio for gateway, routing, and mesh security",
    "PowerShell for automation"
  )
  Add-PresentationSlide $presentation "System Architecture" @(
    "Client sends requests to Istio ingress gateway",
    "Gateway accepts external HTTP traffic",
    "VirtualService performs path-based routing",
    "Backend services remain private inside Kubernetes"
  )
  Add-PresentationSlide $presentation "Microservices" @(
    "Customer Service: /api/customers",
    "Order Service: /api/orders",
    "Payment Service: /api/payments",
    "All services include /health and /internal/info endpoints"
  )
  Add-PresentationSlide $presentation "Kubernetes Deployment" @(
    "Each service runs as a Kubernetes Deployment",
    "Each service has two replicas",
    "Internal services expose port 8080",
    "Readiness and liveness probes use /health"
  )
  Add-PresentationSlide $presentation "Istio Routing" @(
    "Gateway listens for HTTP traffic on port 80",
    "VirtualService maps request paths to services",
    "DestinationRule applies round-robin load balancing",
    "One public entry point serves multiple backend APIs"
  )
  Add-PresentationSlide $presentation "Security Features" @(
    "Strict mutual TLS is enabled in the namespace",
    "AuthorizationPolicy allows ingress gateway traffic",
    "Backend services are not directly public",
    "Gateway controls application access"
  )
  Add-PresentationSlide $presentation "Automation Scripts" @(
    "setup-kind.ps1 creates the cluster and installs Istio",
    "deploy.ps1 builds images and deploys manifests",
    "test-gateway.ps1 tests all gateway routes",
    "cleanup.ps1 removes the local environment"
  )
  Add-PresentationSlide $presentation "Testing" @(
    "Test /api/customers through the gateway",
    "Test /api/orders through the gateway",
    "Test /api/payments through the gateway",
    "Expected result is JSON from the correct backend service"
  )
  Add-PresentationSlide $presentation "Results" @(
    "All three services are reachable through one gateway endpoint",
    "Istio routes requests based on API path",
    "Health probes support service availability",
    "Mesh policies protect backend service access"
  )
  Add-PresentationSlide $presentation "Future Scope" @(
    "Add database integration",
    "Add JWT authentication and HTTPS certificates",
    "Add CI/CD pipeline deployment",
    "Add monitoring with Prometheus, Grafana, and Kiali"
  )
  Add-PresentationSlide $presentation "Conclusion" @(
    "The project demonstrates Istio API gateway routing",
    "Kubernetes hosts scalable backend services",
    "Service mesh security protects internal traffic",
    "The workflow is reproducible through automation scripts"
  )
  Add-PresentationSlide $presentation "Thank You" @("Questions?")

  $presentation.SaveAs($presentationPath, 24)
  $presentation.Close()
}
finally {
  $powerPoint.Quit()
}

Write-Host "Created $reportPath"
Write-Host "Created $presentationPath"
