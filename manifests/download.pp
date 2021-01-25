# @summary
#   This class downloads the OneAgent installer binary
#
class dynatraceoneagent::download {

  if !defined('archive') {
    class { 'archive':
      seven_zip_provider => '',
    }
  }

  $created_dir              = $dynatraceoneagent::created_dir
  $download_dir             = $dynatraceoneagent::download_dir
  $filename                 = $dynatraceoneagent::filename
  $download_path            = $dynatraceoneagent::download_path
  $proxy_server             = $dynatraceoneagent::proxy_server
  $allow_insecure           = $dynatraceoneagent::allow_insecure
  $download_link            = $dynatraceoneagent::download_link
  $download_cert_link       = $dynatraceoneagent::download_cert_link
  $cert_file_name           = $dynatraceoneagent::cert_file_name
  $provider                 = $dynatraceoneagent::provider
  $oneagent_params_hash     = $dynatraceoneagent::oneagent_params_hash
  $reboot_system            = $dynatraceoneagent::reboot_system
  $service_name             = $dynatraceoneagent::service_name
  $package_state            = $dynatraceoneagent::package_state
  $global_owner             = $dynatraceoneagent::global_owner
  $global_group             = $dynatraceoneagent::global_group
  $global_mode              = $dynatraceoneagent::global_mode

  if $package_state != 'absent' {
    file{ $download_dir:
      ensure => directory
    }

    archive{ $filename:
      ensure         => present,
      extract        => false,
      source         => $download_link,
      path           => $download_path,
      allow_insecure => $allow_insecure,
      require        => File[$download_dir],
      creates        => $created_dir,
      proxy_server   => $proxy_server,
      cleanup        => false,
    }
  }

  if $package_state != 'absent' {
    file{ $download_path:
      mode   => '0755',
    }
  }

  if ($dynatraceoneagent::verify_signature) and ($package_state != 'absent') and ($::kernel == 'Linux') {

    archive{ $dynatraceoneagent::cert_file_name:
      ensure         => present,
      extract        => false,
      source         => $download_cert_link,
      path           => $dynatraceoneagent::dt_root_cert,
      allow_insecure => $allow_insecure,
      require        => File[$download_dir],
      creates        => $dynatraceoneagent::cert_file_name,
      proxy_server   => $proxy_server,
      cleanup        => false,
    }

    file{ $dynatraceoneagent::dt_root_cert:
      ensure => file,
      mode   => $global_mode,
    }

    $verify_signature_command = "( echo 'Content-Type: multipart/signed; protocol=\"application/x-pkcs7-signature\"; micalg=\"sha-256\";\
     boundary=\"--SIGNED-INSTALLER\"'; echo ; echo ; echo '----SIGNED-INSTALLER' ; \
     cat ${download_path} ) | openssl cms -verify -CAfile ${dynatraceoneagent::dt_root_cert} > /dev/null"

    exec { 'delete_oneagent_installer_script':
        command   => "rm ${$download_path}",
        cwd       => $download_dir,
        timeout   => 6000,
        provider  => $provider,
        logoutput => on_failure,
        unless    => $verify_signature_command,
        require   => File[$dynatraceoneagent::dt_root_cert, $download_path],
        creates   => $created_dir,
    }
  }
}
