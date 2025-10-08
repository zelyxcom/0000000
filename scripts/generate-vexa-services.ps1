Set-Location "$PSScriptRoot\.."

# Output folder for separated services
$servicesOut = "vexa-services"
if (-not (Test-Path $servicesOut)) {
  New-Item -ItemType Directory -Path $servicesOut | Out-Null
}

# Define services by category and source filenames
$services = @{
  "auth" = @("authService.js")
  "profile" = @("userModel.js")
  "match" = @("matchService.js", "match-free.js")
  "chat-free" = @("chat-engine.js", "socket-config.js")
  "chat-paid" = @("chat-engine.js", "chat-billing.js", "payment-handler.js")
  "request" = @("bookingEngine.js", "verifyTo.js")
  "payment" = @("payment-check.js", "payment-handler.js")
  "dashboard" = @("dashboard.tsx", "admin.tsx")
  "ai" = @("aiService.js", "recommendation.ts")
  "notification" = @("notification.ts", "socket-config.js")
  "review" = @("reviewService.js", "rating.tsx")
  "cms" = @("contentService.js", "cms.tsx")
  "analytics" = @("analytics.ts", "insights.tsx")
  "security" = @("fraud-detection.js", "traceService.js")
  "face" = @("face-auth.js")
  "fingerprint" = @("fingerprint.ts")
  "translate" = @("translate.js")
  "invoice" = @("invoice.ts", "billing.ts")
  "commerce" = @("commerce.ts", "productService.js")
  "graphics" = @("vrRoom.ts", "effects.ts")
}

# Search inside the cleaned project and copy each service file
foreach ($service in $services.Keys) {
  $target = Join-Path $servicesOut $service
  New-Item -ItemType Directory -Path $target -Force | Out-Null
  foreach ($filename in $services[$service]) {
    $found = Get-ChildItem -Path "vexa-final" -Recurse -File | Where-Object { $_.Name -eq $filename }
    foreach ($file in $found) {
      Copy-Item $file.FullName -Destination $target -Force
    }
  }
}

Write-Host "`nAll service files have been generated inside: $servicesOut" -ForegroundColor Green
Write-Host "Ready for interface linking or repository upload." -ForegroundColor Cyan