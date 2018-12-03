# Restart Windows service
#   Parameter:
#   * name: Service name that should be restarted
define dynatraceoneagent::resources::windows_restartservice () {
  oneagent::resources::windows_stopservice{"restart_stop_${name}":
    service_name => $name
  }
  ->  oneagent::resources::windows_startservice{"restart_start_${name}":
    service_name => $name
  }
}
