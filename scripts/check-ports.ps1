<#
.SYNOPSIS
    Local AI Hub Compose - PowerShell Port Verification Utility
.DESCRIPTION
    Tests local listener connectivity for New-API, WorkBuddy, Trae, Qoder, and CLIProxyAPI.
#>

[CmdletBinding()]
param(
    [int]$NewApiPort = 3000,
    [int]$WorkBuddyPort = 8788,
    [int]$TraePort = 8791,
    [int]$QoderPort = 8790,
    [int]$CliProxyPort = 8317
)

$services = @(
    @{ Name = "New-API Gateway"; Port = $NewApiPort },
    @{ Name = "WorkBuddy Hub  "; Port = $WorkBuddyPort },
    @{ Name = "Trae Hub       "; Port = $TraePort },
    @{ Name = "Qoder Hub      "; Port = $QoderPort },
    @{ Name = "CLIProxyAPI    "; Port = $CliProxyPort }
)

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Local AI Hub - Checking Port Status (Win)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

foreach ($svc in $services) {
    try {
        $tcp = New-Object System.Net.Sockets.TcpClient
        $iar = $tcp.BeginConnect("127.0.0.1", $svc.Port, $null, $null)
        $wait = $iar.AsyncWaitHandle.WaitOne(1000, $false)
        if ($wait -and $tcp.Connected) {
            $tcp.EndConnect($iar)
            Write-Host "[✓] $($svc.Name) is listening on port $($svc.Port)" -ForegroundColor Green
        } else {
            Write-Host "[x] $($svc.Name) is NOT reachable on port $($svc.Port)" -ForegroundColor Yellow
        }
        $tcp.Close()
    } catch {
        Write-Host "[x] $($svc.Name) check failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "==========================================" -ForegroundColor Cyan
