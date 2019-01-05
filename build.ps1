param(
    [ValidateSet('18.04')]
    [string]$version = '18.04',
    
    [ValidateSet('ubuntu-desktop-netboot', 'ubuntu-server-minimal')]
    [string]$varfile = 'ubuntu-desktop-netboot'
)
&"$PSScriptRoot/bin/packer" build `
    -only=hyperv-iso `
    -force `
    -var-file="$PSScriptRoot/packer_templates/$version/$($varfile).json" `
    $PSScriptRoot/packer_templates/$version/ubuntu.json