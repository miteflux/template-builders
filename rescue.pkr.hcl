variables {
  vnc_bind_address      = "0.0.0.0"
  vnc_port_max          = "5920"
  vnc_port_min          = "5920"
  accelerator           = "kvm"
  headless              = "true"
  output_dir            = "../output/"
  qemu_disk_cache       = "writeback"
  qemu_format           = "qcow2"
  boot_wait             = "15s"
  disk_compression      = true
  disk_discard          = "unmap"
  arc                   = "x86_64"
  disk_interface        = "virtio"
  format                = "qcow2"
  net_device            = "virtio-net"
  config_folder         = "config/"
  ssh_username          = "root"
  ssh_password          = "L=hD6!rf<4x{[$^@rDt9wTbp8?28)}"
  ssh_wait_timeout      = "60m"
  cpu                   = "4"
  ram                   = "2048"
  iso_checksum_type     = "sha512"
  iso                = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.11.0-amd64-netinst.iso"
  iso_checksum       = "0921d8b297c63ac458d8a06f87cd4c353f751eb5fe30fd0d839ca09c0833d1d9934b02ee14bbd0c0ec4f8917dde793957801ae1af3c8122cdf28dde8f3c3e0da"
}

source "qemu" "debian-12-x86_64" {
  vm_name          = "debian-12-x86_64.qcow2"
  output_directory = "${var.output_dir}debian-12-x86_64"
  disk_size        = "2000"
  boot_command     = [
    "<esc><wait>", "auto <wait>",
    "console-keymaps-at/keymap=us <wait>",
    "console-setup/ask_detect=false <wait>", "debconf/frontend=noninteractive <wait>",
    "fb=false <wait>", "kbd-chooser/method=us <wait>", "keyboard-configuration/xkb-keymap=us <wait>",
    "locale=en_US <wait>", "netcfg/get_hostname=debian <wait>",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.config_folder}rescue/debian-12-x86-64/http/preseed.cfg <wait>",
    "<enter><wait>"
  ]
  boot_wait        = var.boot_wait
  disk_cache       = var.qemu_disk_cache
  accelerator      = var.accelerator
  disk_compression = var.disk_compression
  disk_discard     = var.disk_discard
  disk_interface   = var.disk_interface
  format           = var.format
  headless         = var.headless
  http_directory   = "."
  iso_checksum     = var.iso_12_checksum
  iso_urls         = [var.iso_12]
  net_device       = var.net_device
  qemuargs         = [["-m", "${var.ram}M"], ["-smp", "${var.cpu}"]]
  shutdown_command = "echo '${var.ssh_password}' | shutdown -P now"
  ssh_password     = var.ssh_password
  ssh_username     = var.ssh_username
  ssh_wait_timeout = var.ssh_wait_timeout
  vnc_bind_address = var.vnc_bind_address
  vnc_port_min     = var.vnc_port_min
  vnc_port_max     = var.vnc_port_max
}

build {
  sources = [
    "source.qemu.debian-12-x86_64"
  ]

  provisioner "shell" {
    only = ["qemu.debian-12-x86_64"]
    valid_exit_codes = [0, 1, 127]
    inline = [
      "apt-get -y install grub-efi parted cloud-init cloud-guest-utils",
      "grub-install --verbose --removable --no-uefi-secure-boot --efi-directory=/boot/efi/ --bootloader-id=BOOT --target=x86_64-efi /dev/vda",
      "sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet\"/GRUB_CMDLINE_LINUX_DEFAULT=\"net.ifnames=0 biosdevname=0 console=tty0 console=ttyS0,115200n8\"/' /etc/default/grub",
      "update-grub",
      "parted /dev/vda set 2 esp on",
      "parted /dev/vda set 2 boot on",
      "apt-get -y remove parted",
      "rm -rf /tmp/*",
      "rm -rf /var/tmp/*",
      "rm -rf /etc/ssh/*host*key*",
      "truncate -s 0 /etc/machine-id",
      "truncate -s 0 /var/log/auth.log",
      "truncate -s 0 /var/log/wtmp",
      "truncate -s 0 /var/log/lastlog",
      "truncate -s 0 /var/log/dpkg.log",
      "apt-get -y autoremove --purge",
      "/usr/bin/systemctl enable qemu-guest-agent",
      "apt-get clean",
      "rm -rf /usr/share/man/??",
      "rm -rf /usr/share/man/??_*",
      "echo \"source /etc/network/interfaces.d/*\" > /etc/network/interfaces",
      "sed -i -e \"s/^#\\?PasswordAuthentication.*/PasswordAuthentication no/g\" /etc/ssh/sshd_config",
      "dd if=/dev/zero of=/zeroed_file bs=1M oflag=direct || /bin/true",
      "rm -rf /zeroed_file",
      "sync",
      "passwd -d root",
      "passwd -l root",
      "history -c"
    ]
  }
}


