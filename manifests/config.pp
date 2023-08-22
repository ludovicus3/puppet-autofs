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

  if $autofs::manage_master {
    if $autofs::master_content or $autofs::master_source {
      file { $autofs::master_map:
        ensure  => file,
        owner   => $autofs::master_owner,
        group   => $autofs::master_group,
        mode    => $autofs::master_mode,
        content => $autofs::master_content,
        source  => $autofs::master_source,
        notify  => $subscribers,
        require => $requirements,
      }
    } else {
      concat { $autofs::master_map:
        ensure         => present,
        owner          => $autofs::master_owner,
        group          => $autofs::master_group,
        mode           => $autofs::master_mode,
        ensure_newline => true,
        notify         => $subscribers,
        require        => $requirements,
      }
    }

    create_resources('autofs::master', $autofs::masters)
    create_resources('autofs::map', $autofs::maps)
  }
}
