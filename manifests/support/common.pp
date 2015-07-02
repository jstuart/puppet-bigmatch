# Common requirements for the support packages
class bigmatch::support::common {
  
  file { $bigmatch::params::support_basedir:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  
  ensure_packages(['curl'])
  
}