# Class: ruxit_agent
#
# This module installs the ruxit agent on the host.
# You can define which update channel you want to use and as well define a specific version you want 
# to install. If no channel/ version is given as parameter this module will install the latest stable 
# ruxit agent version.
#
#   Parameters:
#   * $user             => the owner of files
#   * $group            => the group of the owner
#   * $ruxit_tenant     => your ruxit tenant
#   * $ruxit_token      => the token for your tenant
#   * $ruxit_server     => the ruxit server to connect to => defaults to https://{tenant}.live.ruxit.com
#   * $version          => a defined version to install => defaults to latest
#   * $channel          => define the channel you want to use => defaults to stable
#   * $log_keep_days    => set the number of days you want to keep logs => defaults to 14
#   * $service_restarts => string array with services that should be restarted after install/upgrade
#                          defaults to an empty array -> no additional service restarts
#
class ruxit_agent (
  $user,
  $group,
  $ruxit_tenant,
  $ruxit_token,
  $ruxit_server     = '',
  $version          = '',
  $channel          = 'stable',
  $log_keep_days    = '14',
  $service_restarts = []
  ) {
  if $ruxit_server == '' {
    $ruxit_host = "https://${ruxit_tenant}.live.ruxit.com"
  } else {
    $ruxit_host = $ruxit_server
  }
  # os specific definitions
  if $::kernel =~ /Linux/ {
    $usr_home       = "/home/${user}"
    $install_dir    = "${usr_home}/ruxit-agent"
    $installer_pre  = 'ruxit-Agent-Linux-'
    $installer_ext  = '.sh'
    $install_script = 'install.sh'

  } elsif $::kernel =~ /windows/ {
    $usr_home       = "C:\\Users\\${user}"
    $install_dir    = "${usr_home}\\ruxit-agent"
    $installer_pre  = 'ruxit-Agent-Windows-'
    $installer_ext  = '.msi'
    $install_script = 'install.bat'
  }

  # required version and source selection
  case $channel {
    /dev/      : {
      # use the development channel
      $src            = 'http://download-dev.ruxitlabs.com/agent/unstable'
      $latest_version = $::ruxit_latest_version_dev
    }
    /sprint/   : {
      # use the sprint channel
      $src            = 'http://download-sprint.ruxitlabs.com/agent/unstable'
      $latest_version = $::ruxit_latest_version_sprint
    }
    /unstable/ : {
      # use the release unstable channel
      $src            = 'http://download.ruxit.com/agent/unstable'
      $latest_version = $::ruxit_latest_version_unstable
    }
    default    : {
      # use the release stable channel as default
      $src            = 'http://download.ruxit.com/agent'
      $latest_version = $::ruxit_latest_version_stable
    }
  }
  $ruxit_required_version = empty($version) ? {
    true    => $latest_version,
    default => $version
  }
  $script_mode          = '0777'

  # trigger log cleanup on every run -> has a schedule defined
  ruxit_agent::resources::cleanup_log { 'cleanup_ruxit_logs': days_to_keep => $log_keep_days }

  # Only do the install steps if there is no ruxit agent installed
  if (!empty($ruxit_required_version) and $ruxit_required_version != '0.0.0.0' and $::ruxit_installed_version == '0.0.0.0') {
    $installer = "${installer_pre}${ruxit_required_version}${installer_ext}"

    # create the download directory
    file { $install_dir:
      ensure => directory,
      owner  => $::usr,
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
      content => template("ruxit_agent/${install_script}"),
    }

    # download the installer for the required version
    download { 'ruxit_installer_download':
      uri     => "${src}/${installer}",
      dest    => "${install_dir}/${installer}",
      require => File[$install_dir]
    }
    ->
    ruxit_agent::resources::install_ruxit_agent { $ruxit_required_version: }
    ->
    ruxit_agent::resources::restart_services_hook { $service_restarts: }
  }
  # end install
}