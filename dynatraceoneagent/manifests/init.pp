# Class: oneagent
#
# This module installs the dynatrace one agent on the host.
# To install agent define download_link -> see readme file
#
#   Parameters:
#   * download_link     => link to dynatrace oneagent
#   * $user             => the owner of files
#   * $group            => the group of the owner
#   * $log_keep_days    => set the number of days you want to keep logs => defaults to 14
#   * $service_restarts => string array with services that should be restarted after install/upgrade
#                          defaults to an empty array -> no additional service restarts
#
class dynatraceoneagent (
  $download_link,
  $user             ='dynatrace',
  $group            ='dynatrace',
  $log_keep_days    = '14',
  $statusfile       = 'oneagent',
  $service_restarts = []) {

  # os specific definitions
  if $::kernel =~ /Linux/ {
    $usr_home = "/home/${user}"
    $install_dir = "${usr_home}/oneagent"
    $installer = 'oneagent-Linux.sh'
    $install_script = 'install.sh'

  } elsif $::kernel =~ /windows/ {
    $usr_home = "C:\\Users\\${user}"
    $install_dir = "${usr_home}\\oneagent"
    $installer = 'oneagent-Windows.msi'
    $install_script = 'install.bat'
  }

  $script_mode = '0777'

  # trigger log cleanup on every run -> has a schedule defined
  dynatraceoneagent::resources::cleanup_log { 'cleanup_dynatrace_logs': days_to_keep => $log_keep_days }

  # Only do the install steps if there is no one agent installed
  if ($::ruxit_installed_version == '0.0.0.0' and $::oneagent_installed_version == '0.0.0.0') {

    # create the download directory
    file { $install_dir:
      ensure => directory,
      owner  => $user,
    }

    # get the install script from template
    # We could call the installer directly as well but this additional step gives
    # us an installer script on every host that can easily be retriggered for debug.
    file { $install_script:
      ensure  => present,
      path    => "${install_dir}/${install_script}",
      owner   => $user,
      group   => $group,
      mode    => $script_mode,
      require => File[$install_dir],
      content => template("dynatraceoneagent/${install_script}"),
    }

    # download the installer
    file { 'dynatrace_installer_download':
      ensure  => present,
      source  => $download_link,
      path    => "${install_dir}/${installer}",
      require => File[$install_dir]
    }
    ->  dynatraceoneagent::resources::install_oneagent{ 'install_oneagent': }
    ->  dynatraceoneagent::resources::restart_services_hook { $service_restarts: }
  }
  # end install
}
