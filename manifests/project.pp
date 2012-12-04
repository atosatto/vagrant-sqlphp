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

### Nginx
class { "nginx": 
	require	=> Class['yum::repo::nginx'],
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
package {['nano', 'yum-utils', 'mlocate', 'git', 'curl', 'subversion-svn']:
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

### Aggiorno l'indice di ricerca
exec { "refresh_locate":
    command => "updatedb",
    require	=> Package['mlocate'],
}