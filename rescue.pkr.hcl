variables {
  vnc_bind_address = "0.0.0.0"
  vnc_port_max     = "5920"
  vnc_port_min     = "5920"
  accelerator      = "kvm"
  headless         = "true"
  output_dir       = "../output/"
  qemu_disk_cache  = "writeback"
  qemu_format      = "qcow2"
  boot_wait        = "15s"
  disk_compression = true
  disk_discard     = "unmap"
  arc              = "x86_64"
  disk_interface   = "virtio"
  format           = "qcow2"
  net_device       = "virtio-net"
  config_folder    = "config/"
  ssh_username     = "root"
  ssh_password     = "L=hD6!rf<4x{[$^@rDt9wTbp8?28)}"
  ssh_wait_timeout = "60m"
  cpu              = "4"
  ram              = "2048"
}

source "qemu" "alpine-3-22-x86_64" {
  accelerator  = var.accelerator
  boot_command = [
    "<wait5>",
    "root<enter><wait>",
    "ifconfig eth0 up && udhcpc -i eth0<enter><wait5>",
    "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.config_folder}rescue-alpine-3-22/http/answers<enter><wait>",
    "setup-apkrepos -1<enter><wait5>",
    "ERASE_DISKS='/dev/vda' setup-alpine -f $PWD/answers<enter><wait5>",
    "${var.ssh_password}<enter><wait>",
    "${var.ssh_password}<enter><wait10>",
    "mount /dev/vda2 /mnt<enter>",
    "echo 'PermitRootLogin yes' >> /mnt/etc/ssh/sshd_config<enter>",
    "apk add bash<enter><wait5>",
    "umount /mnt ; reboot<enter>"
  ]

  boot_wait        = var.boot_wait
  disk_compression = var.disk_compression
  disk_discard     = var.disk_discard
  disk_interface   = var.disk_interface
  disk_size        = "600"
  format           = var.format
  headless         = var.headless
  http_directory   = "."
  iso_checksum     = "sha256:c935c3715c80ca416e2ce912c552f0cbfd8531219b7973ae4a600873c793eb1b"
  iso_url          = "https://dl-cdn.alpinelinux.org/alpine/v3.22/releases/x86_64/alpine-virt-3.22.0-x86_64.iso"
  output_directory = "${var.output_dir}alpine-3-22-x86_64"
  net_device       = var.net_device
  qemuargs         = [["-m", "${var.ram}M"], ["-smp", "${var.cpu}"]]
  shutdown_command = "poweroff"
  vm_name          = "rescue-alpine-3-22-x86_64-virtfusion.qcow2"
  ssh_password     = var.ssh_password
  ssh_username     = var.ssh_username
  ssh_wait_timeout = var.ssh_wait_timeout
  vnc_bind_address = var.vnc_bind_address
  vnc_port_min     = var.vnc_port_min
  vnc_port_max     = var.vnc_port_max
}

build {
  sources = [
    "source.qemu.alpine-3-22-x86_64"
  ]

  provisioner "shell" {
    only             = ["qemu.alpine-3-22-x86_64"]
    valid_exit_codes = [0, 1]
    scripts          = ["./config/rescue-alpine-3-22/files/setup.sh"]
  }
}