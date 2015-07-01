# Restart Windows service
#   Parameter:
#   * name: Service name that should be restarted
define ruxit_agent::resources::windows_restartservice () {
  ruxit_agent::resources::windows_stopservice{"restart_stop_${name}":
    service_name => $name
  }
  ->
  ruxit_agent::resources::windows_startservice{"restart_start_${name}":
    service_name => $name
  }
}