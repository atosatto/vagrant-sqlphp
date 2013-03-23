# Compatibile con Vagrant >= 1.1.0
#
# Author: Andrea Tosatto <andrea.tosy@gmail.com>

Vagrant.configure("2") do |config|
    
    config.vm.box = 'centos-63-64-puppet'
    config.vm.box_url = 'http://packages.vstone.eu/vagrant-boxes/centos/6.3/centos-6.3-64bit-puppet-vbox.4.2.6-2.box'
    
    ### Configurazione del numero di core e della RAM per la VM
    # config.vm.customize ["modifyvm", :id, "--memory", 2048, "--cpus", 2]

    ### Condivisione cartelle NFS (veloce) | Richiede nfs-utils  
    config.vm.synced_folder "data", "/home/vagrant/data", :nfs => true, :extra => 'dmode=777,fmode=777'
    
	### Configurazione per VirtualBox lente
	# config.ssh.max_tries = 50
 	# config.ssh.timeout   = 300
	
	### Puppet configuration
    config.vm.define :vagrant_web do |project_config|
        
        project_config.vm.hostname = "centos.tekarea.dev"
        project_config.vm.network :private_network, ip: "33.33.33.20"

        ### Pass installation procedure over to Puppet (see `manifests/project.pp`)
        project_config.vm.provision :puppet do |puppet|
            puppet.manifests_path = "manifests"
            puppet.module_path = "puppet-modules"
            puppet.manifest_file = "project.pp"
            puppet.options = [
                '--verbose',
            ]
        end
    end
end
