# @api private
class autofs::config {
    assert_private()

    if $autofs::config_file {
        $autofs::settings.each |$key, $value| {
            ini_setting { "${autofs::config_file}::autofs::${key}":
                ensure  => present,
                path    => $autofs::config_file,
                section => 'autofs',
                setting => $key,
                value   => $value,
            }
        }

        $autofs::parser_settings.each |$parser, $settings| {
            $settings.each |$key, $value| {
                ini_setting { "${autofs::config_file}::${parser}::${key}":
                    ensure  => present,
                    path    => $autofs::config_file,
                    section => $parser,
                    setting => $key,
                    value   => $value,
                }
            }
        }
    }
}
