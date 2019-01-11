[![Build Status](https://dev.azure.com/estenrye/ubuntu-desktop-bootstrap/_apis/build/status/estenrye.ubuntu_desktop_bootstrap?branchName=master)](https://dev.azure.com/estenrye/ubuntu-desktop-bootstrap/_build/latest?definitionId=1?branchName=master)

# Initial Operating System Installation

1. On boot, select `Install Ubuntu`
2. Select `English` as the language.
3. Click Continue.
4. Accept the default keyboard configuration by clicking `Continue`.
5. Select `Minimal Installation`
6. Select `Install third-party software for graphics and Wi-Fi hardware and additional media formats`
7. Click Continue
8. Select `Erase disk and install Ubuntu`
9. Select `Use LVM with the new Ubuntu installation`
10. Click Install Now.
11. Click Continue.
12. Select timezone.
13. Click Continue.
14. Provide primary user's name.
15. Provide a name for the machine.
16. Provide a username for the primary user.
17. Select a password for the primary user.
18. Click Continue.

# Run Bootstrap

1. `sudo apt-add-repository ppa:ansible/ansible`
2. `sudo apt install -y ansible`
3. `ansible-playbook playbook.yml`


# Set up Build Environment

## Configure the AWS CLI profile
1. `aws configure --profile wasabi`
2. `aws configure --profile wasabi set s3.endpoint_url https://s3.wasabisys.com`

## Configure vagrant cloud token
1. `[System.Environment]::SetEnvironmentVariable('VAGRANT_CLOUD_TOKEN', 'vagrant-cloud-token', 'user')`

