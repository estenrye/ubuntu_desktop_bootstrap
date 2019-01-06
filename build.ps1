param(
    [ValidateSet('18.04')]
    [string]$version = '18.04',

    [ValidateSet('ubuntu-desktop-netboot', 'ubuntu-server-minimal')]
    [string]$varfile = 'ubuntu-desktop-netboot',

    [switch]$publish = $false
)

if ($publish)
{
    &"$PSScriptRoot/bin/packer" build `
    -only=hyperv-iso `
    -force `
    -var-file="$PSScriptRoot/packer_templates/$version/$($varfile).json" `
    $PSScriptRoot/packer_templates/$version/ubuntu.vagrantcloud.json
}
else
{
    &"$PSScriptRoot/bin/packer" build `
        -only=hyperv-iso `
        -force `
        -var-file="$PSScriptRoot/packer_templates/$version/$($varfile).json" `
        $PSScriptRoot/packer_templates/$version/ubuntu.json
}