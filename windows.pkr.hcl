variables {
  vnc_bind_address        = "0.0.0.0"
  vnc_port_max            = "5920"
  vnc_port_min            = "5920"
  winrm_timeout           = "12h"
  winrm_use_ssl           = "true"
  winrm_insecure          = "true"
  accelerator             = "kvm"
  headless                = "true"
  restart_timeout         = "5m"
  shutdown_timeout        = "15m"
  output_dir              = "../output"
  windows_user            = "Administrator"
  windows_password        = "SVDMV#tcV2MWrr#WUZMv"
  windows_virtio_driver   = "./source/virtio-win.iso"
  windows_cpus            = "4"
  windows_memory          = "3072"
  qemu_disk_cache         = "writeback"
  qemu_format             = "qcow2"

  # Windows 10 Pro Workstation — set path and checksum for your ISO
  windows_iso_10          = "./source/windows-10.iso"
  windows_iso_10_checksum = "sha256:0000000000000000000000000000000000000000000000000000000000000000"

  # Windows 11 Pro Workstation — set path and checksum for your ISO
  windows_iso_11          = "./source/windows-11.iso"
  windows_iso_11_checksum = "sha256:0000000000000000000000000000000000000000000000000000000000000000"
}

source "qemu" "windows-10-pro-workstation" {
  disk_size    = "80000"
  communicator = "winrm"

  floppy_files = [
    "./config/windows-shared/scripts/*",
    "./config/windows-10-pro-workstation/files/*",
    "./config/windows-shared/patches/cloudinit/windows.py"
  ]
  output_directory = "${var.output_dir}/windows-10-pro-workstation"

  qemuargs = [
    ["-m", "${var.windows_memory}M"],
    ["-smp", var.windows_cpus],
    ["-drive", "file=${var.windows_iso_10},media=cdrom,index=2"],
    ["-drive", "file=${var.windows_virtio_driver},media=cdrom,index=3"],
    [
      "-drive",
      "file=${var.output_dir}/windows-10-pro-workstation/windows-10-pro-workstation.qcow2,if=virtio,cache=writeback,discard=ignore,format=qcow2,index=1"
    ]
  ]

  shutdown_command  = "a:/sysprep.bat"
  vm_name           = "windows-10-pro-workstation.qcow2"
  disk_cache        = var.qemu_disk_cache
  accelerator       = var.accelerator
  headless          = var.headless
  iso_checksum      = var.windows_iso_10_checksum
  iso_urls          = [var.windows_iso_10]
  shutdown_timeout  = var.shutdown_timeout
  format            = var.qemu_format
  vnc_bind_address  = var.vnc_bind_address
  vnc_port_min      = var.vnc_port_min
  vnc_port_max      = var.vnc_port_max
  winrm_insecure    = var.winrm_insecure
  winrm_password    = var.windows_password
  winrm_timeout     = var.winrm_timeout
  winrm_use_ssl     = var.winrm_use_ssl
  winrm_username    = var.windows_user
}

source "qemu" "windows-11-pro-workstation" {
  disk_size    = "80000"
  communicator = "winrm"

  floppy_files = [
    "./config/windows-shared/scripts/*",
    "./config/windows-11-pro-workstation/files/*",
    "./config/windows-shared/patches/cloudinit/windows.py"
  ]
  output_directory = "${var.output_dir}/windows-11-pro-workstation"

  qemuargs = [
    ["-m", "${var.windows_memory}M"],
    ["-smp", var.windows_cpus],
    ["-drive", "file=${var.windows_iso_11},media=cdrom,index=2"],
    ["-drive", "file=${var.windows_virtio_driver},media=cdrom,index=3"],
    [
      "-drive",
      "file=${var.output_dir}/windows-11-pro-workstation/windows-11-pro-workstation.qcow2,if=virtio,cache=writeback,discard=ignore,format=qcow2,index=1"
    ]
  ]

  shutdown_command  = "a:/sysprep.bat"
  vm_name           = "windows-11-pro-workstation.qcow2"
  disk_cache        = var.qemu_disk_cache
  accelerator       = var.accelerator
  headless          = var.headless
  iso_checksum      = var.windows_iso_11_checksum
  iso_urls          = [var.windows_iso_11]
  shutdown_timeout  = var.shutdown_timeout
  format            = var.qemu_format
  vnc_bind_address  = var.vnc_bind_address
  vnc_port_min      = var.vnc_port_min
  vnc_port_max      = var.vnc_port_max
  winrm_insecure    = var.winrm_insecure
  winrm_password    = var.windows_password
  winrm_timeout     = var.winrm_timeout
  winrm_use_ssl     = var.winrm_use_ssl
  winrm_username    = var.windows_user
}

build {
  sources = [
    "source.qemu.windows-10-pro-workstation",
    "source.qemu.windows-11-pro-workstation",
  ]

  provisioner "windows-shell" {
    inline = [
      "reg add \"HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsUpdate\\AU\" /v AUOptions /t REG_DWORD /d 7 /f"
    ]
  }

  provisioner "powershell" {
    scripts = ["./config/windows-shared/scripts/debloat-windows.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "${var.restart_timeout}"
  }

  provisioner "windows-shell" {
    execute_command = "{{ .Vars }} cmd /c \"{{ .Path }}\""
    scripts         = [
      "./config/windows-shared/scripts/set-winrm-automatic.bat",
      "./config/windows-shared/scripts/compact.bat"
    ]
  }

  provisioner "powershell" {
    scripts = ["./config/windows-shared/scripts/cleanup.ps1"]
  }
}
