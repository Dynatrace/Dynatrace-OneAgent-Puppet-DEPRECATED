# @summary
#   Uninstalls the Dynatrace OneAgent
#
class dynatraceoneagent::uninstall {

  $provider    = $dynatraceoneagent::provider
  $install_dir = $dynatraceoneagent::install_dir
  $created_dir = $dynatraceoneagent::created_dir

  $created_dir_exists = find_file($created_dir)

  if $created_dir_exists {

    if ($::kernel == 'Linux' or $::osfamily == 'AIX') {
      exec { 'uninstall_oneagent':
        command   => "${install_dir}/agent/uninstall.sh",
        timeout   => 6000,
        provider  => $provider,
        logoutput => on_failure,
      }
    } elsif $::osfamily == 'Windows' {
      $uninstall_command = @(EOT)
        $app = Get-WmiObject win32_product -filter "Name like 'Dynatrace OneAgent'"
        msiexec /x $app.IdentifyingNumber /quiet /l*vx uninstall.log
        | EOT

      exec { 'uninstall_oneagent':
        command   => $uninstall_command,
        timeout   => 6000,
        provider  => powershell,
        logoutput => on_failure,
      }
    }
  }

}
