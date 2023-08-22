# @api private
define autofs::master::file (
  Stdlib::Absolutepath $path = $title,
  Optional[String] $owner = undef,
  Optional[String] $group = undef,
  Optional[String] $mode = undef,
  Optional[Hash] $maps = undef,
  Optional[String] $content = undef,
  Optional[Variant[Array[String[1]], String[1]]] $source = undef,
) {
  include autofs

  if $autofs::manage_service {
    $_subscribers = Service[$autofs::service_name]
  } else {
    $_subscribers = undef
  }

  $_owner = pick($owner, 'root')
  $_group = pick($group, 'root')
  $_mode = pick($mode, '0644')

  if $maps {
    concat { $path:
      ensure         => present,
      owner          => $_owner,
      group          => $_group,
      mode           => $_mode,
      ensure_newline => true,
      notify         => $_subscribers,
    }

    ensure_resources('autofs::map', $maps, { master => $path })
  } else {
    file { $path:
      ensure  => file,
      owner   => $_owner,
      group   => $_group,
      mode    => $_mode,
      content => $content,
      source  => $source,
      notify  => $_subscribers,
    }
  }
}
