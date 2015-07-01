# Start a linux system service init /etc/init.d
define ruxit_agent::resources::linux_restartservice_initd () {

  $init_file = "/etc/init.d/${name}"

  exec{ "check_init_d_file_exists_${init_file}" :
    command   => "/usr/bin/test -f ${init_file}",
    logoutput => false,
  }
  ->
  exec{ "restart-${name}":
    command => "${init_file} restart",
  }
}
