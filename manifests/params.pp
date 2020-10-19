# @summary
#   The default parameters for autofs
class autofs::params {
  $package_name = 'autofs'
  $package_ensure = 'installed'
  $config_file = '/etc/autofs.conf'
  $settings = {}
  $parser_settings = {}
  $service_name = 'autofs'
  $service_ensure = 'running'
  $service_enable = true
}
