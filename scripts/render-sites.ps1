param(
  [string]$ConfigPath = "sites.config.json"
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$templatePath = Join-Path $repoRoot "templates/index.template.html"
$stylePath = Join-Path $repoRoot "shared/style.css"
$scriptPath = Join-Path $repoRoot "shared/site.js"
$resolvedConfigPath = Join-Path $repoRoot $ConfigPath

if (-not (Test-Path $resolvedConfigPath)) {
  throw "Config file not found: $resolvedConfigPath"
}

if (-not (Test-Path $templatePath)) {
  throw "Template file not found: $templatePath"
}

$template = Get-Content -Raw -Path $templatePath
$sites = Get-Content -Raw -Path $resolvedConfigPath | ConvertFrom-Json

foreach ($site in $sites) {
  $domainRoot = Join-Path $repoRoot (Join-Path "sites" $site.domain)
  $assetsRoot = Join-Path $domainRoot "assets"

  New-Item -ItemType Directory -Force -Path $assetsRoot | Out-Null

  $content = $template
  $content = $content.Replace("{{DOMAIN}}", [string]$site.domain)
  $content = $content.Replace("{{EYEBROW}}", [string]$site.eyebrow)
  $content = $content.Replace("{{HEADLINE}}", [string]$site.headline)
  $content = $content.Replace("{{SUBHEAD}}", [string]$site.subhead)
  $content = $content.Replace("{{PRIMARY_LABEL}}", [string]$site.primaryLabel)
  $content = $content.Replace("{{PRIMARY_HREF}}", [string]$site.primaryHref)
  $content = $content.Replace("{{SECONDARY_LABEL}}", [string]$site.secondaryLabel)
  $content = $content.Replace("{{SECONDARY_HREF}}", [string]$site.secondaryHref)

  Set-Content -Path (Join-Path $domainRoot "index.html") -Value $content -Encoding UTF8
  Copy-Item -Path $stylePath -Destination (Join-Path $assetsRoot "style.css") -Force
  Copy-Item -Path $scriptPath -Destination (Join-Path $assetsRoot "site.js") -Force

  Write-Host "Generated static page for $($site.domain)"
}