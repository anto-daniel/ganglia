class ganglia_server_install::gmetad(
$cluster_name = undef,
$gmetad_user = undef,
$gmetad_case_sensitive_hostnames = undef) {

  file { "/etc/ganglia/gmetad.conf":
    ensure => file,
    content => template('ganglia_server_install/gmetad.conf.erb'),
    require => Package['ganglia-monitor'],
    notify => Service['gmetad'],
  }
}
