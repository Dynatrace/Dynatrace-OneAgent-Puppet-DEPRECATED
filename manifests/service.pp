# @summary
#   Manages the OneAgent service
#
class dynatraceoneagent::service {
  $manage_service = $dynatraceoneagent::manage_service
  $service_name   = $dynatraceoneagent::service_name
  $require_value  = $dynatraceoneagent::params::require_value
  $service_state  = $dynatraceoneagent::service_state
  $package_state  = $dynatraceoneagent::package_state

  if $manage_service {
    service{ $service_name:
      ensure     => $service_state,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      require    => $require_value,
    }
  }
}
