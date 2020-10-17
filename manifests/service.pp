# @api private
class autofs::service {
    assert_private()

    service { $autofs::service_name:
        ensure     => $autofs::service_ensure,
        enable     => $autofs::service_enable,
        hasstatus  => true,
        hasrestart => true,
        require    => Class['autofs::install'],
        subscribe  => Class['autofs::config'],
    }
}
