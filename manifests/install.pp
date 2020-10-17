# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include autofs::install
class autofs::install {
    assert_private()

    package { $autofs::package_name:
        ensure => $autofs::package_ensure,
        source => $autofs::package_source,
    }
}
