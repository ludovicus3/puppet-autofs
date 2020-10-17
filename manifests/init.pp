# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include autofs
class autofs (
    Varian[Array, String] $package_name,
    String $package_ensure,
    Optional[String] $package_source,

    Stdlib::Absolutepath $config_file,
    Hash[String, Scalar] $settings,
    Hash $parser_settings,

    Variant[Array, String] $service_name,
    Stdlib::Ensure::Service $service_ensure,
    Boolean $service_enable,
) {
    contain 'autofs::install'
    unless $package_ensure == 'absent' {
        contain 'autofs::config'
        contain 'autofs::service'
    }
}
