# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include autofs
class autofs (
    Variant[Array, String] $package_name = $autofs::params::package_name,
    String $package_ensure = $autofs::params::package_ensure,
    Optional[String] $package_source = undef,

    Stdlib::Absolutepath $config_file = $autofs::params::config_file,
    Hash[String, Scalar] $settings = $autofs::params::settings,
    Hash $parser_settings = $autofs::params::parser_settings,

    Variant[Array, String] $service_name = $autofs::params::service_name,
    Stdlib::Ensure::Service $service_ensure = $autofs::params::service_ensure,
    Boolean $service_enable = $autofs::params::service_enable,
) inherits autofs::params {
    contain 'autofs::install'
    unless $package_ensure == 'absent' {
        contain 'autofs::config'
        contain 'autofs::service'
    }
}
