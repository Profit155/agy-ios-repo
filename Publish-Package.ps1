[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
    [string] $DebPath,

    [string] $GpgHome = $env:AGY_REPO_GNUPGHOME,

    [string] $SigningKey = '1DF06A152EC4BE9DAF2DF3180B805B0C8D420541'
)

$ErrorActionPreference = 'Stop'
$repoRoot = $PSScriptRoot
$debsDir = Join-Path $repoRoot 'debs'
$packagesPath = Join-Path $repoRoot 'Packages'
$packagesGzipPath = Join-Path $repoRoot 'Packages.gz'
$releasePath = Join-Path $repoRoot 'Release'
$inReleasePath = Join-Path $repoRoot 'InRelease'
$releaseSignaturePath = Join-Path $repoRoot 'Release.gpg'
$publicKeyPath = Join-Path $repoRoot 'agy-ios-repo-key.gpg'

if (-not $GpgHome) {
    $GpgHome = Join-Path $HOME '.agy-ios-repo\gnupg'
}
$resolvedGpgHome = [IO.Path]::GetFullPath($GpgHome)
if (-not (Test-Path -LiteralPath $resolvedGpgHome -PathType Container)) {
    throw "Repository signing keyring not found: $resolvedGpgHome"
}

$gpgCommand = Get-Command gpg -ErrorAction SilentlyContinue
if ($gpgCommand) {
    $gpg = $gpgCommand.Source
}
elseif (Test-Path -LiteralPath 'C:\Program Files\Git\usr\bin\gpg.exe') {
    $gpg = 'C:\Program Files\Git\usr\bin\gpg.exe'
}
else {
    throw 'gpg was not found; install GnuPG or Git for Windows'
}

function ConvertTo-GpgPath([string] $WindowsPath) {
    $fullPath = [IO.Path]::GetFullPath($WindowsPath).Replace('\', '/')
    if ($gpg -like '*\Git\usr\bin\gpg.exe' -and
        $fullPath -match '^([A-Za-z]):/(.*)$') {
        return "/$($Matches[1].ToLowerInvariant())/$($Matches[2])"
    }
    return $fullPath
}

$gpgHomeArgument = ConvertTo-GpgPath $resolvedGpgHome
$secretKeyListing = @(& $gpg --batch --homedir $gpgHomeArgument --with-colons --list-secret-keys $SigningKey)
if ($LASTEXITCODE -ne 0 -or -not ($secretKeyListing -match "^fpr:::::::::$SigningKey`:$")) {
    throw "Secret signing key $SigningKey was not found in $resolvedGpgHome"
}
if (-not (Test-Path -LiteralPath $publicKeyPath -PathType Leaf)) {
    throw "Repository public key not found: $publicKeyPath"
}

New-Item -ItemType Directory -Force -Path $debsDir | Out-Null

$sourceDeb = (Resolve-Path -LiteralPath $DebPath).Path
$targetDeb = Join-Path $debsDir ([IO.Path]::GetFileName($sourceDeb))
Copy-Item -LiteralPath $sourceDeb -Destination $targetDeb -Force

function ConvertTo-WslPath([string] $WindowsPath) {
    $portablePath = $WindowsPath -replace '\\', '/'
    return (& wsl.exe wslpath -a -u $portablePath).Trim()
}

$wslRepoRoot = ConvertTo-WslPath $repoRoot
if ($LASTEXITCODE -ne 0 -or -not $wslRepoRoot) {
    throw 'Could not convert the repository path for WSL.'
}

$packageIndex = @(& wsl.exe --cd $wslRepoRoot apt-ftparchive packages debs)
if ($LASTEXITCODE -ne 0) {
    throw 'apt-ftparchive failed while generating Packages.'
}

$utf8NoBom = [Text.UTF8Encoding]::new($false)
[IO.File]::WriteAllText($packagesPath, (($packageIndex -join "`n") + "`n"), $utf8NoBom)

$inputStream = [IO.File]::OpenRead($packagesPath)
try {
    $outputStream = [IO.File]::Create($packagesGzipPath)
    try {
        $gzipStream = [IO.Compression.GZipStream]::new(
            $outputStream,
            [IO.Compression.CompressionLevel]::SmallestSize
        )
        try {
            $inputStream.CopyTo($gzipStream)
        }
        finally {
            $gzipStream.Dispose()
        }
    }
    finally {
        $outputStream.Dispose()
    }
}
finally {
    $inputStream.Dispose()
}

foreach ($oldMetadata in @($releasePath, $inReleasePath, $releaseSignaturePath)) {
    if (Test-Path -LiteralPath $oldMetadata) {
        Remove-Item -LiteralPath $oldMetadata -Force
    }
}
$releaseIndex = @(& wsl.exe --cd $wslRepoRoot apt-ftparchive release .)
if ($LASTEXITCODE -ne 0) {
    throw 'apt-ftparchive failed while generating Release.'
}

$releaseHeader = @(
    'Origin: AGY iOS Port'
    'Label: AGY iOS Port'
    'Suite: stable'
    'Codename: stable'
    'Architectures: iphoneos-arm64'
    'Components:'
    'Description: AGY packages for rootless jailbroken iOS'
)
[IO.File]::WriteAllText(
    $releasePath,
    ((($releaseHeader + $releaseIndex) -join "`n") + "`n"),
    $utf8NoBom
)

Push-Location $repoRoot
try {
    & $gpg --batch --yes --homedir $gpgHomeArgument --local-user $SigningKey `
        --digest-algo SHA256 --clearsign --output InRelease Release
    if ($LASTEXITCODE -ne 0) {
        throw 'gpg failed while creating InRelease.'
    }
    & $gpg --batch --yes --homedir $gpgHomeArgument --local-user $SigningKey `
        --digest-algo SHA256 --detach-sign --output Release.gpg Release
    if ($LASTEXITCODE -ne 0) {
        throw 'gpg failed while creating Release.gpg.'
    }
    & $gpg --batch --homedir $gpgHomeArgument --verify InRelease
    if ($LASTEXITCODE -ne 0) {
        throw 'gpg could not verify InRelease.'
    }
    & $gpg --batch --homedir $gpgHomeArgument --verify Release.gpg Release
    if ($LASTEXITCODE -ne 0) {
        throw 'gpg could not verify Release.gpg.'
    }
}
finally {
    Pop-Location
}

$wslTargetDeb = ConvertTo-WslPath $targetDeb
$packageName = (& wsl.exe dpkg-deb -f $wslTargetDeb Package).Trim()
$packageVersion = (& wsl.exe dpkg-deb -f $wslTargetDeb Version).Trim()
if ($LASTEXITCODE -ne 0) {
    throw 'dpkg-deb could not validate the package.'
}

Write-Output "Published locally: $packageName $packageVersion"
Write-Output "Package: $targetDeb"
Write-Output "Indexes: $packagesPath, $packagesGzipPath, $releasePath"
Write-Output "Signatures: $inReleasePath, $releaseSignaturePath"
Write-Output "Signing key: $SigningKey"
