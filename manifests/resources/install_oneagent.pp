# install one agent binary
define dynatraceoneagent::resources::install_oneagent () {

  exec { 'install_oneagent':
    command   => "${dynatraceoneagent::install_dir}/${dynatraceoneagent::install_script}",
    cwd       => $dynatraceoneagent::install_dir,
    timeout   => 6000,
    logoutput => true,
    require   => [File[$dynatraceoneagent::install_dir], File[$dynatraceoneagent::install_script], File['dynatrace_installer_download']]
  }
}
