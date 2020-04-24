# Class: dynatraceoneagent::install:  See README.md for documentation.
# ===========================
#
#
class dynatraceoneagent::install {

  if !defined('archive') {
    class { 'archive':
      seven_zip_provider => '',
    }
  }

  $created_dir              = $dynatraceoneagent::created_dir
  $download_dir             = $dynatraceoneagent::download_dir
  $filename                 = $dynatraceoneagent::filename
  $download_path            = $dynatraceoneagent::download_path
  $proxy_server             = $dynatraceoneagent::proxy_server
  $command                  = $dynatraceoneagent::command
  $download_link            = $dynatraceoneagent::download_link
  $provider                 = $dynatraceoneagent::provider
  $oneagent_params_hash     = $dynatraceoneagent::oneagent_params_hash
  $reboot_system            = $dynatraceoneagent::reboot_system
  $service_name             = $dynatraceoneagent::service_name

  file{ $download_dir:
    ensure => directory
  }

  archive{ $download_path:
    ensure         => present,
    extract        => false,
    source         => $download_link,
    path           => $download_path,
    allow_insecure => true,
    require        => File[$download_dir],
    creates        => $created_dir,
    proxy_server   => $proxy_server,
  }

  if ($::kernel == 'Linux') or ($::osfamily  == 'AIX') {
    file{ $download_path:
      ensure => present,
      mode   => '0755',
    }

    exec { 'install_oneagent':
        command   => $command,
        cwd       => $download_dir,
        timeout   => 6000,
        creates   => $created_dir,
        provider  => $provider,
        logoutput => on_failure,
    }
  }

  if ($::osfamily == 'Windows'){
    package { $service_name:
      ensure          => present,
      provider        => $provider,
      source          => $download_path,
      install_options => [$oneagent_params_hash, '--quiet'],
    }
  }

  if ($reboot_system) and ($::osfamily == 'Windows') {
    reboot { 'after':
      subscribe => Package[$service_name],
    }
  } elsif ($reboot_system) and ($::kernel == 'Linux') or ($::osfamily  == 'AIX') {
      exec { 'reboot':
        command     => '/sbin/reboot',
        refreshonly => true,
        subscribe   => Exec['install_oneagent'],
    }
  }

}
