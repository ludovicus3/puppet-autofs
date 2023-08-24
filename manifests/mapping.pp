# @summary Defines a mapping to be added to a autofs map.
#
# A description of what this defined type does
#
# @param key
#   Key to match for mounting
#
# @param map
#   Absolute path to the map file
#
# @param order
#   Priority of the key in the map
#
# @param options
#   Options to be applied to the mount
#
# @param location
#   Array or Hash defining where the location of the volume
#
# @example
#   autofs::mapping { 'namevar': }
define autofs::mapping (
  String $key = $title,
  Autofs::Location $location,
  Stdlib::Absolutepath $map,
  Variant[String[1], Integer] $order = '10',
  Autofs::Options $options = [],
) {
  $_options = Array($options, true).join(',')

  if 'path' in $location {
    $_location = "${location['host']}:${location['path']}"
  } else {
    $_location = $location.map |$mount, $params| {
      $host = 'host' in $params ? {
        true => $params['host'],
        false => '',
      }
      $path = $params['path']
      $options = Array($params['options'], true).join(',')

      if $options.empty() {
        "${mount} ${host}:${path}"
      } else {
        "${mount} -${options} ${host}:${path}"
      }
    }.join(' \\\n\t')
  }

  if $_options.empty() {
    $_content = "${key}\t${_location}"
  } else {
    $_content = "${key}\t-${_options}\t${_location}"
  }

  concat::fragment { "${map}::${key}":
    target  => $map,
    content => $_content,
    order   => $order,
  }
}
