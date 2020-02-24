# Dynatrace OneAgent module for puppet

### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with the Dynatrace OneAgent](#setup)
    * [What the Dynatrace OneAgent affects](#what-the-dynatrace-oneagent-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with the Dynatrace OneAgent](#beginning-with-the-dynatrace-oneagent)
1. [Usage - Configuration options and additional functionality](#usage)
    * [Most basic OneAgent installation using a SAAS tenant](#most-basic-oneagent-installation-using-a-saas-tenant)
    * [OneAgent installation using a managed tenant with a specific version](#oneagent-installation-using-a-managed-tenant-with-a-specific-version)
    * [Advanced configuration](#advanced-configuration)
    * [Setting tags, metadata and custom hostname](#setting-tags-metadata-and-custom-hostname)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Module description

This module deploys the Dynatrace OneAgent on Linux, Windows and AIX Operating Systems with different available configurations and ensures the OneAgent service maintains a running state. It provides the resource types to interact with the various OneAgent configuration files.

## Setup

### What the Dynatrace OneAgent affects

* Installs the Dynatrace OneAgent package with the selected parameters and manages its config files.
* By default, enables the Dynatrace OneAgent boot-start, and uses the generated service file as part of the installer to manage the Dynatrace OneAgent service.
* Any running processes prior to installing the OneAgent package will need to be restarted for full instrumentation, a server reboot is another alternative.

### Setup requirements

This module requires [puppet/archive] as well as [puppet-labs/reboot] for Windows restarts.

To begin using this module, use the Puppet Module Tool (PMT) from the command line to install this module:

```bash
puppet module install dynatrace-dynatraceoneagent
```

You will then need to supply the dynatraceoneagent class with two critical pieces of information.

* The tenant URL: **Managed** `https://{your-domain}/e/{your-environment-id}` |  **SaaS** `https://{your-environment-id}.live.dynatrace.com`
* The PaaS token of your environment for downloading the OneAgent installer

Refer to the customize OneAgent installation documentation on [Dynatrace Supported Operating Systems]
This module uses the Dynatrace deployment API for downloading the installer for each supported OS. See [Deployment API]

### Beginning with the Dynatrace OneAgent

Once the Dynatrace OneAgent packages are downloaded to the target hosts using the archive module, the module is ready to deploy.

## Usage

Default OneAgent install parameters defined in params.pp as a hash map: INFRA_ONLY=0, APP_LOG_CONTENT_ACCESS=1

### Most basic OneAgent installation using a SAAS tenant

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
