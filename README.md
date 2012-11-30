# Ambiente di sviluppo con Vagrant #

## Installazione e aggiornamenti ##

Puoi scaricare tutti i file di vagrant con il comando:

	git clone --recursive git@github.com:iAndre89/vagrant-web.git

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

	vagrant gem install vagrant-hostmaster

Sostituire il file *Vagrantfile* con *Vagrantfile.LinuxHost*

#### Linux / MacOS X (Manuale) ####
Modificare il file /etc/hosts ad esempio con 

	sudo nano /etc/hosts 

e inserire il seguente virtualhost:

	127.0.0.1	pma.dev

#### Windows (solo manuale) ####
Aggiungere alla file: *C:\Windows\System32\Driver\etc\hosts*

	127.0.0.1	pma.dev

## Avviare la macchina virtuale ##
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
La condivisione delle cartelle nativa di Dropox è decisamente lenta rispetto al Network File System (NFS)

Una volta che nfs-utils è stato installato nella macchina guest è possibile abilitare l'NFS nel vagrantfile:

Commentando 

	# config.vm.share_folder("v-data", "/home/vagrant/data", "data", :nfs => false)

Decommentando

	config.vm.share_folder("v-data", "/home/vagrant/data", "data", :nfs => true, :extra => 'dmode=777,fmode=777')
	
Per semplicit&agrave; si pu&ograve; sostituire *Vagrantfile* con *VagrantFile.LinuxHostNFS*

## Accesso a phpMyAdmin ##
* [http://pma.dev/](http://pma.dev/ "pma.dev")