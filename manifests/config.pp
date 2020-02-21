# Class: dynatraceoneagent::config:  See README.md for documentation.
# ===========================
#
#
class dynatraceoneagent::config {

  $host_tags                      = $dynatraceoneagent::host_tags
  $host_metadata                  = $dynatraceoneagent::host_metadata
  $hostname                       = $dynatraceoneagent::hostname
  $hostautotag_config_file        = $dynatraceoneagent::hostautotag_config_file
  $hostmetadata_config_file       = $dynatraceoneagent::hostmetadata_config_file
  $hostname_config_file           = $dynatraceoneagent::hostname_config_file
  $service_name                   = $dynatraceoneagent::service_name

  if $host_tags {
    file { $hostautotag_config_file:
      content => $host_tags,
    }
  }

  if $host_metadata {
    file { $hostmetadata_config_file:
      content => $host_metadata,
    }
  } 

  if $hostname {
    file { $hostname_config_file:
      content => $hostname,
      notify  => Service[$service_name],
    }
  }

}
