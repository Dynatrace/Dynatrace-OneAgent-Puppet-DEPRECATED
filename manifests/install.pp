# @summary
#   This class manages the installation of the OneAgent on the host
#
class dynatraceoneagent::install {

  $created_dir              = $dynatraceoneagent::created_dir
  $download_dir             = $dynatraceoneagent::download_dir
  $filename                 = $dynatraceoneagent::filename
  $download_path            = $dynatraceoneagent::download_path
  $provider                 = $dynatraceoneagent::provider
  $oneagent_params_hash     = $dynatraceoneagent::oneagent_params_hash
  $reboot_system            = $dynatraceoneagent::reboot_system
  $service_name             = $dynatraceoneagent::service_name
  $package_state            = $dynatraceoneagent::package_state
  $oneagent_puppet_conf_dir = $dynatraceoneagent::oneagent_puppet_conf_dir

  if ($::kernel == 'Linux' or $::osfamily  == 'AIX'){
    exec { 'install_oneagent':
        command   => $dynatraceoneagent::command,
        cwd       => $download_dir,
        timeout   => 6000,
        creates   => $created_dir,
        provider  => $provider,
        logoutput => on_failure,
    }
  }

  if ($::osfamily == 'Windows') {
    package { $service_name:
      ensure          => $package_state,
      provider        => $provider,
      source          => $download_path,
      install_options => [$oneagent_params_hash, '--quiet'],
    }
  }

  if ($reboot_system) and ($::osfamily == 'Windows') {
    reboot { 'after':
      subscribe => Package[$service_name],
    }
  } elsif ($::kernel == 'Linux' or $::osfamily  == 'AIX') and ($reboot_system) {
      reboot { 'after':
        subscribe => Exec['install_oneagent'],
      }
  }

}
