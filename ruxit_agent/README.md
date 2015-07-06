## Overview

This module downloads and installs the [ruxit](http://www.ruxit.com/) unified agent on windows and linux systems.

### Sample Usage

#### Example 1
```puppet
class { 'ruxit_agent':
  user          => 'test',
  group         => 'test',
  ruxit_tenant  => 'yxcvbnm',
  ruxit_token   => 'TOKEN',
}
```
This example will download the current stable release agent to a directory owned by user/group test and connect it to the given ruxit tenant. [Tenant id](#ruxit_tenant) and [tenant token](#ruxit_token) are required in order to connect the ruxit agent to your account.

#### Example 2
```puppet
class { 'ruxit_agent': }
```
or 
```puppet
include ruxit_agent
```
This example will install the corresponding version if all non-optional parameters can be resolved via hiera. It will fail otherwise! 

##License
This module is provided under BSD-3-Clause license. Please check out the details in the LICENSE.txt

##Reference

###Classes
###ruxit_agent: 
Main class, includes everything else

###Parameters
The following parameters are available in the `ruxit_agent` class:

####`user`
The owner of files. 
!! This user is not created by this module. Please make sure it exists. !!

####`group`
The group for the owner of files.

####`ruxit_tenant`
Your ruxit tenant ID is the unique identifier of your ruxit environment. You can find it easily by looking at the URL in your browser when you are logged into your Ruxit home page.

<code>https://{tenant}.live.ruxit.com</code>

The subdomain {tenant} represents your tenant id.

####`ruxit_token`
The token for your ruxit tenant. You can get your token by following these steps

1. go to your ruxit environment: https://{tenant}.live.ruxit.com
2. Click the burger menu in the right upper corner and select **Monitor another host**
3. You will see the "Download Ruxit Agent" wizard; click **Linux** (even if you need Windows)
4. You will see the **wget** command line. The token is the last part of the path after **/latest/**
    
    <code>wget -O ruxit-Agent-Linux-1.XX.0.2015XXXX-XXXXXX.sh https://{tenant}.live.ruxit.com/installer/agent/unix/latest/{this-is-the-token}</code>
5. copy it and use it in your puppet config

####`ruxit_server`
The ruxit server to connect to. This defaults to the https://{tenant}.live.ruxit.com


####`version`
If set the defined version of the ruxit agent will be installed. 
If set to an empty string the latest version for the channel will be installed.
Defaults to '' -> latest

####`channel`
Define the install/update channel you want to use. This is for ruxit internal purposes only right now.
* dev -> development branch (highly unstable)
* sprint -> development branch (unstable)
* unstable -> release branch (unstable)
* stable -> release branch (stable)
defaults to stable

####`log_keep_days`
Sets the number of days you want to keep logs.
defaults to 14 days

####`service_restarts` 
String array with services that should be restarted after install/upgrade.
defaults to an empty array -> no additional service restarts

###Resources

####`cleanup_log`
A resource cleaning all files in a given directory that were not modified in the given time frame.

####`install_ruxit_agent`
Installs the agent from and to the paths defined in the main class.

####`linux_restart_service`
A resource that triggers restarts of init.d based services.

####`restart_services_hook`
This resource is called after the installation of the ruxit agent to restart services that should be instrumented.
You can define the services as a parameter of the main class: service_restarts

####`windows_restart_service`
A resource wrapper for service stop and start.

####`windows_restart_service`
A resource starting a given windows service.

####`windows_restart_service`
A resource stopping a given windows service.

## Supported OSes
This module is designed for Windows and Linux systems. 
If it does not work for your environment please get in touch via the project site.
