# Windows Prerequisites

Install the required tools before running the local Kind and Istio workflow.

## Option 1: Winget

Run PowerShell as your normal user:

```powershell
winget install Docker.DockerDesktop
winget install Kubernetes.kind
winget install Kubernetes.kubectl
winget install OpenJS.NodeJS.LTS
```

After Docker Desktop is installed, open Docker Desktop once and wait until the engine is running.

Install Istio CLI manually:

```powershell
Invoke-WebRequest -Uri "https://github.com/istio/istio/releases/download/1.22.3/istio-1.22.3-win.zip" -OutFile "$env:TEMP\istio.zip"
Expand-Archive "$env:TEMP\istio.zip" -DestinationPath "$env:USERPROFILE\tools" -Force
$env:Path += ";$env:USERPROFILE\tools\istio-1.22.3\bin"
```

To make `istioctl` available in future terminals, add this folder to your user `Path` environment variable:

```text
%USERPROFILE%\tools\istio-1.22.3\bin
```

## Option 2: Chocolatey

```powershell
choco install docker-desktop kind kubernetes-cli nodejs-lts -y
```

Install Istio CLI with the manual steps above.

## Verify

Open a new PowerShell terminal and run:

```powershell
docker version
kind version
kubectl version --client
istioctl version
node --version
```

Then run the project:

```powershell
.\scripts\setup-kind.ps1
.\scripts\deploy.ps1
.\scripts\test-gateway.ps1
```
