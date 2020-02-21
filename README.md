# Dynatrace OneAgent module for puppet

## Description

This module deploys the Dynatrace OneAgent on Linux, Windows and AIX Operating Systems with different available configurations and ensures the OneAgent service maintains a running state. It provides the resource types to interact with the various OneAgent configuration files.

## Setup

### Setup requirements

This module requires [puppet/archive] as well as [puppet-labs/reboot] for Windows restarts.

To begin using this module, use the Puppet Module Tool (PMT) from the command line to install this module:

```bash
puppet module install dynatrace-dynatraceoneagent
```

You will then need to supply the dynatraceoneagent class with two critical pieces of information.

- The tenant URL: **Managed** `https://{your-domain}/e/{your-environment-id}` |  **SaaS** `https://{your-environment-id}.live.dynatrace.com`
- The PaaS token of your environment for downloading the OneAgent installer

Refer to the customize OneAgent installation documentation on [Dynatrace Supported Operating Systems]
This module uses the Dynatrace deployment API for downloading the installer for each supported OS. See [Deployment API]

## Usage

Default OneAgent install parameters defined in params.pp as a hash map: INFRA_ONLY=0, APP_LOG_CONTENT_ACCESS=1

Most basic OneAgent installation using a SAAS tenant:

```bash
    class { 'dynatraceoneagent':
        tenant_url  => 'https://{your-environment-id}.live.dynatrace.com',
        paas_token  => '{your-paas-token}',
    }
```

### OneAgent installation using a managed tenant with a specific version

The required version of the OneAgent must be in 1.155.275.20181112-084458 format. See [Deployment API - GET available versions of OneAgent]

```bash
    class { 'dynatraceoneagent':
        tenant_url  => 'https://{your-domain}/e/{your-environment-id}',
        paas_token  => '{your-paas-token}',
        version     => '1.181.63.20191105-161318',
    }
```

### Advanced configuration

Download OneAgent installer to a custom directory with additional OneAgent install parameters and reboot server after install should be defined as follows (will override default install params):

```bash
    class { 'dynatraceoneagent':
        tenant_url            => 'https://{your-environment-id}.live.dynatrace.com',
        paas_token            => '{your-paas-token}',
        version               => '1.181.63.20191105-161318',
        download_dir          => 'C:\\Download Dir\\',
        reboot_system         => true,
        oneagent_params_hash  => {
            'INFRA_ONLY'             => '0',
            'APP_LOG_CONTENT_ACCESS' => '1',
            'HOST_GROUP'             => 'PUPPET_WINDOWS',
            'INSTALL_PATH'           => 'C:\Test Directory',
        }
    }
```

For Windows, because download_dir is a string variable, 2 backslashes are required
Since the OneAgent install parameter INSTALL_PATH can be defined within a hash map, no escaping is needed for Windows file paths
For further information on how to handle file paths on Windows, visit [Handling file paths on Windows]

### Setting tags, metadata and custom hostname

Configure values to automatically add tags and metadata to a host and override an automatically detected host name, the values should contain a list of strings or key/value pairs. Spaces are used to separate tag and metadata values.

```bash
    class { 'dynatraceoneagent':
        tenant_url       => 'https://{your-domain}/e/{your-environment-id}',
        paas_token       => '{your-paas-token}',
        host_tags        => 'TestHost Gdansk role=fallback',
        host_metadata    => 'Environment=Prod Organization=D1P Owner=john.doe@dynatrace.com Support=https://www.dynatrace.com/support',
        hostname         => 'apache-vm.puppet.vm',
        }
    }
```

## Reference

Seen in file [REFERENCE.md]

## Limitations

TBD

## Development

TBD

[REFERENCE.md]: ./REFERENCE.md
[puppet/archive]: https://forge.puppet.com/puppet/archive
[puppet-labs/reboot]: https://forge.puppet.com/puppetlabs/reboots
[dynatrace/dynatraceoneagent]:https://forge.puppet.com/dynatrace/dynatraceoneagent
[Deployment API]: https://www.dynatrace.com/support/help/extend-dynatrace/dynatrace-api/environment-api/deployment/
[Dynatrace Supported Operating Systems]:https://www.dynatrace.com/support/help/technology-support/operating-systems/
[Deployment API - GET available versions of OneAgent]: https://www.dynatrace.com/support/help/extend-dynatrace/dynatrace-api/environment-api/deployment/oneagent/get-available-versions/
[Handling file paths on Windows]: https://puppet.com/docs/puppet/4.10/lang_windows_file_paths.html
