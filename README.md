# Dynatrace OneAgent module for puppet

## Table of Contents

1. [Module Description - What is the Dynatrace OneAgent module and what does it do?](#module-description)
1. [Setup - The basics of getting started with the Dynatrace OneAgent](#setup)
    * [What the Dynatrace OneAgent affects](#what-the-dynatrace-oneagent-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with Dynatrace OneAgent - Installation](#beginning-with-the-dynatrace-oneagent)
1. [Usage - Configuration options and additional functionality](#usage)
    * [Most basic OneAgent installation using a SAAS tenant](#most-basic-oneagent-installation-using-a-saas-tenant)
    * [OneAgent installation using a managed tenant with a specific version](#oneagent-installation-using-a-managed-tenant-with-a-specific-version)
    * [Advanced configuration](#advanced-configuration)
    * [Set or update OneAgent configuration and host metadata](#set-or-update-oneagent-configuration-and-host-metadata)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Module description

This module deploys the [Dynatrace OneAgent] on Linux, Windows and AIX Operating Systems with different available configurations and ensures the OneAgent service maintains a running state. It provides the resource types to interact with the various OneAgent configuration files and the [oneagentctl]

## Setup

### What the Dynatrace OneAgent affects

* Installs the [Dynatrace OneAgent] package with the selected parameters and manages its config files.
* By default, enables the Dynatrace OneAgent boot-start, and uses the generated service file as part of the installer to manage the Dynatrace OneAgent service.
* Any running processes prior to installing the OneAgent package will need to be restarted for full instrumentation, a server reboot is another alternative.

### Setup requirements

This module requires [puppet/archive] as well as [puppet-labs/reboot] for server restarts.

For uninstalling the OneAgent on Windows, the [puppetlabs-powershell] module is required.

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

To have Puppet install the OneAgent, declare the `dynatraceoneagent' class:

``` puppet
class { 'dynatraceoneagent':
    tenant_url  => 'https://{your-environment-id}.live.dynatrace.com',
    paas_token  => '{your-paas-token}',
}
```

When you declare this class with the mandatory options, the module:

* downloads the required binaries needed to install the OneAgent on the target host
* Installs the OneAgent with the default installation parameters: --set-infra-only=false, --set-app-log-content-access=true
* Applies any specified configuration via the [oneagentctl]
* Ensures the Dynatrace OneAgent service is running and enabled.

## Usage

Default OneAgent install parameters defined in params.pp as a hash map: --set-infra-only=false, --set-app-log-content-access=true

### Most basic OneAgent installation using a SAAS tenant

``` puppet
class { 'dynatraceoneagent':
    tenant_url  => 'https://{your-environment-id}.live.dynatrace.com',
    paas_token  => '{your-paas-token}',
}
```

### OneAgent installation using a managed tenant with a specific version

The required version of the OneAgent must be in 1.155.275.20181112-084458 format. See [Deployment API - GET available versions of OneAgent]

``` puppet
class { 'dynatraceoneagent':
    tenant_url  => 'https://{your-domain}/e/{your-environment-id}',
    paas_token  => '{your-paas-token}',
    version     => '1.181.63.20191105-161318',
}
```

#### Verify Installer Signature (Linux/AIX Only)

Set the `verify_signature` parameter to `true` if the module should verify the signature of the OneAgent Linux/AIX installer prior to installation. If set to `true` the module will download the dynatrace root cert file to `download_dir` default value from the URL default value set for `download_cert_link` and use it for verification. If the verification fails, Puppet will attempt to delete the installer file downloaded by the [puppet/archive] module causing a failure on the remaining tasks.

``` puppet
class { 'dynatraceoneagent':
    tenant_url       => 'https://{your-environment-id}.live.dynatrace.com',
    paas_token       => '{your-paas-token}',
    verify_signature => true,
}
```

### Advanced configuration

Download OneAgent installer to a custom directory with additional OneAgent install parameters and reboot server after install should be defined as follows (will override default install params):

``` puppet
class { 'dynatraceoneagent':
    tenant_url            => 'https://{your-environment-id}.live.dynatrace.com',
    paas_token            => '{your-paas-token}',
    version               => '1.181.63.20191105-161318',
    download_dir          => 'C:\\Download Dir',
    reboot_system         => true,
    oneagent_params_hash  => {
        '--set-infra-only'             => 'false',
        '--set-app-log-content-access' => 'true',
        '--set-host-group'             => 'PUPPET_WINDOWS',
        'INSTALL_PATH'                 => 'C:\\Test Directory',
    }
}
```

For further information on how to handle file paths on Windows, visit [Files and paths on Windows]

### Set or update OneAgent configuration and host metadata

This module supports the [oneagentctl] which can be used to apply configurations as well as add/change metadata during or after the installation of the OneAgent.

``` puppet
class { 'dynatraceoneagent':
    tenant_url       => 'https://{your-domain}/e/{your-environment-id}',
    paas_token       => '{your-paas-token}',
    host_group       => 'APACHE_LINUX',
    host_metadata    => ['Environment=Dev', 'Organization=D2P', 'Owner=joe.doe@dynatrace.com', 'Support=https://www.dynatrace.com/support/windows'],
    host_tags        => ['ApacheHost', 'Gdansk', 'role=fallback', 'app=easyTravel'],
    hostname         => 'apache.puppet.vm',
    log_monitoring   => false,
    log_access       => false,
    infra_only       => true,
}
```

#### Update OneAgent communication

Use the `oneagent_communication_hash` parameter to change OneAgent communication settings during/after installation:

``` puppet
class { 'dynatraceoneagent':
    tenant_url                  => 'https://{your-domain}/e/{your-environment-id}',
    paas_token                  => '{your-paas-token}',
    oneagent_communication_hash => {
        '--set-server'       => 'https://my-server.com:443',
        '--set-tenant'       => 'abc654321',
        '--set-tenant-token' => 'abcdefg123456790',
        '--set-proxy'        => 'my-proxy.com',
    },
}
```

It is recommended that any settings that can be configured via the installation parameters are used before resorting to the [oneagentctl], see [REFERENCE.md] for supported parameters.

## Reference

Seen in file [REFERENCE.md]

## Limitations

For an extensive list of supported operating systems, see [metadata.json]

Visit [Technology Support] for details on supported Operating Systems and limitations.

Visit [oneagentctl] for details on limitations around the OneAgent command line interface.

## Development

### Testing

Acceptance tests for this module leverage [puppet_litmus](https://github.com/puppetlabs/puppet_litmus). To run the acceptance tests follow the instructions [here](https://puppetlabs.github.io/litmus/). You can also find a tutorial and walkthrough of using Litmus and the PDK on [YouTube](https://www.youtube.com/watch?v=FYfR7ZEGHoE).

An example script for running acceptance tests can be found on the [run_acc_tests.sh] file.

[Dynatrace OneAgent]: https://www.dynatrace.com/support/help/setup-and-configuration/dynatrace-oneagent/
[REFERENCE.md]: ./REFERENCE.md
[puppet/archive]: https://forge.puppet.com/puppet/archive
[puppet-labs/reboot]: https://forge.puppet.com/modules/puppetlabs/reboot
[puppetlabs-powershell]: https://forge.puppet.com/modules/puppetlabs/powershell
[dynatrace/dynatraceoneagent]:https://forge.puppet.com/dynatrace/dynatraceoneagent
[Deployment API]: https://www.dynatrace.com/support/help/extend-dynatrace/dynatrace-api/environment-api/deployment/
[Dynatrace Supported Operating Systems]:https://www.dynatrace.com/support/help/technology-support/operating-systems/
[Deployment API - GET available versions of OneAgent]: https://www.dynatrace.com/support/help/extend-dynatrace/dynatrace-api/environment-api/deployment/oneagent/get-available-versions/
[Files and paths on Windows]: https://puppet.com/docs/puppet/6/lang_windows_file_paths.html
[oneagentctl]: https://www.dynatrace.com/support/help/setup-and-configuration/dynatrace-oneagent/oneagent-configuration-via-command-line-interface
[metadata.json]: ./metadata.json
[Technology Support]: https://www.dynatrace.com/support/help/technology-support/operating-systems/
[run_acc_tests.sh]: ./scripts/run_acc_tests.sh
