# @summary Installs, configures and runs autofs
#
# This class will implement the installation, configuration and operation
# of autofs. It will also manage the master file.
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
#   A key-value hash of settings to add to the autofs config file
#   under the [autofs] section
#
# @param [Hash] amd_settings
#   A key-value hash of settings to add to the autofs config file
#   under the [amd] section
#
# @param [Stdlib::Absolutepath] ldap_config_file
#   Path to the config file used for ldap configuration
#
# @param [Hash] ldap_settings
#   A key-value has of setting to add to the ldap configuration file
#
# @param [Boolean] manage_master
#   Allow puppet to manage the master file
#
# @param [Stdlib::Absolutepath] master_map
#   Path to the master file
#
# @param [String] master_owner
#   Who owns the master file. Defaults to root.
#
# @param [String] master_group
#   Which group owns the file. Defaults to root.
#
# @param [String] master_mode
#   Permission for the master file
#
# @param [String] master_content
#   Optional raw content for the master file
#
# @param [String] master_source
#   Optional source of raw content for the master file
#
# @param [Hash] maps
#   Hash of maps to implement
#
# @param [Hash] masters
#   Hash of additional masters
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
  Hash $autofs_settings = {
    'timeout' => 300,
    'browse_mode' => 'no',
    'mount_nfs_default_protocol' => 4,
  },
  Hash $amd_settings = {
    'dismount_interval' => 300,
  },
  Stdlib::Absolutepath $ldap_config_file = '/etc/autofs_ldap_auth.conf',
  Hash[String, Scalar] $ldap_settings = {
    'usetls' => false,
    'tlsrequired' => false,
    'authrequired' => false,
  },
  # Master Map management
  Boolean $manage_master = true,
  Stdlib::Absolutepath $master_map = '/etc/auto.master',
  String $master_owner = 'root',
  String $master_group = 'root',
  String $master_mode = '0644',
  Optional[String] $master_content = undef,
  Optional[Variant[Array[String], String]] $master_source = undef,
  Hash $maps = {},
  Hash $masters = {
    'auto.master' => {
      order => '99',
    },
    '/etc/auto.master.d' => {
      order => '98',
      type => 'dir',
    },
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
