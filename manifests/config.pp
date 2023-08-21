# @api private
class autofs::config {
  assert_private()

  if $autofs::manage_config {
    if $autofs::manage_package {
      $requirements = Package[$autofs::package_name]
    } else {
      $requirements
    }

    if $autofs::manage_service {
      $subscribers = Service[$autofs::service_name]
    } else {
      $subscribers
    }

    $autofs::autofs_settings.each |$key, $value| {
      if $value {
        ini_setting { "autofs::${key}":
          ensure  => present,
          path    => $autofs::config_file,
          section => 'autofs',
          setting => $key,
          value   => $value,
          require => $requirements,
          notify  => $subscribers,
        }
      } else {
        ini_setting { "autofs::${key}":
          ensure  => absent,
          path    => $autofs::config_file,
          section => 'autofs',
          setting => $key,
          require => $requirements,
          notify  => $subscribers,
        }
      }

      file { $autofs::ldap_config_file:
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0640',
        content => epp('autofs/autofs_ldap_auth.conf.epp'),
        require => $requirements,
        notify  => $subscribers,
      }
    }
  }
}
