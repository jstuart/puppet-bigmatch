# Download WLP runtime
class bigmatch::support::wlp (
  $wlp_runtime_uri = undef
) {
  include bigmatch::params
  include bigmatch::support::common
  
  validate_re($wlp_runtime_uri, '\/wlp-runtime-[A-Za-z0-9-_.]+\.jar$', "Invalid WLP Runtime URI: \$wlp_runtime_uri='${wlp_runtime_uri}'; URI must end in a file that matches the pattern wlp-runtime-[version].jar")

  $source_file = regsubst($wlp_runtime_uri, '^.*\/\(wlp-runtime-.*\.jar\)$','\1')
  $dest_file = $bigmatch::params::wlp_linkfile

  file { $bigmatch::params::wlp_basedir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File[$bigmatch::params::support_basedir],
  }
  
  exec { 'download-wlp-runtime':
    command     => 'curl -s -O "${URI}" && if [[ -h "${DEST_FILE}" ]]; then rm -f "${DEST_FILE}"; fi; ln -s "${SOURCE_FILE}" "${DEST_FILE}"',
    path        => ['/bin', '/usr/bin'],
    cwd         => $bigmatch::params::wlp_basedir,
    user        => 'root',
    umask       => '022',
    environment => [
      "URI='${wlp_runtime_uri}'",
      "SOURCE_FILE='${source_file}'",
      "DEST_FILE='${dest_file}'",
    ],
    creates     => "${bigmatch::params::wlp_basedir}/${source_file}",
    require     => File[$bigmatch::params::wlp_basedir],
  }
  
}