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
# $bigmatch_console_support::      Flag that instructs this module to download
#                                  the non-RPM packages required by Big Match
#                                  Console.  Apache Derby will be installed to
#                                  /opt/bigmatch-support/db-derby-current-bin
#                                  and the IBM WLP Runtime will be installed to
#                                  /opt/bigmatch-support/wlp/wlp-runtime-current.jar
#                                  Defaults to false.
#                                  type:boolean
#
# $bigmatch_ensure_package_deps::  Flag that causes this module to install the
#                                  upstream package dependencies that really
#                                  should be required by the actual Big Match
#                                  RPM.
#                                  Defaults to true.
#                                  type:boolean
#
# $bigmatch_ambari_rpm_uri::       The URI of the RPM that will install the
#                                  appropriate Ambari Server metadata for
#                                  Big Match into the IOP stack. This will only
#                                  execute on servers for which $iop::ambari_server
#                                  has a value of true. Note that this is not
#                                  provided by IBM.  You need to convert the
#                                  tarball into an RPM yourself.
#                                  Defaults to an empty string, disabling this
#                                  feature. 
#                                  type:string
#
# $bigmatch_sudoers_hack::         Flag that causes the installation of a file
#                                  in sudoers.d permitting sudo by root without 
#                                  a TTY.  This should NOT be enabled in a
#                                  production environment. Hopefully the need
#                                  for this hack, commands prefixed with sudo
#                                  within the Big Match installer, will be 
#                                  addressed in future releases of the software.
#                                  Defaults to false.
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
  $bigmatch_console_support = false,
  $bigmatch_ensure_package_deps = true,
  $bigmatch_ambari_rpm_uri = '',
  $bigmatch_sudoers_hack = false
) {
  validate_string($bigmatch::bigmatch_repo_uri)
  validate_bool($bigmatch::bigmatch_repo_gpgcheck)
  validate_bool($bigmatch::bigmatch_repo_sslverify)
  validate_bool($bigmatch::bigmatch_console_support)
  validate_bool($bigmatch::bigmatch_ensure_package_deps)
  validate_string($bigmatch::bigmatch_ambari_rpm_uri)
  validate_bool($bigmatch::bigmatch_sudoers_hack)

  if $bigmatch_ensure_package_deps == true {
    # These should really just be required by the Big Match RPM...
    ensure_packages(['libxml2', 'libxslt'])
  }
  
  # Add the BigMatch repo to Ambari
  iop::ambari::repo { 'bigmatch':
    repoid    => 'BIGMATCH-11.4',
    reponame  => 'BIGMATCH',
    baseurl   => $bigmatch::bigmatch_repo_uri,
    gpgcheck  => $bigmatch::bigmatch_repo_gpgcheck,
    sslverify => $bigmatch::bigmatch_repo_sslverify,
    order     => '30'
  }
  
  if $bigmatch::bigmatch_ambari_rpm_uri != '' {
    iop::ambari::addon { 'bigmatch-ambari-stack-iop':
      ensure       => installed,
      package_name => 'bigmatch-ambari-stack-iop',
      rpm_uri      => $bigmatch::bigmatch_ambari_rpm_uri,
    }
  }
  
  if $bigmatch::bigmatch_console_support == true {
    include bigmatch::support::derby
    include bigmatch::support::wlp
  }
  
  if $bigmatch::bigmatch_sudoers_hack == true {
    file { '/etc/sudoers.d/bigmatch-hack':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/etc/sudoers.d/bigmatch-hack.erb"),
    }
  }
}
