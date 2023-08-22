# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @param [String] map
#   Path or name of the map to include
#
# @param [Autofs::Options] options
#   Options to be applied to the map
#
# @param [Boolean] purge
#   Purge all other maps from directory
#
# @param [Variant[Integer, String]] order
#   Priority of the record in its master
#
# @param [Stdlib::Absolutepath] master
#   The master file/directory that this map belongs to
#
# @param [Hash[String, Autofs::Map]] maps
#   A hash of maps to autogenerate included in this master
#
# @param [Autofs::Type] type
#   The type of master record
#
# @param [Autofs::Format] format
#   The format of the master
#
# @param [String] owner
#   User who owns the master
#
# @param [String] group
#   Group setting for the master
#
# @param [String] mode
#   File permissions mode applied to the master
#
# @param [String] content
#   Raw file content in the master
#
# @param [String] source
#   Source to copy the content from
define autofs::master (
  String[1] $map = $title,
  Autofs::Options $options = [],
  Boolean $purge = false,
  Variant[Integer, String[1]] $order = 10,
  Optional[Stdlib::Absolutepath] $master = undef,
  Optional[Hash[String[1], Autofs::Map]] $maps = undef,
  Optional[Autofs::Type] $type = undef,
  Optional[Autofs::Format] $format = undef,
  Optional[String] $owner = undef,
  Optional[String] $group = undef,
  Optional[String] $mode = undef,
  Optional[String] $content = undef,
  Optional[String] $source = undef,
) {
  include autofs

  case $type {
    'dir': {
      autofs::master::directory { $map:
        owner => $owner,
        group => $group,
        mode  => $mode,
        purge => $purge,
      }
    }
    'file': {}
    undef: {
      if is_absolute_path($map) {
        autofs::master::file { $map:
          owner   => $owner,
          group   => $group,
          mode    => $mode,
          maps    => $maps,
          content => $content,
          source  => $source,
        }
      }
    }
    'program', 'exec': {
      fail("Autofs::Master[${title}] cannot be of type '${type}'")
    }
    default: {
    }
  }

  if $map != $autofs::master_map {
    $_master = pick($master, $autofs::master_map)

    if defined(Concat[$_master]) {
      $_options = Array($options, true).join(',')

      $_content = $type ? {
        undef => "+${map} ${_options}",
        default => $format ? {
          undef => "+${type}:${map} ${_options}",
          default => "+${type},${format}:${map} ${_options}",
        }
      }

      concat::fragment { "${_master}::${map}":
        target  => $_master,
        content => $_content.rstrip(),
        order   => $order,
      }
    }
  }
}
