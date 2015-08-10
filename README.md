vagrant-sqlphp
===========

Vagrant VirtualMachine providing a Centos 6.5 + Nginx + MySQL + PHP webapp development stack.

Installation
------------
First of all be sure to have installed on your host machine the latest versions of
[Virtualbox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/).

Install the vagrant-hostsupdater plugin

	vagrant plugin install vagrant-hostsupdater

Then, clone this project

	git clone https://github.com/hilbert-/vagrant-sqlphp.git

The puppet modules dependencies are handled with [librarian-puppet](http://librarian-puppet.com/).
The gem is automatically installed on the guest VM using the vagrant's shell provisioner,
but if you would like to install it on the host you have to run

	gem install librarian-puppet

and download the required modules with

	librarian-puppet install

Usage
-----
You can startup the VM with

	vagrant up

To share folders or files with the VM, put them into the `<vagrant-mongophp-dir>/workspace`.
The directory is mounted via NFS into the `/home/vagrant/workspace` directory of the VM.

Contribute
----------
Contributions are welcome.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
