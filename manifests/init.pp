# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @param [Boolean] manage_package
#   Should puppet manage packages for autofs
#
# @param [String] package_name
#   Name of the packages to install
#
# @param [String] package_ensure
#   State of the package to ensure
#
# @param [String] package_source
#   Source of the package
#
# @param [Boolean] manage_config
#   Allow puppet to manage the configuration files
#
# @param [Stdlib::Absolutepath] config_file
#   Path to the configuration file
#
# @param [Hash] autofs_settings
#
# @param [Hash] amd_settings
#
# @param [Stdlib::Absolutepath] ldap_config_file
#
# @param [Hash] ldap_settings
#
# @param [Boolean] manage_service
#   Allow puppet to manage the service for autofs
#
# @param [String] service_name
#   Name of the autofs service
#
# @param [Boolean] service_enable
#   Enable the start of the service on boot
#
# @param [Stdlib::Service::Ensure] service_ensure
#   State of the service to enforce
#
class autofs (
  # Package management
  Boolean $manage_package = true,
  Variant[Array[String[1]], String[1]] $package_name = 'autofs',
  String $package_ensure = 'installed',
  Optional[String] $package_source = undef,

  # Configuration management
  Boolean $manage_config = true,
  Stdlib::Absolutepath $config_file = '/etc/autofs.conf',
  Hash $autofs_settings = {},
  Hash $amd_settings = {},
  Stdlib::Absolutepath $ldap_config_file = '/etc/autofs_ldap_auth.conf',
  Hash[String, Scalar] $ldap_settings = {
    'usetls' => false,
    'tlsrequired' => false,
    'authrequired' => false,
  },

  # Service management
  Boolean $manage_service = true,
  String $service_name = 'autofs',
  Stdlib::Ensure::Service $service_ensure = running,
  Boolean $service_enable = true,
) {
  contain 'autofs::install'
  contain 'autofs::config'
  contain 'autofs::service'

  Class['autofs::install'] -> Class['autofs::config'] -> Class['autofs::service']
}
