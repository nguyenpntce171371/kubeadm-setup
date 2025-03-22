NUM_MASTER_NODE = 1
NUM_WORKER_NODE = 2

IP_NW = "192.168.56."
MASTER_IP_START = 1
NODE_IP_START = 2

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"
  config.vm.box_check_update = false

  (1..NUM_MASTER_NODE).each do |i|
    config.vm.define "master" do |master|
      master.vm.hostname = "master#{i}"
      master.vm.network :private_network, ip: IP_NW + "#{MASTER_IP_START + i}"
      master.vm.provider "virtualbox" do |vb|
        vb.name = "master#{i}"
        vb.memory = "2048"
        vb.cpus = 2
      end
    end
  end
  

  (1..NUM_WORKER_NODE).each do |i|
    config.vm.define "worker#{i}" do |worker|
      worker.vm.hostname = "worker#{i}"
      worker.vm.network :private_network, ip: IP_NW + "#{NODE_IP_START + i}"
      worker.vm.provider "virtualbox" do |vb|
        vb.name = "worker#{i}"
        vb.memory = "2048"
        vb.cpus = 2
      end
    end
  end

end
