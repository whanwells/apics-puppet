# @summary Manages the gateway user, group, and installation files.
#
# @api private
class apics::install {
  if $apics::manage_user {
    user { $apics::user:
      ensure => present,
      gid    => $apics::group,
    }
  }

  if $apics::manage_group {
    group { $apics::group:
      ensure => present,
    }
  }

  if $apics::manage_unzip_package {
    package { 'unzip':
      ensure => present,
    }
  }

  if $apics::manage_jdk_package {
    java::download { 'jdk':
      ensure        => present,
      java_se       => 'jdk',
      version_major => $apics::jdk_package_version,
      version_minor => 'b08',
      package_type  => $apics::jdk_package_type,
      url           => $apics::jdk_package_source,
    }
  }

  [$apics::basedir, $apics::installer_dir].each |$dir| {
    file { $dir:
      ensure => directory,
      owner  => $apics::user,
      group  => $apics::group,
      mode   => '0700',
    }
  }

  archive { $apics::installer_target:
    source       => $apics::installer_source,
    extract      => true,
    extract_path => $apics::installer_dir,
    user         => $apics::user,
    creates      => "${apics::installer_dir}/APIGateway",
    cleanup      => $apics::installer_cleanup,
  }
}
