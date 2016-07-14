class ganglia_server_install::gmond(
$cluster_name = undef,
$gmond_user = undef) {

#    exec{ 'gmond':
#	command => '/usr/sbin/gmond -t | /usr/bin/tee /etc/ganglia/gmond.conf',
#    }
    file { '/etc/ganglia/gmond.conf':
	ensure => file,
	owner => 'root',
	group => 'root',
	mode => '0644',
	#source => 'puppet:///modules/ganglia_server_install/gmond.conf',
    content => template('ganglia_server_install/gmond.conf.erb'),
    require => Package['ganglia-monitor'],
	notify => Service['gmond'],
    }
  
#    file_line { 'user':
#	path => '/etc/ganglia/gmond.conf',
#	line => 'user = ganglia',
#	match => 'user\ =\ .*',
#    }
#    file_line { 'cluster':
#	path => '/etc/ganglia/gmond.conf',
#	line => 'name = "unleash"',
#	match => 'name\ =\ "unspecified"',
#    }
#    file_line { 'comment mcast':
#	path => '/etc/ganglia/gmond.conf',
#	lines => '#mcast_join = <ip>',
#	multiple => 'mcast_join\ =\ .*',
#    }
#    file_line { 'udp_send_channel host':
#	path => '/etc/ganglia/gmond.conf',
#	line => "udp_send_channel {\nhost = localhost\n",
#	match => 'udp_send_channel\ {.*',
 #   }
}
