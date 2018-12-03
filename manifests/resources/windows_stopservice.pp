# Stop Windows service
#   Parameter:
#   * $service_name: Service name that should be stopped
#   * $refreshonly: refresh only
define dynatraceoneagent::resources::windows_stopservice (
    $service_name,
    $refreshonly = false)
{
  $cmd = 'C:\\Windows\\System32\\cmd.exe'
  exec { "stop_${name}":
    command     => "${cmd} /c sc stop \"${service_name}\"",
    onlyif      => "${cmd} /c sc query \"${service_name}\" | find \"RUNNING\"",
    refreshonly => $refreshonly,
    path        => $::path,
    notify      => Exec["wait_for_stop_${name}"]
  }

  exec { "wait_for_stop_${name}":
    command     => "${cmd} /c sc query \"${service_name}\" | find \"STOPPED\"",
    unless      => "${cmd} /c sc query \"${service_name}\" | find \"The specified service does not exist as an installed service.\"",
    path        => $::path,
    tries       => 10,
    try_sleep   => 6,
    refreshonly => true
  }
}
