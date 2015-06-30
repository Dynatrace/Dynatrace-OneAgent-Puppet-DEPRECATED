# The restart_service_hook takes a service name and restarts it after an 
# installation or upgrade of the ruxit agent.
# If this resource is called with an array it will be executed for every entry.
#
define ruxit_agent::resources::restart_services_hook {
  # restart the service
  if $::kernel =~ /Linux/ {
    ruxit_agent::resources::linux_restartservice_initd{ $name : }
  } else {
    ruxit_agent::resources::windows_restartservice{ $name : }
  }
}
