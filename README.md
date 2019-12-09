# Dynatrace OneAgent module for puppet

## Description

This module installs the OneAgent on Linux, Windows and AIX Operating Systems

## Requirements

Requires [puppet/archive](https://forge.puppet.com/puppet/archive)

Requires [puppet-labs/reboot](https://forge.puppet.com/puppetlabs/reboot) for Windows reboots

## Installation

Available from GitHub (via cloning) or via Puppet forge [dynatrace/dynatraceoneagent](https://forge.puppet.com/dynatrace/dynatraceoneagent)

Refer to the customize OneAgent installation documentation on [Dynatrace Supported Operating Systems](https://www.dynatrace.com/support/help/technology-support/operating-systems/)

This module uses the Dynatrace deployment API for downloading the installer for each supported OS. See [Deployment API](https://www.dynatrace.com/support/help/extend-dynatrace/dynatrace-api/environment-api/deployment/)

## Usage

Look at init.pp to see what can be configured.

Default OneAgent install parameters defined in params.pp as a hash map: INFRA_ONLY=0, APP_LOG_CONTENT_ACCESS=1

Sample latest OneAgent version installation using a SAAS tenant

    class { 'dynatraceoneagent':
        tenant_url  => 'https://{your-environment-id}.live.dynatrace.com',
        paas_token  => '{your-paas-token}',
    }

Sample OneAgent installation using a managed tenant with a specific version. The required version of the OneAgent must be in 1.155.275.20181112-084458 format. See [Deployment API - GET available versions of OneAgent](https://www.dynatrace.com/support/help/extend-dynatrace/dynatrace-api/environment-api/deployment/oneagent/get-available-versions/)

    class { 'dynatraceoneagent':
        tenant_url  => 'https://{your-domain}/e/{your-environment-id}',
        paas_token  => '{your-paas-token}',
        version     => '1.181.63.20191105-161318',
    }

## Advanced configuration

Download OneAgent installer to a custom directory with additional OneAgent install parameters and reboot server after install should be defined as follows (will override default install params):

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

For Windows, because download_dir is a string variable, 2 backslashes are required

Since the oneagent install parameter INSTALL_PATH can be defined within a hash map, no escaping is needed for Windows file paths

For further information on how to handle file paths on Windows, visit [Handling file paths on Windows](https://puppet.com/docs/puppet/4.10/lang_windows_file_paths.html)

## Parameters

### `tenant_url` - required

URL of your dynatrace Tenant

- Managed: `https://{your-domain}/e/{your-environment-id}`
- SaaS: `https://{your-environment-id}.live.dynatrace.com`

### `paas_token` - required

PAAS token for downloading one agent installer

### `version` - optional

The required version of the OneAgent in 1.155.275.20181112-084458 format - default is latest

### `arch` - optional

The architecture of your OS - default is all

### `installer_type` - optional

The type of the installer - default is default

### `download_dir` - optional

OneAgent installer file download directory. Defaults are:

- Linux/AIX : `/tmp/`
- Windows   : `C:\Windows\Temp\`

### `oneagent_params_hash` - optional

Hash map of additional parameters to pass to the installer

Default OneAgent install parameters defined in params.pp as a hash map:

- `INFRA_ONLY => 0`
- `APP_LOG_CONTENT_ACCESS => 1`

### `reboot_system` - optional

If set to true, puppet will reboot the server after installing the OneAgent - default is false
