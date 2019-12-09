# Class: dynatraceoneagent::service:  See README.md for documentation.
# ===========================
#
#
class dynatraceoneagent::service {

  $command                  = $dynatraceoneagent::command
  $service_name             = $dynatraceoneagent::service_name
  $provider                 = $dynatraceoneagent::provider
  $download_dir             = $dynatraceoneagent::download_dir
  $download_path            = $dynatraceoneagent::download_path
  $created_dir              = $dynatraceoneagent::created_dir
  $reboot_system            = $dynatraceoneagent::reboot_system
  $oneagent_params_hash     = $dynatraceoneagent::oneagent_params_hash

  if ($::kernel == 'Linux') or ($::osfamily  == 'AIX') {
    file{ $download_path:
      ensure => present,
      mode   => '0755',
    }

  $require_value = Exec['install_oneagent']

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

    $require_value = Package[$service_name]

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
  } else {
    notify { 'Not rebooting': }
  }

  service{ $service_name:
      ensure  => running,
      enable  => true,
      require => $require_value,
  }

}
