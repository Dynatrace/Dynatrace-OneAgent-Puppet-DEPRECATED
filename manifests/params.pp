# Class: dynatraceoneagent::params
#
#
# Dynatrace OneAgent default download and install settings according to operating system
#
class dynatraceoneagent::params {

    $global_mode = '0644'

    # OneAgent Download Parameters
    $tenant_url         = undef
    $paas_token         = undef
    $api_path           = '/api/v1/deployment/installer/agent/'
    $version            = 'latest'
    $arch               = 'all'
    $installer_type     = 'default'
    $proxy_server       = undef
    $allow_insecure     = false
    $verify_signature   = false
    $download_cert_link = 'https://ca.dynatrace.com/dt-root.cert.pem'
    $cert_file_name     = 'dt-root.cert.pem'

    # OneAgent Install Parameters
    $oneagent_params_hash = {
        '--set-infra-only'             => 'false',
        '--set-app-log-content-access' => 'true',
    }
    $reboot_system      = false
    $service_state      = 'running'
    $package_state      = 'present'

    # OneAgent Host Configuration Parameters
    $host_tags                   = []
    $host_metadata               = []
    $hostname                    = undef
    $oneagent_communication_hash = {}
    $log_monitoring              = undef
    $log_access                  = undef
    $host_group                  = undef
    $infra_only                  = undef
    $network_zone                = undef

    if $::osfamily == 'Windows' {
        #Parameters for Windows OneAgent Download
        $os_type                    = 'windows'
        $download_dir               = 'C:\\Windows\\Temp'
        #Parameters for Windows OneAgent Installer
        $global_owner                       = 'Administrator'
        $global_group                       = 'Administrators'
        $service_name                       = 'Dynatrace OneAgent'
        $provider                           = 'windows'
        $default_install_dir                = "${::dynatrace_oneagent_programfiles}\\dynatrace\\oneagent"
        $oneagent_ctl                       = 'oneagentctl.exe'
        $windows_pwsh                       = "${::system32}\\WindowsPowerShell\\v1.0"
        $require_value                      = Package[$service_name]
        $oneagent_puppet_conf_dir           = "${::dynatrace_oneagent_appdata}\\dynatrace\\oneagent\\agent\\config\\puppet"
        $oneagent_comms_config_file         = "${oneagent_puppet_conf_dir}\\deployment.conf"
        $oneagent_logmonitoring_config_file = "${oneagent_puppet_conf_dir}\\logmonitoring.conf"
        $oneagent_logaccess_config_file     = "${oneagent_puppet_conf_dir}\\logaccess.conf"
        $hostgroup_config_file              = "${oneagent_puppet_conf_dir}\\hostgroup.conf"
        $hostautotag_config_file            = "${oneagent_puppet_conf_dir}\\puppethostautotag.conf"
        $hostname_config_file               = "${oneagent_puppet_conf_dir}\\hostname.conf"
        $hostmetadata_config_file           = "${oneagent_puppet_conf_dir}\\hostcustomproperties.conf"
        $oneagent_infraonly_config_file     = "${oneagent_puppet_conf_dir}\\infraonly.conf"
        $oneagent_networkzone_config_file   = "${oneagent_puppet_conf_dir}\\networkzone.conf"
    } elsif ($::kernel == 'Linux') or ($::osfamily == 'AIX')  {
        #Parameters for Linux/AIX OneAgent Download
        $download_dir               = '/tmp'
        #Parameters for Linux/AIX OneAgent Installer
        $global_owner                       = 'root'
        $global_group                       = 'root'
        $service_name                       = 'oneagent'
        $provider                           = 'shell'
        $default_install_dir                = '/opt/dynatrace/oneagent'
        $oneagent_ctl                       = 'oneagentctl'
        $require_value                      = Exec['install_oneagent']
        $oneagent_puppet_conf_dir           = '/var/lib/dynatrace/oneagent/agent/config/puppet'
        $oneagent_comms_config_file         = "${oneagent_puppet_conf_dir}/deployment.conf"
        $oneagent_logmonitoring_config_file = "${oneagent_puppet_conf_dir}/logmonitoring.conf"
        $oneagent_logaccess_config_file     = "${oneagent_puppet_conf_dir}/logaccess.conf"
        $hostgroup_config_file              = "${oneagent_puppet_conf_dir}/hostgroup.conf"
        $hostautotag_config_file            = "${oneagent_puppet_conf_dir}/hostautotag.conf"
        $hostmetadata_config_file           = "${oneagent_puppet_conf_dir}/hostcustomproperties.conf"
        $hostname_config_file               = "${oneagent_puppet_conf_dir}/hostname.conf"
        $oneagent_infraonly_config_file     = "${oneagent_puppet_conf_dir}/infraonly.conf"
        $oneagent_networkzone_config_file   = "${oneagent_puppet_conf_dir}/networkzone.conf"
    }
}
