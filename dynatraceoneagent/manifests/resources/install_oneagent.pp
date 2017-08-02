# install one agent binary
define dynatraceoneagent::resources::install_oneagent () {
  if $::kernel =~ /Linux/ {
    $install_dest_dir = '/opt/ruxit/agent'
  } else {
    $install_dest_dir = 'C:\\Program Files (x86)\\ruxit\\agent'
  }

  $servicename_linux = 'oneagent'
  $servicename_windows = 'Dynatrace OneAgent'

  exec { 'install_oneagent':
    command   => "${oneagent::install_dir}/${oneagent::install_script}",
    cwd       => $oneagent::install_dir,
    timeout   => 6000,
    logoutput => true,
    require   => [File[$oneagent::install_dir], File[$oneagent::install_script], File['dynatrace_installer_download']]
  }
}
