# Packer build scripts for VirtFusion

This is **Miteflux's fork** of VirtFusion's template-builders. It adds support for **Windows Consumer Editions** (Windows 10/11 Pro Workstation via `windows.pkr.hcl`) and **Windows Server 2012 R2** (eval image in `windows-server.pkr.hcl`).

## Prepare templates on Debian 11/12

Install Debian 11/12 on a VM with at least 2GB RAM. Then run the following to prepare the environment.

```shell
apt-get install git curl unzip gnupg2 software-properties-common ansible -y
apt-get install --no-install-recommends qemu-system qemu-utils -y

git clone https://github.com/miteflux/template-builders
cd packer

wget https://releases.hashicorp.com/packer/1.10.0/packer_1.10.0_linux_amd64.zip
unzip packer_1.10.0_linux_amd64.zip

OR

wget https://releases.hashicorp.com/packer/1.10.0/packer_1.10.0_linux_arm64.zip
unzip packer_1.10.0_linux_arm64.zip

./packer plugins install github.com/hashicorp/qemu
./packer plugins install github.com/hashicorp/ansible

mkdir source
```

Once all the requirements are installed you may build a template.

## Building Images

### Linux
#### AlmaLinux

```shell
./packer build -only=qemu.base-9-x86_64 alma.pkr.hcl
./packer build -only=qemu.gnome-9-x86_64 alma.pkr.hcl
```

#### Rocky Linux

```shell
./packer build -only=qemu.base-9-x86_64 rocky.pkr.hcl
./packer build -only=qemu.gnome-9-x86_64 rocky.pkr.hcl
```

#### Debian 10

```shell
./packer build -only=qemu.base-10-x86_64 debian.pkr.hcl
```

#### Debian 11

```shell
./packer build -only=qemu.base-11-x86_64 debian.pkr.hcl
./packer build -only=qemu.xfce-11-x86_64 debian.pkr.hcl
```

#### Debian 12

```shell
./packer build -only=qemu.base-12-x86_64 debian.pkr.hcl
./packer build -only=qemu.base-12-ext4-x86_64 debian.pkr.hcl
./packer build -only=qemu.base-12-aarch64 debian.pkr.hcl
```

#### Debian 13

```shell
./packer build -only=qemu.base-13-x86_64 debian.pkr.hcl
./packer build -only=qemu.base-13-xfs-x86_64 debian.pkr.hcl
```

#### Oracle Linux

```shell
./packer build -only=qemu.base-9-x86_64 oracle.pkr.hcl
./packer build -only=qemu.base-uek-9-x86_64 oracle.pkr.hcl
```

#### CentOS (Stream)

```shell
./packer build -only=qemu.base-9-x86_64 centos.pkr.hcl
```

#### Alpine Linux 3.19

```shell
./packer build -only=qemu.base-3-19-x86_64 alpine.pkr.hcl
```

### Microsoft Windows
A script is supplied to download the evaluation versions of Windows Server and the VirtIO drivers (`windows-sources.sh`). This covers Server 2012 R2, 2019, 2022, 2025 eval ISOs and the VirtIO drivers.

**Windows 10 and Windows 11** do not have an automatic download script. Microsoft does not provide direct, scriptable ISO downloads for consumer editions. You must obtain the Windows 10/11 Pro Workstation (or equivalent) ISOs yourself and place them in `./source/`, then set the correct paths and checksums in `windows.pkr.hcl`.

```shell
sh windows-sources.sh
```

If you would like to build from retail media for any Server edition, you will need to supply the ISO images.

#### Server 2012 R2

```shell
./packer build -only=qemu.server-2012r2-standard-eval windows-server.pkr.hcl
``

#### Server 2019

```shell
./packer build -only=qemu.server-2019-standard windows-server.pkr.hcl
./packer build -only=qemu.server-2019-standard-eval windows-server.pkr.hcl
```

#### Server 2022

```shell
./packer build -only=qemu.server-2022-standard windows-server.pkr.hcl
./packer build -only=qemu.server-2022-standard-eval windows-server.pkr.hcl
```

#### Server 2025

```shell
./packer build -only=qemu.server-2025-standard windows-server.pkr.hcl
```

#### Windows 10 Pro Workstation & Windows 11 Pro Workstation

There is **no automatic download script** for Windows 10 or Windows 11. Microsoft restricts how these ISOs are distributed, so you must obtain the ISOs yourself (e.g. from [Microsoft's download pages](https://www.microsoft.com/software-download) or your volume-licensing portal), place them in `./source/`, and set the variables `windows_iso_10` / `windows_iso_11` and their checksums in `windows.pkr.hcl`.

```shell
./packer build -only=qemu.windows-10-pro-workstation windows.pkr.hcl
./packer build -only=qemu.windows-11-pro-workstation windows.pkr.hcl
```

Or build both:

```shell
./packer build windows.pkr.hcl
```

## Useful Windows Commands

### Remove Windows updates polices

```shell
reg delete HKEY_LOCAL_MACHINE\\Software\\Policies\\Microsoft\\Windows\\WindowsUpdate /f
```

### Disable Administrator Lockout Policy

```
secedit /export /cfg securityconfig.cfg
(Get-Content securityconfig.cfg).replace("AllowAdministratorLockout = 1", "AllowAdministratorLockout = 0") | Set-Content securityconfig.cfg
secedit /configure /db C:\Windows\security\local.sdb /cfg securityconfig.cfg /areas SECURITYPOLICY
Remove-Item securityconfig.cfg
```

