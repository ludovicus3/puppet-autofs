# @api private
class autofs::config {
  assert_private()

  if $autofs::manage_config {
    if $autofs::manage_package {
      $_requirements = Package[$autofs::package_name]
    } else {
      $_requirements
    }

    if $autofs::manage_service {
      $_subscribers = Service[$autofs::service_name]
    } else {
      $_subscribers
    }

    $autofs::autofs_settings.each |$key, $value| {
      if $value {
        ini_setting { "autofs::${key}":
          ensure  => present,
          path    => $autofs::config_file,
          section => 'autofs',
          setting => $key,
          value   => $value,
          require => $_requirements,
          notify  => $_subscribers,
        }
      } else {
        ini_setting { "autofs::${key}":
          ensure  => absent,
          path    => $autofs::config_file,
          section => 'autofs',
          setting => $key,
          require => $_requirements,
          notify  => $_subscribers,
        }
      }
    }

    file { $autofs::ldap_config_file:
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0640',
      content => epp('autofs/autofs_ldap_auth.conf.epp'),
      require => $_requirements,
      notify  => $_subscribers,
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
        notify  => $_subscribers,
        require => $_requirements,
      }
    } else {
      concat { $autofs::master_map:
        ensure         => present,
        owner          => $autofs::master_owner,
        group          => $autofs::master_group,
        mode           => $autofs::master_mode,
        ensure_newline => true,
        notify         => $_subscribers,
        require        => $_requirements,
      }
    }

    create_resources('autofs::master', $autofs::masters)
    create_resources('autofs::map', $autofs::maps)
  }
}
