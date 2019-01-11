param(
    [ValidateSet('18.04')]
    [string]$version = '18.04',

    [ValidateSet('ubuntu-desktop-netboot', 'ubuntu-server-minimal')]
    [string]$varfile = 'ubuntu-desktop-netboot',

    [switch]$publish = $false
)

if (-not (Test-Path "$PSScriptRoot/bin"))
{
    New-Item -ItemType Directory "$PSScriptRoot/bin"
}

if (-not (Test-Path "$PSScriptRoot/bin/packer.exe"))
{
    Invoke-WebRequest -UseBasicParsing -Uri https://releases.hashicorp.com/packer/1.3.3/packer_1.3.3_windows_amd64.zip -OutFile "$PSScriptRoot/bin/packer.zip"
    Expand-Archive bin/packer.zip
    Unblock-File "$PSScriptRoot/bin/packer.exe"
}

if (-not (Test-Path "$PSScriptRoot/bin/jq.exe"))
{
    Invoke-WebRequest -UseBasicParsing -Uri https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe -OutFile "$PSScriptRoot/bin/jq.exe"
    Unblock-File "$PSScriptRoot/bin/jq.exe"
}

pip show awscli

if ($publish)
{
    &"$PSScriptRoot/bin/packer" build `
    -only=hyperv-iso `
    -force `
    -var-file="$PSScriptRoot/packer_templates/$version/$($varfile).json" `
    $PSScriptRoot/packer_templates/$version/ubuntu.vagrant-cloud.json
}
else
{
    &"$PSScriptRoot/bin/packer" build `
        -only=hyperv-iso `
        -force `
        -var-file="$PSScriptRoot/packer_templates/$version/$($varfile).json" `
        $PSScriptRoot/packer_templates/$version/ubuntu.json
}