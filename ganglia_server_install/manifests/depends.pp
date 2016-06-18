class ganglia_server_install::depends {

  $monitor_dependency_packages = [ 'libapr1', 'daemon', 'libexpat1', 'libpython2.7', 'libxml2', 'libpango1.0-0', 'apache2', 'libapache2-mod-php5' ]

   package { $monitor_dependency_packages:
     ensure => 'installed'
   }

}
 
