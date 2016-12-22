# install ruxit agent binary
define ruxit_agent::resources::install_ruxit_agent ($required_version = '') {
  if $::kernel =~ /Linux/ {
    $install_dest_dir = '/opt/ruxit/agent'
  } else {
    $install_dest_dir = 'C:\\Program Files (x86)\\ruxit\\agent'
  }

  if versioncmp('1.100', $required_version) > 0 {
    $servicename_linux = 'ruxitagent'
    $servicename_windows = 'ruxit Agent'
  } else {
    $servicename_linux = 'oneagent'
    $servicename_windows = 'Dynatrace OneAgent'
  }

  exec { 'install_ruxit_agent':
    command   => "${ruxit_agent::install_dir}/${ruxit_agent::install_script}",
    cwd       => $ruxit_agent::install_dir,
    timeout   => 600,
    logoutput => true,
    require   => [File[$ruxit_agent::install_dir], File[$ruxit_agent::install_script], Download['ruxit_installer_download']]
  }

  # restart the agent
  if $::kernel =~ /Linux/ {
    ruxit_agent::resources::linux_restartservice_initd { $servicename_linux: subscribe => Exec['install_ruxit_agent'] }
  } else {
    ruxit_agent::resources::windows_restartservice { $servicename_windows: subscribe => Exec['install_ruxit_agent'] }
  }
}