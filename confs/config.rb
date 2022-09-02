$server_ip = "192.168.42.110"
$worker_ip = "192.168.42.111"
$server_name = "lrorschaS"
$worker_name = "glormellSW"

$set_up_aliases = <<-SCRIPT
echo "alias k='kubectl'" >> /home/vagrant/.bashrc
echo "alias c='clear'" >> /home/vagrant/.bashrc
SCRIPT

unless Vagrant.has_plugin?("vagrant-vbguest")
    system('vagrant plugin install vagrant-vbguest --plugin-version=0.21')
    exit system('vagrant', *ARGV)
end