# @summary
#   This module deploys the OneAgent on Linux, Windows and AIX Operating Systems with different available configurations and ensures
#   the OneAgent service maintains a running state. It provides types/providers to interact with the various OneAgent configuration points.
#
# @example
#    class { 'dynatraceoneagent':
#        tenant_url  => 'https://{your-environment-id}.live.dynatrace.com',
#        paas_token  => '{your-paas-token}',
#    }
#
# @param global_mode
#   Sets the permissions for any files that don't have 
#   this assignment either set manually or by the OneAgent installer
# @param tenant_url
#   URL of your dynatrace Tenant
#   Managed `https://{your-domain}/e/{your-environment-id}` - SaaS `https://{your-environment-id}.live.dynatrace.com`
# @param paas_token
#   Paas token for downloading the OneAgent installer
# @param api_path
#   Path of the Dynatrace OneAgent deployment API
# @param version          
#   The required version of the OneAgent in 1.155.275.20181112-084458 format
# @param arch
#   The architecture of your OS - default is all
# @param installer_type
#   The type of the installer - default is default
# @param verify_signature
#   Verify OneAgent installer signature (Linux only).
# @param proxy_server
#   Proxy server to be used by the archive module for downloading the OneAgent installer if needed
# @param download_cert_link
#   Link for downloading dynatrace root cert pem file
# @param cert_file_name
#   Name of the downloaded cert file
# @param ca_cert_src_path
#   Location of dynatrace root cert file in module
# @param allow_insecure
#   Ignore HTTPS certificate errors when using the archive module.
# @param download_options
#   In some cases you may need custom flags for curl/wget/s3 which can be supplied via download_options.
#   Refer to [Download Customizations](https://github.com/voxpupuli/puppet-archive#download-customizations)
# @param download_dir
#   OneAgent installer file download directory.
# @param default_install_dir
#   OneAgent default install directory
# @param oneagent_params_hash
#   Hash map of additional parameters to pass to the installer
#   Refer to the Customize OneAgent installation documentation on [Technology Support](https://www.dynatrace.com/support/help/technology-support/operating-systems/)
# @param reboot_system
#   If set to true, puppet will reboot the server after installing the OneAgent - default is false
# @param service_state
#   What state the dynatrace oneagent service should be in - default is running
#   Allowed values: running, stopped
# @param manage_service
#   Whether puppet should manage the state of the OneAgent service - default is true
# @param service_name
#   The name of the dynatrace OneAgent based on the OS
# @param package_state
#   What state the dynatrace oneagent package should be in - default is present
#   Allowed values: present, absent
# @param host_tags
#   Values to automatically add tags to a host, 
#   should contain an array of strings or key/value pairs. 
#   For example: ['Environment=Prod', 'Organization=D1P', 'Owner=john.doe@dynatrace.com', 'Support=https://www.dynatrace.com/support/linux']
# @param host_metadata
#   Values to automatically add metadata to a host, 
#   Should contain an array of strings or key/value pairs. 
#   For example: ['LinuxHost', 'Gdansk', 'role=fallback', 'app=easyTravel']
# @param hostname
#   Overrides an automatically detected host name. Example: My App Server
# @param oneagent_communication_hash
#   Hash map of parameters used to change OneAgent communication settings
#   Refer to Change OneAgent communication settings on [Communication Settings](https://www.dynatrace.com/support/help/shortlink/oneagentctl#change-oneagent-communication-settings)
# @param log_monitoring
#   Enable or disable Log Monitoring
# @param log_access
#   Enable or disable access to system logs
# @param host_group
#   Change host group assignment
# @param infra_only
#   Enable or disable Infrastructure Monitoring mode 
# @param network_zone
#   Set the network zone for the host
# @param oneagent_puppet_conf_dir
#   Directory puppet will use to store oneagent configurations
# @param oneagent_ctl
#   Name of oneagentctl executable file
# @param provider
#   The specific backend to use for this exec resource.
# @param oneagent_comms_config_file
#   Configuration file location for OneAgent communication
# @param oneagent_logmonitoring_config_file
#   Configuration file location for OneAgent log monitoring
# @param oneagent_logaccess_config_file
#   Configuration file location for OneAgent log access
# @param hostgroup_config_file
#   Configuration file location for OneAgent host group value
# @param hostmetadata_config_file
#   Configuration file location for OneAgent host metadata value(s)
# @param hostautotag_config_file
#   Configuration file location for OneAgent host tag value(s)
# @param hostname_config_file
#   Configuration file location for OneAgent host name value
# @param oneagent_infraonly_config_file
#   Configuration file location for OneAgent infra only mode
# @param oneagent_networkzone_config_file
#   Configuration file location for OneAgent network zone value
#
class dynatraceoneagent (
  String $global_mode  = $dynatraceoneagent::params::global_mode,

# OneAgent Download Parameters
  String $tenant_url                    = $dynatraceoneagent::params::tenant_url,
  String $paas_token                    = $dynatraceoneagent::params::paas_token,
  String $api_path                      = $dynatraceoneagent::params::api_path,
  String $version                       = $dynatraceoneagent::params::version,
  String $arch                          = $dynatraceoneagent::params::arch,
  String $installer_type                = $dynatraceoneagent::params::installer_type,
  Optional[Boolean] $verify_signature   = $dynatraceoneagent::params::verify_signature,
  Optional[String] $proxy_server        = $dynatraceoneagent::params::proxy_server,
  Optional[String] $download_cert_link  = $dynatraceoneagent::params::download_cert_link,
  Optional[String] $cert_file_name      = $dynatraceoneagent::params::cert_file_name,
  Optional[String] $ca_cert_src_path    = $dynatraceoneagent::params::ca_cert_src_path,
  Optional[Boolean] $allow_insecure     = $dynatraceoneagent::params::allow_insecure,
  Optional $download_options            = $dynatraceoneagent::params::download_options,

# OneAgent Install Parameters
  String $download_dir                   = $dynatraceoneagent::params::download_dir,
  String $service_name                   = $dynatraceoneagent::params::service_name,
  String $provider                       = $dynatraceoneagent::params::provider,
  String $default_install_dir            = $dynatraceoneagent::params::default_install_dir,
  Hash $oneagent_params_hash             = $dynatraceoneagent::params::oneagent_params_hash,
  Boolean $reboot_system                 = $dynatraceoneagent::params::reboot_system,
  String $service_state                  = $dynatraceoneagent::params::service_state,
  Boolean $manage_service                = $dynatraceoneagent::params::manage_service,
  String $package_state                  = $dynatraceoneagent::params::package_state,

# OneAgent Host Configuration Parameters
  Optional[Hash] $oneagent_communication_hash = $dynatraceoneagent::params::oneagent_communication_hash,
  Optional[Boolean] $log_monitoring           = $dynatraceoneagent::params::log_monitoring,
  Optional[Boolean] $log_access               = $dynatraceoneagent::params::log_access,
  Optional[String] $host_group                = $dynatraceoneagent::params::host_group,
  Optional[Array] $host_tags                  = $dynatraceoneagent::params::host_tags,
  Optional[Array] $host_metadata              = $dynatraceoneagent::params::host_metadata,
  Optional[String] $hostname                  = $dynatraceoneagent::params::hostname,
  Optional[Boolean] $infra_only               = $dynatraceoneagent::params::infra_only,
  Optional[String] $network_zone              = $dynatraceoneagent::params::network_zone,
  String $oneagent_ctl                        = $dynatraceoneagent::params::oneagent_ctl,
  String $oneagent_puppet_conf_dir            = $dynatraceoneagent::params::oneagent_puppet_conf_dir,
  String $oneagent_comms_config_file          = $dynatraceoneagent::params::oneagent_comms_config_file,
  String $oneagent_logmonitoring_config_file  = $dynatraceoneagent::params::oneagent_logmonitoring_config_file,
  String $oneagent_logaccess_config_file      = $dynatraceoneagent::params::oneagent_logaccess_config_file,
  String $hostgroup_config_file               = $dynatraceoneagent::params::hostgroup_config_file,
  String $hostautotag_config_file             = $dynatraceoneagent::params::hostautotag_config_file,
  String $hostmetadata_config_file            = $dynatraceoneagent::params::hostmetadata_config_file,
  String $hostname_config_file                = $dynatraceoneagent::params::hostname_config_file,
  String $oneagent_infraonly_config_file      = $dynatraceoneagent::params::oneagent_infraonly_config_file,
  String $oneagent_networkzone_config_file    = $dynatraceoneagent::params::oneagent_networkzone_config_file,

) inherits dynatraceoneagent::params {

    if $::kernel == 'Linux' {
      $os_type = 'unix'
    } elsif $::osfamily  == 'AIX' {
      $os_type = 'aix'
    }

    if $oneagent_params_hash['INSTALL_PATH']{
      $install_dir = $oneagent_params_hash['INSTALL_PATH']
    } else {
      $install_dir = $default_install_dir
    }

    if $version == 'latest' {
      $download_link  = "${tenant_url}${api_path}${os_type}/${installer_type}/latest/?Api-Token=${paas_token}&arch=${arch}"
    } else {
      $download_link  = "${tenant_url}${api_path}${os_type}/${installer_type}/version/${version}?Api-Token=${paas_token}&arch=${arch}"
    }

    if $::osfamily == 'Windows' {
      $filename                = "Dynatrace-OneAgent-${::osfamily}-${version}.exe"
      $download_path           = "${download_dir}\\${filename}"
      $created_dir             = "${install_dir}\\agent\\agent.state"
      $oneagent_tools_dir      = "${install_dir}\\agent\\tools"
    } elsif ($::kernel == 'Linux') or ($::osfamily  == 'AIX') {
      $filename                 = "Dynatrace-OneAgent-${::kernel}-${version}.sh"
      $download_path            = "${download_dir}/${filename}"
      $dt_root_cert             = "${download_dir}/${cert_file_name}"
      $oneagent_params_array    = $oneagent_params_hash.map |$key,$value| { "${key}=${value}" }
      $oneagent_unix_params     = join($oneagent_params_array, ' ' )
      $command                  = "/bin/sh ${download_path} ${oneagent_unix_params}"
      $created_dir              = "${install_dir}/agent/agent.state"
      $oneagent_tools_dir       = "${$install_dir}/agent/tools"
    }

  if $package_state != 'absent' {
    contain dynatraceoneagent::download
    contain dynatraceoneagent::install
    contain dynatraceoneagent::config
    contain dynatraceoneagent::service

    Class['::dynatraceoneagent::download']
    -> Class['::dynatraceoneagent::install']
    -> Class['::dynatraceoneagent::config']
    -> Class['::dynatraceoneagent::service']
  } else {
    contain dynatraceoneagent::uninstall

    Class['::dynatraceoneagent::uninstall']
  }

}
