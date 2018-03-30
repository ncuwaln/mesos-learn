Vagrant.configure("2") do |config|
  (4..7).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.box = "CentOS7"
      node.vm.network "private_network", ip: "192.168.50.#{i}"
      node.vm.provision :shell, inline: "echo 'root:root' | sudo chpasswd"
      config.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus = 2
      end
    end
  end
end
