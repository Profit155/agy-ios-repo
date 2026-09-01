[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
    [string] $DebPath
)

$ErrorActionPreference = 'Stop'
$repoRoot = $PSScriptRoot
$debsDir = Join-Path $repoRoot 'debs'
$packagesPath = Join-Path $repoRoot 'Packages'
$packagesGzipPath = Join-Path $repoRoot 'Packages.gz'
$releasePath = Join-Path $repoRoot 'Release'

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
    'Description: AGY packages for rootless jailbroken iOS'
)
[IO.File]::WriteAllText(
    $releasePath,
    ((($releaseHeader + $releaseIndex) -join "`n") + "`n"),
    $utf8NoBom
)

$wslTargetDeb = ConvertTo-WslPath $targetDeb
$packageName = (& wsl.exe dpkg-deb -f $wslTargetDeb Package).Trim()
$packageVersion = (& wsl.exe dpkg-deb -f $wslTargetDeb Version).Trim()
if ($LASTEXITCODE -ne 0) {
    throw 'dpkg-deb could not validate the package.'
}

Write-Output "Published locally: $packageName $packageVersion"
Write-Output "Package: $targetDeb"
Write-Output "Indexes: $packagesPath, $packagesGzipPath, $releasePath"
