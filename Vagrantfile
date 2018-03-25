Vagrant.configure("2") do |config|
  config.vm.define "master" do |master|
    master.vm.box = "CentOS7"
    master.vm.network "private_network", ip: "192.168.50.4"
    master.vm.provision :shell, inline: "echo 'root:root' | sudo chpasswd"
    config.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 4
    end
  end

  config.vm.define "slave" do |slave|
    slave.vm.box = "CentOS7"
    slave.vm.network "private_network", ip: "192.168.50.5"
    slave.vm.provision :shell, inline: "echo 'root:root' | sudo chpasswd"
    config.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 4
    end
  end
end
