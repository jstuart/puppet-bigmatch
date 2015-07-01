# Class: bigmatch
#
# This module manages bigmatch
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class bigmatch (
  $bigmatch_repo_uri = undef,
  $bigmatch_repo_gpgcheck = true,
  $bigmatch_repo_sslverify = true,
) {
  validate_string($bigmatch_repo_uri)
  validate_bool($bigmatch_repo_gpgcheck)
  validate_bool($bigmatch_repo_sslverify)
  
  # Add the BigMatch repo to Ambari
  iop::ambari::repo { 'bigmatch':
    repoid    => 'BIGMATCH-11.4',
    reponame  => 'BIGMATCH',
    baseurl   => $bigmatch::bigmatch_repo_uri,
    gpgcheck  => $bigmatch::bigmatch_repo_gpgcheck,
    sslverify => $bigmatch::bigmatch_repo_sslverify,
    order     => '30'
  }
}
