yumrepo { 'epel':
  descr => 'epel repo',
  mirrorlist => 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch',
  enabled => 1,
  gpgcheck => 1,
  gpgkey => 'https://fedoraproject.org/static/0608B895.txt',
}

yumrepo {'remi':
  descr => 'Les RPM de remi pour Enterprise Linux $releasever $basearch',
  #baseurl => 'http://rpms.famillecollet.com/enterprise/$releasever/remi/$basearch/',
  mirrorlist => 'http://rpms.famillecollet.com/enterprise/$releasever/remi/mirror',
  enabled => 1,
  gpgcheck => 1,
  gpgkey => 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi',
}

$packages = ['php', 'php-pdo', 'php-mysql', 'php-mbstring', 'php-mcrypt']

package {$packages:
  ensure => present,
  before => File['/etc/php.ini'],
  require => Yumrepo['remi'],
}

file { '/etc/php.ini':
  ensure => present,
  owner => 'root',
  group => 'root',
  mode => '0644',
  content => template('php.ini'),
  require => Package['php'],
}

package {'httpd':
  ensure => present,
}

service {'httpd':
  ensure => running,
  enable => true,
  require => Package['httpd'],
  subscribe => File['/etc/php.ini'],
}

package {'mysql-server':
  ensure => 'present',
}

service {'mysqld':
  ensure => running,
  enable => true,
  require => Package['mysql-server'],
}
