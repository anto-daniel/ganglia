class ganglia_server_install {
  
  #include ganglia_server_install::depends
  
  $ganglia_monitor_dependencies = [ 'libapr1', 'daemon', 'libexpat1', 'libpython2.7', 'libxml2', 'libpango1.0-0' ]
  $ganglia_web_dependencies = [ 'apache2', 'libapache2-mod-php5' ]

  package { $ganglia_monitor_dependencies:
    provider => apt,
    ensure => 'installed',
    require => Package['rrdtool']
  }

  package { $ganglia_web_dependencies:
    provider => apt,
    ensure => 'installed'
  }
  
  file { "/opt/ganglia_debs":
     ensure => directory
  }

  file { "/opt/ganglia_debs/confuse_2.7.deb":
     owner => root,
     group => root,
     mode  => 644,
     ensure => present,
     source => "puppet:///modules/ganglia_server_install/confuse_2.7.deb"
  }  
  
  file { "/opt/ganglia_debs/rrdtool_1.4.9.deb":
     owner => root,
     group => root,
     mode => 644,
     ensure => present,
     source => "puppet:///modules/ganglia_server_install/rrdtool_1.4.9.deb"
  }

  file { "/opt/ganglia_debs/ganglia-monitor_3.7.1.deb":
     owner => root,
     group => root,
     mode => 644,
     ensure => present,
     source => "puppet:///modules/ganglia_server_install/ganglia-monitor_3.7.1.deb"
   } 

  file { "/opt/ganglia_debs/ganglia-web_3.7.1.deb":
     owner => root,
     group => root,
     mode => 644,
     ensure => present,
     source => "puppet:///modules/ganglia_server_install/ganglia-web_3.7.1.deb"
   }

  package { "confuse":
     provider => dpkg,
     ensure => installed,
     source => "/opt/ganglia_debs/confuse_2.7.deb"
  }
  package { "rrdtool":
     provider => dpkg,
     ensure => installed,
     source => "/opt/ganglia_debs/rrdtool_1.4.9.deb",
  }
  package { "ganglia-monitor":
     provider => dpkg,
     ensure => installed,
     source => "/opt/ganglia_debs/ganglia-monitor_3.7.1.deb",
     require => Package[$ganglia_monitor_dependencies]
    # require => Class["$::depends"]
  }
  package { "ganglia-web":
     provider => dpkg,
     ensure => installed,
     source => "/opt/ganglia_debs/ganglia-web_3.7.1.deb",
     require => Package[$ganglia_web_dependencies]
     #require => Class["$::depends"]
  }
  service { 'gmetad':
     ensure => 'running',
     require => Package['rrdtool']
  }
  service { 'gmond':
     ensure => 'running',
     require => Package['ganglia-monitor']
  }
  service { 'apache2':
     ensure => 'running',
     require => Package['apache2']
  }
  file { '/usr/lib/libganglia.so.0':
     ensure => 'link',
     target => '/usr/lib64/libganglia.so.0.0.0',
     require => Package['ganglia-monitor']
  }

  file { '/etc/apache2/conf.d/ganglia.conf':
     content => inline_template("Alias /ganglia /var/www/ganglia"),
     require => Package['apache2'],
     notify => Service['apache2'],
  }
  file_line { 'export LD_LIBRARY_PATH':
	   path => '/etc/environment',
	   line => "LD_LIBRARY_PATH=/usr/local/lib:/lib://usr/lib:/usr/lib64",
	   ensure => present
  }
}	
