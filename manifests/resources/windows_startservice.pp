# start Windows service
#   Parameter:
#   * $service_name: Service name that should be started
define dynatraceoneagent::resources::windows_startservice ($service_name) {
  $cmd = 'C:\\Windows\\System32\\cmd.exe'
  exec { "start_${name}":
    command => "${cmd} /c sc start \"${service_name}\"",
    unless  => "${cmd} /c sc query \"${service_name}\" | find \"RUNNING\"",
    returns => ['0', '1056'],
    path    => $::path
  }
}
