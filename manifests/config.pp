# @summary
#   This class manages the configuration of the OneAgent
#
class dynatraceoneagent::config {

  $global_owner                        = $dynatraceoneagent::global_owner
  $global_group                        = $dynatraceoneagent::global_group
  $global_mode                         = $dynatraceoneagent::global_mode
  $service_name                        = $dynatraceoneagent::service_name
  $provider                            = $dynatraceoneagent::provider
  $install_dir                         = $dynatraceoneagent::install_dir
  $created_dir                         = $dynatraceoneagent::created_dir
  $package_state                       = $dynatraceoneagent::package_state
  $service_state                       = $dynatraceoneagent::service_state

# OneAgent Host Configuration Parameters
  $oneagent_tools_dir                  = $dynatraceoneagent::oneagent_tools_dir
  $oactl                               = $dynatraceoneagent::oneagent_ctl
  $oneagent_communication_hash         = $dynatraceoneagent::oneagent_communication_hash
  $log_monitoring                      = $dynatraceoneagent::log_monitoring
  $log_access                          = $dynatraceoneagent::log_access
  $host_group                          = $dynatraceoneagent::host_group
  $host_tags                           = $dynatraceoneagent::host_tags
  $host_metadata                       = $dynatraceoneagent::host_metadata
  $hostname                            = $dynatraceoneagent::hostname
  $infra_only                          = $dynatraceoneagent::infra_only
  $network_zone                        = $dynatraceoneagent::network_zone
  $oneagent_puppet_conf_dir            = $dynatraceoneagent::oneagent_puppet_conf_dir
  $oneagent_comms_config_file          = $dynatraceoneagent::oneagent_comms_config_file
  $oneagent_logmonitoring_config_file  = $dynatraceoneagent::oneagent_logmonitoring_config_file
  $oneagent_logaccess_config_file      = $dynatraceoneagent::oneagent_logaccess_config_file
  $hostgroup_config_file               = $dynatraceoneagent::hostgroup_config_file
  $hostautotag_config_file             = $dynatraceoneagent::hostautotag_config_file
  $hostmetadata_config_file            = $dynatraceoneagent::hostmetadata_config_file
  $hostname_config_file                = $dynatraceoneagent::hostname_config_file
  $oneagent_infraonly_config_file      = $dynatraceoneagent::oneagent_infraonly_config_file
  $oneagent_networkzone_config_file    = $dynatraceoneagent::oneagent_networkzone_config_file

  #if ($service_state != 'stopped') {

    file { $oneagent_puppet_conf_dir :
      ensure  => 'directory',
    }

    $oneagent_set_host_tags_array        = $host_tags.map |$value| { "--set-host-tag=${value}" }
    $oneagent_set_host_tags_params       = join($oneagent_set_host_tags_array, ' ' )
    $oneagent_set_host_metadata_array    = $host_metadata.map |$value| { "--set-host-property=${value}" }
    $oneagent_set_host_metadata_params   = join($oneagent_set_host_metadata_array, ' ' )
    $oneagent_communication_array        = $oneagent_communication_hash.map |$key,$value| { "${key}=${value}" }
    $oneagent_communication_params       = join($oneagent_communication_array, ' ' )

    if ($::kernel == 'Linux') or ($::osfamily == 'AIX') {
      $oneagentctl_exec_path                 = ['/usr/bin/', $oneagent_tools_dir]
      $oneagent_remove_host_tags_command     = "${oactl} --get-host-tags | xargs -I{} ${oactl} --remove-host-tag={}"
      $oneagent_set_host_tags_command        = "${oneagent_remove_host_tags_command}; ${oactl} ${oneagent_set_host_tags_params}"
      $oneagent_remove_host_metadata_command = "${oactl} --get-host-properties | xargs -I{} ${oactl} --remove-host-property={}"
      $oneagent_set_host_metadata_command    = "${oneagent_remove_host_metadata_command}; ${oactl} ${oneagent_set_host_metadata_params}"
    }
    elsif $::osfamily == 'Windows'{
      $oneagentctl_exec_path                 = [$dynatraceoneagent::params::windows_pwsh, $oneagent_tools_dir]
      $oneagent_remove_host_tags_command     = "powershell ${oactl} --get-host-tags | %{${oactl} --remove-host-tag=\$_}"
      $oneagent_set_host_tags_command        = "${oneagent_remove_host_tags_command}; ${oactl} ${oneagent_set_host_tags_params}"
      $oneagent_remove_host_metadata_command = "powershell ${oactl} --get-host-properties | %{${oactl} --remove-host-property=\$_}"
      $oneagent_set_host_metadata_command    = "${oneagent_remove_host_metadata_command}; ${oactl} ${oneagent_set_host_metadata_params}"
    }

    if $oneagent_communication_array.length > 0 {
      file { $oneagent_comms_config_file:
        ensure  => present,
        content => String($oneagent_communication_hash),
        notify  => Exec['set_oneagent_communication'],
        mode    => $global_mode,
      }
    } else {
      file { $oneagent_comms_config_file:
        ensure => absent,
      }
    }

    if $log_monitoring != undef {
      file { $oneagent_logmonitoring_config_file:
        ensure  => present,
        content => String($log_monitoring),
        notify  => Exec['set_log_monitoring'],
        mode    => $global_mode,
      }
    } else {
      file { $oneagent_logmonitoring_config_file:
        ensure => absent,
      }
    }

    if $log_access != undef {
      file { $oneagent_logaccess_config_file:
        ensure  => present,
        content => String($log_access),
        notify  => Exec['set_log_access'],
        mode    => $global_mode,
      }
    } else {
      file { $oneagent_logaccess_config_file:
        ensure => absent,
      }
    }

    if $host_group {
      file { $hostgroup_config_file:
        ensure  => present,
        content => $host_group,
        notify  => Exec['set_host_group'],
        mode    => $global_mode,
      }
    } else {
      file { $hostgroup_config_file:
        ensure => absent,
        notify => Exec['unset_host_group'],
      }
    }

    if $host_tags.length > 0 {
      file { $hostautotag_config_file:
        ensure  => present,
        content => String($host_tags),
        notify  => Exec['set_host_tags'],
        mode    => $global_mode,
      }
    } else {
      file { $hostautotag_config_file:
        ensure => absent,
        notify => Exec['unset_host_tags'],
      }
    }

    if $host_metadata.length > 0 {
      file { $hostmetadata_config_file:
        ensure  => present,
        content => String($host_metadata),
        notify  => Exec['set_host_metadata'],
        mode    => $global_mode,
      }
    } else {
      file { $hostmetadata_config_file:
        ensure => absent,
        notify => Exec['unset_host_metadata'],
      }
    }

    if $hostname {
      file { $hostname_config_file:
        ensure  => present,
        content => $hostname,
        notify  => Exec['set_hostname'],
        mode    => $global_mode,
      }
    } else {
      file { $hostname_config_file:
        ensure => absent,
        notify => Exec['unset_hostname'],
      }
    }

    if $infra_only != undef {
      file { $oneagent_infraonly_config_file:
        ensure  => present,
        content => String($infra_only),
        notify  => Exec['set_infra_only'],
        mode    => $global_mode,
      }
    } else {
      file { $oneagent_infraonly_config_file:
        ensure => absent,
      }
    }

    if $network_zone {
      file { $oneagent_networkzone_config_file:
        ensure  => present,
        content => $network_zone,
        notify  => Exec['set_network_zone'],
        mode    => $global_mode,
      }
    } else {
      file { $oneagent_networkzone_config_file:
        ensure => absent,
        notify => Exec['unset_network_zone'],
      }
    }

    exec { 'set_oneagent_communication':
        command     => "${oactl} ${oneagent_communication_params} --restart-service",
        path        => $oneagentctl_exec_path,
        cwd         => $oneagent_tools_dir,
        timeout     => 6000,
        provider    => $provider,
        logoutput   => on_failure,
        refreshonly => true,
    }

    exec { 'set_log_monitoring':
        command     => "${oactl} --set-app-log-content-access=${log_monitoring} --restart-service",
        path        => $oneagentctl_exec_path,
        cwd         => $oneagent_tools_dir,
        timeout     => 6000,
        provider    => $provider,
        logoutput   => on_failure,
        refreshonly => true,
    }

    exec { 'set_log_access':
        command     => "${oactl} --set-system-logs-access-enabled=${log_access} --restart-service",
        path        => $oneagentctl_exec_path,
        cwd         => $oneagent_tools_dir,
        timeout     => 6000,
        provider    => $provider,
        logoutput   => on_failure,
        refreshonly => true,
    }

    exec { 'set_host_group':
        command     => "${oactl} --set-host-group=${host_group} --restart-service",
        path        => $oneagentctl_exec_path,
        cwd         => $oneagent_tools_dir,
        timeout     => 6000,
        provider    => $provider,
        logoutput   => on_failure,
        refreshonly => true,
    }

    exec { 'unset_host_group':
        command     => "${oactl} --set-host-group= --restart-service",
        path        => $oneagentctl_exec_path,
        cwd         => $oneagent_tools_dir,
        timeout     => 6000,
        provider    => $provider,
        logoutput   => on_failure,
        refreshonly => true,
    }

    exec { 'set_host_tags':
        command     => $oneagent_set_host_tags_command,
        path        => $oneagentctl_exec_path,
        cwd         => $oneagent_tools_dir,
        timeout     => 6000,
        provider    => $provider,
        logoutput   => on_failure,
        refreshonly => true,
    }

    exec { 'unset_host_tags':
        command     => $oneagent_remove_host_tags_command,
        path        => $oneagentctl_exec_path,
        cwd         => $oneagent_tools_dir,
        timeout     => 6000,
        provider    => $provider,
        logoutput   => on_failure,
        refreshonly => true,
    }

    exec { 'set_host_metadata':
        command     => $oneagent_set_host_metadata_command,
        path        => $oneagentctl_exec_path,
        cwd         => $oneagent_tools_dir,
        timeout     => 6000,
        provider    => $provider,
        logoutput   => on_failure,
        refreshonly => true,
    }

    exec { 'unset_host_metadata':
        command     => $oneagent_remove_host_metadata_command,
        path        => $oneagentctl_exec_path,
        cwd         => $oneagent_tools_dir,
        timeout     => 6000,
        provider    => $provider,
        logoutput   => on_failure,
        refreshonly => true,
    }

    exec { 'set_hostname':
        command     => "${oactl} --set-host-name=${hostname} --restart-service",
        path        => $oneagentctl_exec_path,
        cwd         => $oneagent_tools_dir,
        timeout     => 6000,
        provider    => $provider,
        logoutput   => on_failure,
        refreshonly => true,
    }

    exec { 'unset_hostname':
        command     => "${oactl} --set-host-name=\"\" --restart-service",
        path        => $oneagentctl_exec_path,
        cwd         => $oneagent_tools_dir,
        timeout     => 6000,
        provider    => $provider,
        logoutput   => on_failure,
        refreshonly => true,
    }

    exec { 'set_infra_only':
        command     => "${oactl} --set-infra-only=${infra_only} --restart-service",
        path        => $oneagentctl_exec_path,
        cwd         => $oneagent_tools_dir,
        timeout     => 6000,
        provider    => $provider,
        logoutput   => on_failure,
        refreshonly => true,
    }

    exec { 'set_network_zone':
        command     => "${oactl} --set-network-zone=${network_zone} --restart-service",
        path        => $oneagentctl_exec_path,
        cwd         => $oneagent_tools_dir,
        timeout     => 6000,
        provider    => $provider,
        logoutput   => on_failure,
        refreshonly => true,
    }

    exec { 'unset_network_zone':
        command     => "${oactl} --set-network-zone=\"\" --restart-service",
        path        => $oneagentctl_exec_path,
        cwd         => $oneagent_tools_dir,
        timeout     => 6000,
        provider    => $provider,
        logoutput   => on_failure,
        refreshonly => true,
    }
  #}

}
