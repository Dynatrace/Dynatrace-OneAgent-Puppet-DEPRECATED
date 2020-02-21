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

  if !$host_tags {
    $auto_tag = ''
  } else{
    $auto_tag = $host_tags
  }

  if !$host_metadata {
    $auto_metadata = ''
  } else{
    $auto_metadata = $host_metadata
  }

  if !$hostname {
    $auto_hostname = ''
  } else{
    $auto_hostname = $hostname
  }

  file { $hostautotag_config_file:
    content => $auto_tag,
  }

  file { $hostmetadata_config_file:
    content => $auto_metadata,
  }

  file { $hostname_config_file:
    content => $auto_hostname,
    notify  => Service[$service_name],
  }

}
