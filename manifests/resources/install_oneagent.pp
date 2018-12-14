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
    command   => "${dynatraceoneagent::install_dir}/${dynatraceoneagent::install_script}",
    cwd       => $dynatraceoneagent::install_dir,
    timeout   => 6000,
    logoutput => true,
    require   => [File[$dynatraceoneagent::install_dir], File[$dynatraceoneagent::install_script], Wget::Fetch['dynatrace_installer_download']]
  }
}
