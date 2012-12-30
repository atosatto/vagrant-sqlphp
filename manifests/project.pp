# Author: Andrea Sosso <andrea@sosso.me>

Exec { 
	path => ['/usr/local/bin/:/bin/:/usr/bin/'],
}

### Gestione dell'utente 
user { 'vagrant':
	ensure	=> present,
	groups	=> ['nginx'],
	require	=> Package['nginx'],
	notify  => [Service["nginx"], Service["php-fpm"]], 
}

user { 'nginx':
	ensure	=> present,
	groups	=> ['vagrant'],
	require	=> Package['nginx'],
	notify  => [Service["nginx"], Service["php-fpm"]], 
}

file { "/home/vagrant/tmp":
    ensure	=> "directory",
    mode	=> 777,
}

file { "/home/vagrant/logs":
    ensure	=> "directory",
    mode	=> 700,
}

file { "/home/vagrant":
    ensure	=> "directory",
    mode	=> 755,
}

### YUM e repository
class { 'yum':
	 extrarepo => ['nginx', 'remi', 'remi-test', 'epel'],	 
}

package { "nginx":
	require	=> Class['yum::repo::nginx'],
}

package {"gcc-c++":
	ensure	=> "installed",
}

service { "nginx":
	enable => true,
	ensure => "running",
	require	=> Package['nginx'],
}

file { '/etc/nginx/nginx.conf':
	ensure	=> file,
	mode	=> 600,
	source	=> 'puppet:///modules/tekarea/nginx.conf',
	require	=> Package['nginx'],
	notify  => Service["nginx"], 
}

### Mysql
class { "mysql": }

### phpMyAdmin
package {'phpMyAdmin': 
	ensure  => latest,
	require	=> Class['yum::repo::remi'],
}

file { '/etc/nginx/conf.d/pma.conf':
	ensure	=> file,
	mode	=> 600,
	source	=> 'puppet:///modules/tekarea/pma.conf',
	require	=> [Package['phpMyAdmin'], Package['nginx']],
	notify  => Service["nginx"], 
}

file { '/etc/phpMyAdmin/config.inc.php':
	ensure	=> file,
	mode	=> 644,
	source	=> 'puppet:///modules/tekarea/config.inc.php',
	require	=> Package['phpMyAdmin'],
}

### PHP-FPM
package {'php-fpm':
	ensure	=> latest, 
	require	=> Class['yum::repo::remi'],
}

package { ["php-common", "php", "php-pecl-apc", "php-cli", "php-pear", "php-mysqlnd", "php-pdo", "php-gd", "php-mbstring", "php-xml", "php-imap", "php-mcrypt", "mcrypt", "php-intl", "php-devel", "php-soap"]: 
	ensure => latest,
	require	=> [Package['php-fpm'], Class['yum::repo::epel']],
}

service { 'php-fpm': 
	 enable => true,
	 ensure => "running",
	 require	=> Package['php-fpm'],
}

file { '/etc/php-fpm.d/vagrant.pool.conf':
	ensure	=> file,
	mode	=> 600,
	source	=> 'puppet:///modules/tekarea/vagrant.pool.conf',
	require	=> Package['php-fpm'],
	notify  => Service["php-fpm"], 
}

file { '/etc/php.ini':
	ensure	=> file,
	mode	=> 600,
	source	=> 'puppet:///modules/tekarea/php.ini',
	require	=> Package['php-fpm'],
	notify  => Service["php-fpm"], 
}

### Network File Sistem
package {'nfs-utils':
	ensure  => latest,
}

### Pacchetti utili
package {['nano', 'vim-enhanced', 'yum-utils', 'mlocate', 'git', 'curl', 'subversion']:
	ensure => latest, 
}

### Java (utilizzato da assetic)
package {'java-1.7.0-openjdk':
	ensure	=> latest,
	require	=> Class['yum'],
}

### Installazione di composer.phar nella cartella /bin
exec { "install_composer":
    command => "curl -s https://getcomposer.org/installer | php -- --install-dir=/bin",
    require => [Package['curl'], Package['php']],
    creates => "/bin/composer.phar",
}

### Installazione di phpUnit nella cartella /usr/bin
exec { "install_phpUnit":
    command => "wget --output-document=/usr/bin/phpunit.phar http://pear.phpunit.de/get/phpunit.phar && chmod +x /usr/bin/phpunit.phar",
    require => [Package['php'], Package['php-pear']],
    creates => "/usr/bin/phpunit.phar",
}


### Messaggio di benvenuto
host {'self':
	ensure => present,
	name => $fqdn,
	host_aliases => ['tekarea.dev', $hostname], ip => $ipaddress,
}

file {'motd':
	ensure => file,
	path => '/etc/motd',
	mode => 0644,
	content => "\n*** Tekarea development OS ***\n\nNome macchina: ${hostname}\nSistema operativo: ${operatingsystem}\nDominio: ${domain}\n\n\n",
}

exec { "nodejs":                                                                                                                     
	command => "git clone https://github.com/joyent/node.git /home/node/",
    creates => "/home/node/",                                                              
}

exec { "configure_node": 
	command => "/home/node/configure",
	cwd => "/home/node/",
	creates => "/home/node/config.mk",
	require => [Exec['nodejs'], Package['gcc-c++']],
}

exec { "make_node": 
	command => "make",
	cwd => "/home/node/",
	creates => "/home/node/out/Makefile",
	require => Exec['configure_node'],
}

exec { "install_node": 
	command => "make install",
	cwd => "/home/node/",
	creates => "/usr/local/bin/node",
	require => Exec['make_node'],
}


exec { "get_npmjs": 
	command => "wget --no-check-certificate https://npmjs.org/install.sh",
	cwd => "/home/node",
	creates => "/home/node/install.sh",
	require => [Exec['install_node'], File['/usr/bin/node'], File['/usr/bin/npm']],
}

file {"/home/node/install.sh": 
	ensure	=> present,
	mode	=> 755,
	require => Exec['get_npmjs'],
}

exec { "install_npmjs":
	command => "/home/node/install.sh",
	creates => "/usr/lib/node_modules/npm/bin/npm-cli.js",
	require => File["/home/node/install.sh"],
}

exec { "install_less":
	command => "npm install less -g",
	creates => "/usr/local/bin/lessc",
	require => Exec["install_npmjs"],
}

exec { "install_shift": 
	command => "npm install shift",
	cwd	=> "/usr/local/lib",
	creates => "/usr/local/lib/node_modules/shift/",
	require => Exec["install_npmjs"],
}




file {'/usr/bin/node':
	ensure => 'link',
	target => '/usr/local/bin/node',
	require => Exec['install_node'],
}

file {'/usr/bin/npm':
	ensure => 'link',
	target => '/usr/local/bin/npm',
	require => Exec['install_node'],
}

### Selinux
	case $operatingsystem {
		centos: {
      package {['bind-utils']: 
                ensure => installed,
      }
			file { "/etc/selinux/config":
				ensure	=> file,
				source	=> 'puppet:///modules/tekarea/selinux.cfg',
				owner => root,
				group => root,
				notify => Exec["disable_selinux"], 
			}
      		
      exec { "disable_selinux":
    			command		=> "setenforce 0",
    			refreshonly	=> true,
    			path		=> "/usr/sbin", 
			}
		}
	}
