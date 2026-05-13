# Loads environment variables from repo-root .env into the current process
# and runs the Spring Boot app using the Maven wrapper.

$ErrorActionPreference = 'Stop'

$envFile = Join-Path $PSScriptRoot '..\.env'
if (-not (Test-Path $envFile)) {
  Write-Error "No .env file found at: $envFile"
}

Get-Content $envFile | ForEach-Object {
  $line = $_.Trim()
  if ($line.Length -eq 0) { return }
  if ($line.StartsWith('#')) { return }

  $parts = $line.Split('=', 2)
  if ($parts.Count -ne 2) { return }

  $name = $parts[0].Trim()
  $value = $parts[1].Trim()

  if ($name.Length -eq 0) { return }

  # Do not echo values (may contain secrets)
  [Environment]::SetEnvironmentVariable($name, $value, 'Process')
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
Push-Location $repoRoot
try {
  .\mvnw.cmd spring-boot:run
} finally {
  Pop-Location
}
