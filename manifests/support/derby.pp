# Download and unpack Derby
class bigmatch::support::derby(
  $derby_uri = undef,
) {
  include bigmatch::params
  include bigmatch::support::common

  validate_re($derby_uri, '\/db-derby-[A-Za-z0-9-_.]+-bin\.tar\.gz$', "Invalid Derby Package URI: \$derby_uri='${derby_uri}'; URI must end in a file that matches the pattern db-derby-[version]-bin.tar.gz")

  $source_dir = regsubst($derby_uri, '^.*\/\(db-derby-.*-bin\).tar.gz$','\1')
  $dest_dir = $bigmatch::params::derby_linkdir
  
  exec { 'download-derby':
    command     => 'curl -s "${URI}" | tar -xz && if [[ -h "${DEST_DIR}" ]]; then rm -f "${DEST_DIR}"; fi; ln -s "${SOURCE_DIR}" "${DEST_DIR}"',
    path        => ['/bin', '/usr/bin'],
    cwd         => $bigmatch::params::support_basedir,
    user        => 'root',
    umask       => '022',
    environment => [
      "URI='${derby_uri}'",
      "SOURCE_DIR='${source_dir}'",
      "DEST_DIR='${dest_dir}'",
    ],
    creates     => "${bigmatch::params::support_basedir}/${source_dir}",
    require     => File[$bigmatch::params::support_basedir],
  }
}