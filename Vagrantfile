# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Ubuntu 서버에서 KVM/libvirt로 VM 3개 생성
# 사전 요구사항:
#   sudo apt install -y vagrant vagrant-libvirt qemu-kvm libvirt-daemon-system
#   sudo usermod -aG libvirt $USER  (재로그인 필요)

Vagrant.configure("2") do |config|
  config.vm.box      = "generic/ubuntu2204"
  config.vm.box_check_update = false

  nodes = [
    { name: "master",   ip: "192.168.121.10", cpu: 2, mem: 4096 },
    { name: "worker-1", ip: "192.168.121.11", cpu: 2, mem: 2048 },
    { name: "worker-2", ip: "192.168.121.12", cpu: 2, mem: 2048 },
  ]

  nodes.each do |node|
    config.vm.define node[:name] do |vm_config|
      vm_config.vm.hostname = node[:name]
      vm_config.vm.network "private_network", ip: node[:ip]

      vm_config.vm.provider "libvirt" do |lv|
        lv.driver  = "kvm"
        lv.cpus    = node[:cpu]
        lv.memory  = node[:mem]
      end

      # ubuntu 유저 SSH 키 인증 허용
      vm_config.vm.provision "shell", inline: <<-SHELL
        if ! id -u ubuntu &>/dev/null; then
          useradd -m -s /bin/bash ubuntu
        fi
        echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu
        mkdir -p /home/ubuntu/.ssh
        cp /home/vagrant/.ssh/authorized_keys /home/ubuntu/.ssh/authorized_keys
        chown -R ubuntu:ubuntu /home/ubuntu/.ssh
        chmod 700 /home/ubuntu/.ssh
        chmod 600 /home/ubuntu/.ssh/authorized_keys
      SHELL
    end
  end
end
