# Ambiente di sviluppo con Vagrant #

## Installazione e aggiornamenti ##

Puoi scaricare tutti i file di vagrant con il comando:

	git clone --recursive https://asosso@bitbucket.org/asosso/vagrant-web.git

#### Aggiornamento submoduli ####
Per aggiornare i submoduli collegati:

	git pull origin master
	git submodule init
	git submodule update

Se vuoi forzare l'aggiornamento di ciascun submodulo, anche se non è tracciato nel repository principale:

	git submodule foreach git pull origin master
        
## File hosts ##

#### Linux / MacOS X (Automatico) #### 
Installare vagrant hostmaster con il comando

	vagrant plugin install vagrant-hostsupdater

Sostituire il file *Vagrantfile* con *Vagrantfile.LinuxHost*

#### Linux / MacOS X (Manuale) ####
Modificare il file /etc/hosts ad esempio con 

	sudo nano /etc/hosts 

e inserire il seguente virtualhost:

	33.33.33.10	pma.dev

#### Windows (solo manuale) ####
Aggiungere alla file: *C:\Windows\System32\Driver\etc\hosts*

	33.33.33.10	pma.dev

## Avviare la macchina virtuale ##
Copiare la configurazione di default di vagrant con il comando:

	cp Vagrantfile.default Vagrantfile

Controlla di avere [virtualbox](http://download.virtualbox.org/virtualbox/4.2.4/ "Virtualbox 4.2.4") e lanciare vagrant con il comando:

	vagrant up
		
Questo comando esegue molte operazioni:

* Scarica il sistema operativo
* Installa il sistema operativo su una macchina virtualbox
* Avvia la macchina virtuale
* Provisioning dell'ambiente tramite puppet

Per avviare la macchina virtuale senza il provisioning di puppet usare il comando

	vagrant up --no-provision

## Supporto NFS (Linux / MacOS X) ##
La condivisione delle cartelle nativa di VirtualBox è decisamente lenta rispetto al Network File System (NFS)

Una volta che nfs-utils è stato installato nella macchina guest è possibile abilitare l'NFS nel vagrantfile:

Commentando 

	# config.vm.share_folder("v-data", "/home/vagrant/data", "data", :nfs => false)

Decommentando

	config.vm.share_folder("v-data", "/home/vagrant/data", "data", :nfs => true, :extra => 'dmode=777,fmode=777')
	
Per semplicit&agrave; si pu&ograve; sostituire *Vagrantfile* con *VagrantFile.LinuxHostNFS*

Se non &egrave; ancora stato installato nfs-utils al primo boot con **vagrant up** viene visualizzato un messaggio d'errore sul mounting NFS. A questo punto &egrave necessario far eseguire comunque puppet e riaviare la macchina:

	vagrant provision
	vagrant reload


## Accesso a phpMyAdmin ##
* [http://pma.dev/](http://pma.dev/ "pma.dev")


=======
Vagrant-web
===========

Vagrant VirtualMachine providing a Centos 6.3 + Nginx + Mysql + PHP webapp development stack.

Installation
------------
First of all be sure to have installed on your host machine the latest versions of [Virtualbox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/).

Install the vagrant-hostsupdater plugin with

	vagrant plugin install vagrant-hostsupdater

Then, clone this project with:

	git clone https://asosso@bitbucket.org/asosso/vagrant-web.git

And finally init the submodule needed for the provisioning of all the VM configurations.

	git submodule init

	git submodule update
	

Usage
-----

You can startup the VM with 
	
	vagrant up
	
If you see an error similar to this one
	
	[vagrant_web] Mounting NFS shared folders...
	The following SSH command responded with a non-zero exit status.
	Vagrant assumes that this means the command failed!

	mount -o vers=3 33.33.33.1:'/Users/andrea/Documents/Sviluppo/vagrant-vms/vagrant-web/data' /home/vagrant/data
	
you have to execute
	
	vagrant provision
	vagrant reload
	
since it is caused by the fact that nfs is not installed on the virtual machine.
This will be installed during the provisioning.

To share folders or files with the VM you have simply to put them into the `<vagrant-web-path>/data`. In fact this directory is mounted via NFS on the `/home/vagrant/data` directory of the VM.

To access to the VM's **PhpMyAdmin** write this in your browser [http://pma.dev/](http://pma.dev/ "pma.dev")!

Contribute
----------
Contributions are welcome.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request