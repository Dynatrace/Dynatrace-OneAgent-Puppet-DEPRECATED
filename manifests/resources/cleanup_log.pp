# Delete logfiles
#   Parameter:
#   * $days_to_keep: how many days should be kept
#
define dynatraceoneagent::resources::cleanup_log ($days_to_keep) {
  if $::ruxit_installed_version != '0.0.0.0' {
    if $::kernel == 'windows' {
      $path = 'C:\\Program Files (x86)\\ruxit\\log'
    } elsif $::kernel == 'Linux' {
      $path = '/opt/ruxit/log'
    }
  } else {
    if $::kernel == 'windows' {
      $path = 'C:\\Program Files (x86)\\dynatrace\\oneagent\\log'
    } elsif $::kernel == 'Linux' {
      $path = '/opt/dynatrace/oneagent/log'
    }
  }

  validate_re($days_to_keep, '^\d+$')

  ensure_resource('schedule', 'log_cleanup_schedule', {
    period => daily,
    repeat => 1
  }
  )

  if $::kernel == 'windows' {
    exec { "exec_log_cleanup_win_${name}":
      command  => "forfiles -p \"${path}\" -s -m *.* -d -${days_to_keep} -c \"cmd /c del @path\"",
      path     => $::path,
      returns  => [0, 1],
      schedule => 'log_cleanup_schedule'
    }
  } elsif $::kernel == 'Linux' {
    exec { "exec_log_cleanup_lnx_${name}":
      command  => "/usr/bin/find ${path} -type f -mtime +${days_to_keep} -exec rm {} \\;",
      path     => '/usr/bin',
      returns  => [0, 1],
      schedule => 'log_cleanup_schedule'
    }
  }
}
