# Static parameters for the Big Match module
class bigmatch::params {
  
  $support_basedir = '/opt/bigmatch-support'
  $derby_linkdir = 'db-derby-current-bin'
  $wlp_basedir = "${support_basedir}/wlp"
  $wlp_linkfile = 'wlp-runtime-current.jar'
}