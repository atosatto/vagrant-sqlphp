# Author: Andrea Tosatto <andrea.tosy@gmail.com>

### Require plugins
require 'vagrant-hostsupdater'

Vagrant.configure("2") do |config|

  config.vm.box = 'puppetlabs/centos-7.0-64-puppet'

  ### VM Specs customization
  config.vm.provider :virtualbox do |vb|
    vb.name = "Vagrant SQLPHP"
    vb.customize ["modifyvm", :id, "--memory", "2048", "--cpus", 2]
  end

  ### NFS shared folder | Require nfs-utils
  config.vm.synced_folder "workspace", "/home/vagrant/workspace", :nfs => true, mount_options: ['rw', 'vers=3', 'tcp', 'fsc' ,'actimeo=2

  ### Puppet configuration
  config.vm.define :vagrant_sqlphp do |project|

    project.vm.hostname = "sqlphp.vagrant.dev"
    project.vm.network :private_network, ip: "33.33.33.10"

    # VM hostname aliases | Require vagrant-hostsupdater (https://github.com/cogitatio/vagrant-hostsupdater)
    project.hostsupdater.aliases = ["pma.dev", "corsodijoomla.dev"]

    ### Install librarian-puppet
    project.vm.provision :shell do |shell|
      shell.inline = "sudo gem install librarian-puppet; cd /vagrant; /usr/local/bin/librarian-puppet install"
    end

    ### Pass installation procedure over to Puppet (see `manifests/vagrant_sqlphp.pp`)
    project.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.module_path = "modules"
      puppet.manifest_file = "vagrant_sqlphp.pp"
      puppet.options = [
        '--verbose',
      ]
    end
  end
end
