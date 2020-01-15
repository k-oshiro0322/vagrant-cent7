
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.vm.box = "bento/centos-7.4"
	
	# ID:vagrant PW:vagrant rootになる時は sudo su - (パスワードなし)
	
	# IPの設定
	config.vm.network "private_network", ip: "192.168.33.15"
	
	config.vm.provider :virtualbox do |vb|
		#メモリの設定
		vb.customize ["modifyvm", :id, "--memory", "4096", "--ostype", "RedHat_64"]
		
		#cpu数
		vb.cpus = 2
	end
	
	require 'rbconfig'
	is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
	if is_windows
		config.vm.provision "shell" do |sh|
			sh.path = "provisioning/provisioning.sh"
		end
	else
#		config.vm.provision "ansible" do |ansible|
#			ansible.playbook = "provisioning/main.yml"
#		end
	end
	

end