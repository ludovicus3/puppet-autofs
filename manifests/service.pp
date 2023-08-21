# @api private
class autofs::service {
  assert_private()

  if $autofs::manage_service {
    service { $autofs::service_name:
      ensure => $autofs::service_ensure,
      enable => $autofs::service_enable,
    }
  }
}
