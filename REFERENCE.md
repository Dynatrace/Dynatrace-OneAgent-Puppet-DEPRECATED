
# Reference

## Classes

### dynatraceoneagent

Install and configure the Dynatrace OneAgent.

### Parameters

The following parameters are available in the dynatraceoneagent class.

#### `tenant_url` - required

Data Type: `String`

URL of your dynatrace Tenant

- Managed: `https://{your-domain}/e/{your-environment-id}`
- SaaS: `https://{your-environment-id}.live.dynatrace.com`

Default value: $dynatraceoneagent::params::tenant_url

#### `paas_token` - required

Data Type: `String`

PAAS token for downloading one agent installer

Default value: dynatraceoneagent::params::paas_token

#### `version` - optional

Data Type: `String`

The required version of the OneAgent in 1.155.275.20181112-084458 format

Default value: latest

#### `arch` - optional

Data Type: `String`

The architecture of your OS

Default value is all

#### `installer_type` - optional

Data Type: `String`

The type of the installer

Default value: default

#### `download_dir` - optional

Data Type: `String`

OneAgent installer file download directory.

Defaults values are:

- Linux/AIX : `/tmp/`
- Windows   : `C:\Windows\Temp\`

#### `oneagent_params_hash` - optional

Data Type: `String`

Hash map of additional parameters to pass to the installer

Default OneAgent install parameters defined in params.pp as a hash map.

Default values are:

- `INFRA_ONLY => 0`
- `APP_LOG_CONTENT_ACCESS => 1`

#### `reboot_system` - optional

Data Type: `Boolean`

If set to true, puppet will reboot the server after installing the OneAgent

Default: false

#### `host_tags` - optional

Data Type: `String`

Values to automatically add tags to a host, should contain a list of strings or key/value pairs. Spaces are used to separate tag values.

Default value: $dynatraceoneagent::params::host_tags

#### `host_metadata` - optional

Data Type: `String`

Values to automatically add metadata to a host, should contain a list of strings or key/value pairs. Spaces are used to separate metadata values.

Default value: $dynatraceoneagent::params::host_metadata

#### `hostname` - optional

Data Type: `String`

Overrides an automatically detected host name.

Default value: $dynatraceoneagent::params::hostname
