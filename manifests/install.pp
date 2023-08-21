# @api private
class autofs::install {
  assert_private()

  if $autofs::manage_package {
    stdlib::ensure_packages($autofs::package_name, {
        ensure => $autofs::package_ensure,
        source => $autofs::package_source,
    })
  }
}
