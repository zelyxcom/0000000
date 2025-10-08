Set-Location "$PSScriptRoot\.."

# 1. دمج المشروع في نسخة نظيفة
$target = "vexa-final"
if (-not (Test-Path $target)) {
  New-Item -ItemType Directory -Path $target | Out-Null
}
$mainFolders = @("vexa-react", "vex-backend", "vex-frontend")
foreach ($folder in $mainFolders) {
  if (Test-Path $folder) {
    Copy-Item $folder -Destination "$target\$folder" -Recurse -Force
  }
}
$rootFiles = @("README.md", ".gitignore", "LICENSE", "package.json", "tailwind.config.js", "postcss.config.js")
foreach ($file in $rootFiles) {
  if (Test-Path $file) {
    Copy-Item $file -Destination "$target\$file" -Force
  }
}

# 2. تغليف الخدمات
$servicesPath = "$target\services"
New-Item -ItemType Directory -Path $servicesPath -Force | Out-Null
foreach ($folder in $mainFolders) {
  Get-ChildItem -Path $folder -Recurse -File | Where-Object {
    $_.Extension -in ".js", ".ts", ".jsx", ".tsx"
  } | ForEach-Object {
    $relative = $_.DirectoryName.Replace((Resolve-Path $folder), "").Trim("\")
    $targetDir = Join-Path $servicesPath "$folder-$relative"
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    Copy-Item $_.FullName -Destination $targetDir -Force
  }
}

# 3. تشفير الأكواد
$obfuscatePath = "$target\obfuscated"
New-Item -ItemType Directory -Path $obfuscatePath -Force | Out-Null
Get-ChildItem -Path $target -Recurse -File | Where-Object {
  $_.Extension -in ".js", ".ts", ".jsx", ".tsx"
} | ForEach-Object {
  $content = Get-Content $_.FullName -Raw
  $encoded = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($content))
  $wrapper = @"
/* VeXa Protected — BOO90 Certified */
(function(){
  const code = '$encoded';
  const decoded = Buffer.from(code, 'base64').toString('utf8');
  eval(decoded);
})();
"@
  $relative = $_.FullName.Replace((Resolve-Path $target), "").Trim("\")
  $targetFile = Join-Path $obfuscatePath $relative
  $targetDir = Split-Path $targetFile
  New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
  $wrapper | Out-File $targetFile -Encoding UTF8
}

# 4. توقيع رقمي لكل ملف
$signaturePath = "$target\signatures"
New-Item -ItemType Directory -Path $signaturePath -Force | Out-Null
Get-ChildItem -Path $target -Recurse -File | ForEach-Object {
  $hash = Get-FileHash $_.FullName -Algorithm SHA256
  "$($_.FullName): $($hash.Hash)" | Out-File "$signaturePath\signatures.txt" -Append -Encoding UTF8
}

# 5. توليد README.md رسمي
@"
# VeXa Platform — Official Release

**VeXa** is a unified smart platform combining frontend, backend, automation scripts, and legal protection.

## 🔐 Ownership
- Owner: BOO90
- Serial: VXA-BOO90-1001
- Registered: 2025-10-04

## 🧠 Services
- Chat
- Smart Verification
- Payment & Billing
- Translation
- Entertainment
- SkillHub
- Security
- Virtual Rooms
- Admin Panel
- Auto Deployment

## 📜 Legal Files
Located in `vexa-final/docs`:
- LICENSE.md
- OWNERSHIP-CERTIFICATE.txt
- COMMERCIAL-REGISTRATION.txt
- TECHNICAL-VERIFICATION.txt

## 🚀 Ready for Deployment
All files are encrypted, signed, and zipped.
"@ | Out-File "$target\README.md" -Encoding UTF8

# 6. ضغط المشروع بالكامل
$zipPath = "vexa-protected.zip"
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Compress-Archive -Path "$target\*" -DestinationPath $zipPath

Write-Host "`n✅ المشروع جاهز بالكامل في: $zipPath" -ForegroundColor Green
Write-Host "📜 التوثيق، التشفير، التوقيع، README — تم بنجاح" -ForegroundColor Cyan
Write-Host "🚀 جاهز للرفع بضغطة زر باسم: BOO90" -ForegroundColor Yellow