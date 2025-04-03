# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @param [String] map
# @param [Stdlib::Absolutepath] mount
# @param [Variant[Integer, String]] order
# @param [Hash] settings
# @param [Stdlib::Absolutepath] master
# @param [String] owner
# @param [String] group
# @param [String] mode
# @param [Autofs::Type] type
# @param [Autofs::Format] format
# @param [Autofs::Options] options
# @param [Hash[String, Autofs::Mapping] mappings
# @param [String] content
# @param [Variant[Array[String], String]] source
#
# @example
#   autofs::map { 'namevar': }
define autofs::map (
  Stdlib::Absolutepath $mount,
  String $map = $title,
  Variant[Integer, String[1]] $order = '10',
  Hash $settings = {},
  Optional[Stdlib::Absolutepath] $master = undef,
  Optional[String] $owner = undef,
  Optional[String] $group = undef,
  Optional[String] $mode = undef,
  Optional[Autofs::Type] $type = undef,
  Optional[Autofs::Format] $format = undef,
  Autofs::Options $options = [],
  Optional[Hash] $mappings = undef,
  Optional[String] $content = undef,
  Optional[Variant[Array[String], String]] $source = undef,
) {
  include 'autofs'

  $settings.each |$key, $value| {
    if $value {
      ini_setting { "autofs::${mount}::${key}":
        ensure  => present,
        path    => $autofs::config_file,
        section => $mount,
        setting => $key,
        value   => $value,
      }
    } else {
      ini_setting { "autofs::${mount}::${key}":
        ensure  => absent,
        path    => $autofs::config_file,
        section => $mount,
        setting => $key,
      }
    }
  }

  case $type {
    'dir': {
      fail("Autofs::Map['${title}'] cannot be of type '${type}'")
    }
    'file', undef: {
      if $mappings {
        concat { $map:
          ensure         => present,
          owner          => pick($owner, 'root'),
          group          => pick($group, 'root'),
          mode           => pick($mode, '0644'),
          ensure_newline => true,
        }
        create_resources('autofs::mapping', $mappings, { map => $title })
      } else {
        file { $map:
          ensure  => file,
          owner   => pick($owner, 'root'),
          group   => pick($group, 'root'),
          mode    => pick($mode, '0644'),
          content => $content,
          source  => $source,
        }
      }
    }
    'program', 'exec': {
      if $mappings {
        fail("Autofs::Map['${title}'] cannot use mappings if map is executable!")
      } else {
        file { $map:
          ensure  => file,
          owner   => pick($owner, 'root'),
          group   => pick($group, 'root'),
          mode    => pick($mode, '0755'),
          content => $content,
          source  => $source,
        }
      }
    }
    default: {}
  }

  $_master = pick($master, $autofs::master_map)
  if defined(Concat[$_master]) {
    $_options = Array($options, true).join(',')

    $_entry = $type ? {
      undef => $format ? {
        undef => "${mount} ${map} ${_options}",
        default => "${mount} file,${format}:${map} ${_options}",
      },
      default => $format ? {
        undef => "${mount} ${type}:${map} ${_options}",
        default => "${mount} ${type},${format}:${map} ${_options}",
      }
    }

    concat::fragment { "${_master}::${map}":
      target  => $_master,
      content => $_entry.rstrip(),
      order   => $order,
    }
  }
}
