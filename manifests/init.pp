class mysql_windows (
    $version     = $mysql_windows::params::version,
    $url         = $mysql_windows::params::url,
    $package     = $mysql_windows::params:package,
    $file_path   = false,
) inherits mysql_windows::params {
    if $file_path {
        $mysql_installer_path = $file_path
    } else {
        $mysql_installer_path = "${::temp}\\${package}-${version}.msi"
    }
    windows_common::remote_file{'mysql':
        source      => $url,
        destination => $mysql_installer_path,
        before      => Package[$package],
    }
        
    package { $package:
        ensure          => installed,
        source          => $mysql_installer_path,
        install_options => ['/VERYSILENT','/SUPPRESSMSGBOXES','/LOG'],
    }

    $mysql_path = 'C:\Program Files\MySQL\MySQL Server 5.6\bin'
 
    windows_path { $mysql_path:
        ensure  => present,
        require => Package[$package],
    }
}