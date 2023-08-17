# @api private
define autofs::master::directory (
  Stdlib::Absolutepath $map = $title,
  Boolean $purge = false,
  Optional[String] $owner = undef,
  Optional[String] $group = undef,
  Optional[String] $mode = undef,
) {
  include autofs

  if $autofs::manage_service {
    $_subscribers = Service[$autofs::service_name]
  } else {
    $_subscribers = undef
  }

  file { $map:
    ensure => directory,
    owner  => pick($owner, 'root'),
    group  => pick($group, 'root'),
    mode   => pick($mode, '0755'),
    purge  => $purge,
    notify => $_subscribers,
  }
}
