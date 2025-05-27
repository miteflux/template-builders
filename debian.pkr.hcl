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
  iso_10                = "https://cdimage.debian.org/cdimage/archive/10.13.0/amd64/iso-cd/debian-10.13.0-amd64-netinst.iso"
  iso_10_checksum       = "466add7fb5ba7caebd27bf6b8b326a24857295673045d643950869f5f0440c44ae833dea49c7b8a674afbf82c3f41ceb5062948aea443d581bc827db62cc5249"
  iso_11                = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.6.0-amd64-netinst.iso"
  iso_11_checksum       = "224cd98011b9184e49f858a46096c6ff4894adff8945ce89b194541afdfd93b73b4666b0705234bd4dff42c0a914fdb6037dd0982efb5813e8a553d8e92e6f51"
  iso_12                = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.9.0-amd64-netinst.iso"
  iso_12_checksum       = "1257373c706d8c07e6917942736a865dfff557d21d76ea3040bb1039eb72a054"
  iso_12_arm            = "https://cdimage.debian.org/debian-cd/current/arm64/iso-cd/debian-12.5.0-arm64-netinst.iso"
  iso_12_arm_checksum   = "14c2ca243ee7f6e447cc4466296d974ee36645c06d72043236c3fbea78f1948d3af88d65139105a475288f270e4b636e6885143d01bdf69462620d1825e470ae"
  iso_13                = "https://cdimage.debian.org/cdimage/trixie_di_rc1/amd64/iso-cd/debian-trixie-DI-rc1-amd64-netinst.iso"
  iso_13_checksum       = "2cf9e35f8cd135fa858ff89f0447d0b5e0c2b51da372196bd078eee47ef1d262"
  iso_testing           = "https://cdimage.debian.org/cdimage/daily-builds/daily/20230422-3/amd64/iso-cd/debian-testing-amd64-netinst.iso"
  iso_testing_checksum  = "c1917d3caf56446f9fd5f02d2be1c8071da3defef8ca05ef2a867c9e1ebbeac1b47fcca429b5cbeb2cd98dde920b0e689652e775124026a73987c5b5f226801d"
  config_file_base      = "preseed-base.cfg"
  config_file_base_ext4 = "preseed-base-ext4.cfg"
  config_file_base_arm  = "preseed-base-arm.cfg"
  config_file_xfce      = "preseed-xfce.cfg"
}

source "qemu" "base-10-x86_64" {
  vm_name          = "debian-10-x86_64.qcow2"
  output_directory = "${var.output_dir}debian-10-x86_64"
  disk_size        = "2000"
  boot_command     = [
    "<esc><wait>", "auto <wait>",
    "console-keymaps-at/keymap=us <wait>",
    "console-setup/ask_detect=false <wait>", "debconf/frontend=noninteractive <wait>",
    "fb=false <wait>", "kbd-chooser/method=us <wait>", "keyboard-configuration/xkb-keymap=us <wait>",
    "locale=en_US <wait>", "netcfg/get_hostname=debian <wait>",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.config_folder}debian-10/http/${var.config_file_base} <wait>",
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
  iso_checksum     = var.iso_10_checksum
  iso_urls         = [var.iso_10]
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

source "qemu" "base-11-x86_64" {
  vm_name          = "debian-11-x86_64.qcow2"
  output_directory = "${var.output_dir}debian-11-x86_64"
  disk_size        = "2000"
  boot_command     = [
    "<esc><wait>", "auto <wait>",
    "console-keymaps-at/keymap=us <wait>",
    "console-setup/ask_detect=false <wait>", "debconf/frontend=noninteractive <wait>",
    "fb=false <wait>", "kbd-chooser/method=us <wait>", "keyboard-configuration/xkb-keymap=us <wait>",
    "locale=en_US <wait>", "netcfg/get_hostname=debian <wait>",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.config_folder}debian-11/http/${var.config_file_base} <wait>",
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
  iso_checksum     = var.iso_11_checksum
  iso_urls         = [var.iso_11]
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

source "qemu" "xfce-11-x86_64" {
  vm_name          = "debian-11-xfce-x86_64.qcow2"
  output_directory = "${var.output_dir}debian-11-xfce-x86_64"
  disk_size        = "5000"
  boot_command     = [
    "<esc><wait>", "auto <wait>",
    "console-keymaps-at/keymap=us <wait>",
    "console-setup/ask_detect=false <wait>", "debconf/frontend=noninteractive <wait>",
    "fb=false <wait>", "kbd-chooser/method=us <wait>", "keyboard-configuration/xkb-keymap=us <wait>",
    "locale=en_US <wait>", "netcfg/get_hostname=debian <wait>",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.config_folder}debian-11/http/${var.config_file_xfce} <wait>",
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
  iso_checksum     = var.iso_11_checksum
  iso_urls         = [var.iso_11]
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

source "qemu" "base-12-x86_64" {
  vm_name          = "debian-12-x86_64.qcow2"
  output_directory = "${var.output_dir}debian-12-x86_64"
  disk_size        = "2000"
  boot_command     = [
    "<esc><wait>", "auto <wait>",
    "console-keymaps-at/keymap=us <wait>",
    "console-setup/ask_detect=false <wait>", "debconf/frontend=noninteractive <wait>",
    "fb=false <wait>", "kbd-chooser/method=us <wait>", "keyboard-configuration/xkb-keymap=us <wait>",
    "locale=en_US <wait>", "netcfg/get_hostname=debian <wait>",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.config_folder}debian-12/http/${var.config_file_base} <wait>",
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

source "qemu" "base-12-ext4-x86_64" {
  vm_name          = "debian-12-ext4-x86_64.qcow2"
  output_directory = "${var.output_dir}debian-12--ext4-x86_64"
  disk_size        = "2000"
  boot_command     = [
    "<esc><wait>", "auto <wait>",
    "console-keymaps-at/keymap=us <wait>",
    "console-setup/ask_detect=false <wait>", "debconf/frontend=noninteractive <wait>",
    "fb=false <wait>", "kbd-chooser/method=us <wait>", "keyboard-configuration/xkb-keymap=us <wait>",
    "locale=en_US <wait>", "netcfg/get_hostname=debian <wait>",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.config_folder}debian-12/http/${var.config_file_base_ext4} <wait>",
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

source "qemu" "base-12-aarch64" {
  vm_name          = "debian-12-aarch64.qcow2"
  output_directory = "${var.output_dir}debian-12-aarch64"
  disk_size        = "2000"
  boot_command     = [
    "<wait10>c<wait5><wait10>",
    "linux /install.a64/vmlinuz",
    //"<esc><wait>", "auto <wait>",
    "<wait>", " auto <wait>",
    "console-keymaps-at/keymap=us <wait>",
    "console-setup/ask_detect=false <wait>", "debconf/frontend=noninteractive <wait>",
    "fb=false <wait>", "kbd-chooser/method=us <wait>", "keyboard-configuration/xkb-keymap=us <wait>",
    "locale=en_US <wait>", "netcfg/get_hostname=debian <wait>",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.config_folder}debian-12/http/${var.config_file_base_arm} <wait>",
    " ---",
    "<enter><wait>",
    "initrd /install.a64/initrd.gz",
    "<enter><wait>",
    "boot<enter><wait>",
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
  iso_checksum     = var.iso_12_arm_checksum
  iso_urls         = [var.iso_12_arm]
  net_device       = var.net_device
  qemu_binary      = "qemu-system-aarch64"
  machine_type     = "virt,gic-version=max"
  qemuargs         = [
    ["-m", "${var.ram}M"], ["-smp", "${var.cpu}"], ["-cpu", "max"], ["-boot", "strict=off"], ["-monitor", "none"],
    ["-bios", "/usr/share/qemu-efi-aarch64/QEMU_EFI.fd"]/*,["-device", "ramfb"]*/
  ]
  shutdown_command = "echo '${var.ssh_password}' | shutdown -P now"
  ssh_password     = var.ssh_password
  ssh_username     = var.ssh_username
  ssh_wait_timeout = var.ssh_wait_timeout
  vnc_bind_address = var.vnc_bind_address
  vnc_port_min     = var.vnc_port_min
  vnc_port_max     = var.vnc_port_max
}

source "qemu" "base-13-x86_64" {
  vm_name          = "debian-13-x86_64.qcow2"
  output_directory = "${var.output_dir}debian-13-x86_64"
  disk_size        = "2000"
  boot_command     = [
    "<esc><wait>", "auto <wait>",
    "console-keymaps-at/keymap=us <wait>",
    "console-setup/ask_detect=false <wait>", "debconf/frontend=noninteractive <wait>",
    "fb=false <wait>", "kbd-chooser/method=us <wait>", "keyboard-configuration/xkb-keymap=us <wait>",
    "locale=en_US <wait>", "netcfg/get_hostname=debian <wait>",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.config_folder}debian-13/http/${var.config_file_base} <wait>",
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
  iso_checksum     = var.iso_13_checksum
  iso_urls         = [var.iso_13]
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
    "source.qemu.base-10-x86_64", "source.qemu.base-11-x86_64", "source.qemu.xfce-11-x86_64",
    "source.qemu.base-12-x86_64","source.qemu.base-12-ext4-x86_64", "source.qemu.base-12-aarch64","source.qemu.base-13-x86_64"
  ]

  provisioner "ansible" {
    only             = ["qemu.base-10-x86_64"]
    ansible_env_vars = [
      "ANSIBLE_SSH_ARGS='-o ControlMaster=no -o ControlPersist=180s -o ServerAliveInterval=120s -o TCPKeepAlive=yes'"
    ]
    playbook_file = "./${var.config_folder}debian-10/ansible/tasks.yml"
  }

  provisioner "ansible" {
    only             = ["qemu.base-11-x86_64", "qemu.xfce-11-x86_64"]
    ansible_env_vars = [
      "ANSIBLE_SSH_ARGS='-o ControlMaster=no -o ControlPersist=180s -o ServerAliveInterval=120s -o TCPKeepAlive=yes'"
    ]
    playbook_file = "./${var.config_folder}debian-11/ansible/tasks.yml"
  }

  provisioner "ansible" {
    only             = ["qemu.base-12-x86_64"]
    ansible_env_vars = [
      "ANSIBLE_SSH_ARGS='-o ControlMaster=no -o ControlPersist=180s -o ServerAliveInterval=120s -o TCPKeepAlive=yes'"
    ]
    playbook_file = "./${var.config_folder}debian-12/ansible/tasks.yml"
  }

  provisioner "shell" {
    only             = ["qemu.base-12-ext4-x86_64"]
    valid_exit_codes = [0, 1, 127]
    inline           = [
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

  provisioner "shell" {
    only             = ["qemu.base-12-aarch64"]
    valid_exit_codes = [0, 1, 127]
    inline           = [
      "apt-get -y install cloud-init cloud-guest-utils",
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

  provisioner "ansible" {
    only             = ["qemu.base-13-x86_64"]
    ansible_env_vars = [
      "ANSIBLE_SSH_ARGS='-o ControlMaster=no -o ControlPersist=180s -o ServerAliveInterval=120s -o TCPKeepAlive=yes'"
    ]
    playbook_file = "./${var.config_folder}debian-13/ansible/tasks.yml"
  }
}