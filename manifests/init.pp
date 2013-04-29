package {'php':
  ensure => present,
  before => File['/etc/php.ini']
}

file { '/etc/php.ini':
  ensure => file
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

class apache {
  firewall { '100 allow http and https access':
    port   => [80, 443],
    proto  => tcp,
    action => accept,
  }
}

class { apache: }
class { firewall: }
