# Class: bigmatch
#
# This module manages the deployment of IBM Big Match for Hadoop on IBM Open Platform with Apache Hadoop.
#
# Notes:
#  * This is designed specifically for Enterprise Linux 6 based systems. Others will not work.
#  * IBM Big Match is commercial software.  It is NOT included as part of this module.
#  * You must obtain the software yourself, agreeing to any and all terms required 
#    by IBM.  See [Installing InfoSphere Big Match for Hadoop](http://www-01.ibm.com/support/knowledgecenter/SSWSR9_11.4.0/com.ibm.swg.im.mdmhs.pmebi_install.doc/topics/installing_pme_bi.html)
#  * This module does not support the removal of software.
#
# Parameters:
#
# $bigmatch_repo_uri::             The URI of the Yum repository containing
#                                  the Big Match software.  
#                                  Required, no default
#                                  type:string
#
# $bigmatch_repo_gpgcheck::        Flag that instructs Yum to check package
#                                  signatures prior to installation. Setting
#                                  this to false is almost always a bad idea.
#                                  Defaults to true.
#                                  type:boolean
#
# $bigmatch_repo_sslverify::       Flag that instructs Yum to check the validity
#                                  of the certificate provided by the remote
#                                  repository (e.g. https server certificate).
#                                  Setting this to false is almost always a
#                                  bad idea.
#                                  Defaults to true.
#                                  type:boolean
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
# * Simple usage
#
#     include bigmatch
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
