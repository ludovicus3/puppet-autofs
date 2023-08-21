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
  Optional[Autofs::Options] $options = undef,
) {
  concat::fragment { "${map}::${key}":
    target  => $map,
    content => autofs::mapping_content($key, $location, $options),
    order   => $order,
  }
}
