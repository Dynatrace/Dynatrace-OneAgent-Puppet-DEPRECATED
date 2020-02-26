# Class: dynatraceoneagent::service:  See README.md for documentation.
# ===========================
#
#
class dynatraceoneagent::service {

  $service_name             = $dynatraceoneagent::service_name
  $require_value            = $dynatraceoneagent::params::require_value

  service{ $service_name:
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      require    => $require_value,
  }

}
